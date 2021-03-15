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
tree <- read.nexus("data/natic_comb dated.nexus")

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
ds <- read_csv("data/morpho_data_totalphylo.csv")

# First replace spaces with _
ds <-
  ds %>%
  mutate(Species = str_replace_all(Species, " ", "_"))

#----------------------------------------
# Get summary data for habits and diet
#----------------------------------------
# Drop species with no habit data
ds_new <- 
  ds %>%
  filter(Habit2 != "NA")

# Get summary of habit information for manuscript
ds_new %>%
  group_by(Habit2) %>%
  summarise(N = n(), percentage = (N/nrow(ds_new)) * 100)

# Get summary of diet information for manuscript
ds_new %>%
  group_by(Diet) %>%
  summarise(N = n(), percentage = (N/nrow(ds_new)) * 100)

#----------------------------------
# Matching up the tree to the data
#---------------------------------
# See if the names match using name.check
matches <- name.check(phy = tree, data = ds, data.names = ds$Species)

# These are species in the data, but not in the tree
# matches$data_not_tree
# No species missing from the tree

# These are species in the TREE, but not in the data
# matches$tree_not_data
# 2 species missing from the data

# Remove the species that are not in the data
tree_new <- drop.tip(tree, matches$tree_not_data)

# Check the tree has the right number of tips, and nodes
# i.e. 256 tips and 255 nodes
tree_new

#--------------------------------------------------------
# Ancestral state estimations and plots
#--------------------------------------------------------
# Reorder ds_new so it's the same order as the tree
ds_new <- ds_new[match(tree_new$tip.label, ds_new$Species), ]

#----------------------------------------------------------------
# Set up colour palettes
#----------------------------------------------------------------
colours_habit<- c("blue", "#51dacf", "red", "#85d272", "#ffb997")

colours_diet <- c("#f7be16", "green", "blue", "red", "yellow", 
                    "brown", "black", "pink")

colours_repro <- c("green", "blue")

colours_origin <- c("pink", "green", "blue", "yellow")

#-----------------
# Set up PDF
#-----------------

pdf("outputs/ancestral-states-all.pdf", height = 10, width = 10)
par(mfrow = c(2,2))

#-----------
# REPRO MODE
#-----------
# Estimate ancestral states
ancestors_repro <- ace(ds_new$Reproduction, tree_new, type = "d")

# Plot
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = colours_repro[as.factor(ds_new$Reproduction)], cex = 1, adj = 1)
nodelabels(pie = ancestors_repro$lik.anc, piecol = colours_repro, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Reproduction)),
       fill = colours_repro, xpd = T, bty = "n", cex = 0.6, title = "repro mode")

#-----------
# ORIGIN
#-----------
# Estimate ancestral states
ancestors_origin<- ace(ds_new$Origin, tree_new, type = "d")

# Plot
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = colours_origin[as.factor(ds_new$Origin)], cex = 1, adj = 1)
nodelabels(pie = ancestors_origin$lik.anc, piecol = colours_origin, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Origin)),
       fill = colours_origin, xpd = T, bty = "n", cex = 0.6, title = "origin")

#-----------
# DIET
#-----------
# Estimate ancestral states
ancestors_diet <- ace(ds_new$Diet, tree_new, type = "d")

# Plot habits 
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = colours_diet[as.factor(ds_new$Diet)], cex = 1, adj = 1)
nodelabels(pie = ancestors_diet$lik.anc, piecol = colours_diet, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Diet)),
       fill = colours_diet, xpd = T, bty = "n", cex = 0.5, title = "diet")

#-----------
# HABIT
#-----------
# Estimate ancestral states
ancestors_habit <- ace(ds_new$Habit2, tree_new, type = "d")

# Plot habits 
plot.phylo(tree_new, label.offset = 2, show.tip.label = FALSE, type = "fan", no.margin = TRUE)
tiplabels(offset = 1, pch = 21, bg = colours_habit[as.factor(ds_new$Habit2)], cex = 1, adj = 1)
nodelabels(pie = ancestors_habit$lik.anc, piecol = colours_habit, cex = 0.5)
legend("topright", legend = levels(as.factor(ds_new$Habit2)),
       fill = colours_habit, xpd = T, bty = "n", cex = 0.6, title = "habit")

#-----------
# Close PDF
#-----------
dev.off()
