# Ancestral state estimation 
### Code by V Deepak
### Tidied by Natalie Cooper Mar 2021

#-------------------------
# Load libraries
#-------------------------
library(ape)
library(tidyverse)
library(geiger)
#-------------------------------------
# Read in the tree and tidy the names
#-------------------------------------
tree <- read.nexus("data/datedtree.nexus")

# Fix up species names
# These are weird because the tip labels include sequence info

# 1. Remove the seq_ tag from the start of the name
tree$tip.label <- str_remove(tree$tip.label, "seq_[:alpha:]+_\\d+_")

# 2. Remove the punctuation in some of the names
tree$tip.label <- str_remove_all(tree$tip.label, "[\']")

# 3. Remove the codes from the last two tips which do not have seq
tree$tip.label <- str_remove(tree$tip.label, "AF544663_")
tree$tip.label <- str_remove(tree$tip.label, "KC347516_")

# Check the tree has the right number of tips, and nodes
# i.e. 258 tips and 257 nodes
tree
#-------------------------------------
# Read in the  metadata and tidy names
#-------------------------------------
ds <- read_csv("data/trait_data_natricine_2021-03.csv")

# First replace spaces with _
ds <-
  ds %>%
  mutate(Species = str_replace_all(Species, " ", "_")) %>%
  dplyr::select(-c(X10:X13))

#----------------------------------------
# Get summary data for habits and diet
#----------------------------------------
# Drop species with no habit data
ds_new <- 
  ds %>%
  filter(Habit != "NA")

# Get summary of habit information for manuscript
ds_new %>%
  group_by(Habit) %>%
  summarise(N = n(), percentage = (N/nrow(ds_new)) * 100)

# Get summary of diet information for manuscript
ds_new %>%
  group_by(Diet) %>%
  summarise(N = n(), percentage = (N/nrow(ds_new)) * 100)

#----------------------------------------------------------------
# Match up the tree to the data
#--------------------------------------------------------------
# Now see if the names match using name.check
matches <- name.check(phy = tree, data = ds_new, data.names = ds$Species)

# Use drop.tip, and tell it to remove the species you found above that
# are not in the data
tree_new <- drop.tip(tree, matches$tree_not_data)

# Remove the missing species from the data
fix <- match(ds_new$Species, matches$data_not_tree, nomatch = 0)
ds_new <- subset(ds_new, fix == 0)

# Then order ds_new so it's the same order as the tree
ds_new <- ds_new[match(tree_new$tip.label, ds_new$Species),]

# Make sure ds_new is a dataframe
ds_new <- as.data.frame(ds_new)
ds_new
#--------------------------------------------------------
# Ancestral state estimations and plots
#--------------------------------------------------------
# Reorder ds_new so it's the same order as the tree
ds_new <- ds_new[match(tree_new$tip.label, ds_new$Species), ]

#----------------------------------------------------------------
# Set up colour palettes
#----------------------------------------------------------------
mycolours_habit <- c("blue", "#51dacf", "#c8808b", "#85d272", "#5b5b5b")

mycolours_diet <- c("#f7be16", "green", "blue", "red", "yellow", 
                    "brown", "black", "pink", "pink", "pink", "pink", "pink")

mycolours_repro <- c("#5bb274", "#4166af")

#-----------------
# Set up PDF
#-----------------

pdf("outputs/Figure_ancestral-states-all.pdf", height = 10, width = 10)
par(mfrow = c(2,2))

#-----------
# REPRO MODE
#-----------
# Estimate ancestral states
ancestors_repro <- ace(ds_new$Reproduction, tree_new, type = "d")

# Plot
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = mycolours_repro[as.factor(ds_new$Reproduction)], cex = 1, adj = 1)
nodelabels(pie = ancestors_repro$lik.anc, piecol = mycolours_repro, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Reproduction)),
       fill = mycolours_repro, xpd = T, bty = "n", cex = 0.6, title = "repro mode")

#-----------
# DIET
#-----------
# Estimate ancestral states
ancestors_diet <- ace(ds_new$Diet, tree_new, type = "d")

# Plot habits 
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = mycolours_diet[as.factor(ds_new$Diet)], cex = 1, adj = 1)
nodelabels(pie = ancestors_diet$lik.anc, piecol = mycolours_diet, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Diet)),
       fill = mycolours_diet, xpd = T, bty = "n", cex = 0.5, title = "diet")

#-----------
# HABIT
#-----------
# Estimate ancestral states
ancestors_habit <- ace(ds_new$Habit, tree_new, type = "d")

# Plot habits 
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = mycolours_habit[as.factor(ds_new$Habit)], cex = 1, adj = 1)
nodelabels(pie = ancestors_habit$lik.anc, piecol = mycolours_habit, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Habit)),
       fill = mycolours_habit, xpd = T, bty = "n", cex = 0.6, title = "habit")

#-----------
# Close PDF
#-----------
dev.off()
