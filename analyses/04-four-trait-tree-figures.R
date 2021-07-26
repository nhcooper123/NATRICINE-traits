# Code for figure 4 (this was then modified in illustrator) 
### Code by V Deepak
### Tidied by Natalie Cooper Apr 2021

#-------------------------
# Load libraries
#-------------------------
library(ape)
library(tidyverse)
library(geiger)
library(ggtree)
library(ggnewscale)
#----------------------------------------------------------------
# Read in the tree and edit species names
#------------------------------------------------------------------
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
# i.e. 249 tips and 248 nodes
tree

#----------------------------------------------------------------
# Match up the tree to the data
#--------------------------------------------------------------
# Read in the  metadata
ds <- read_csv("data/trait_data_natricine_geography.csv")

# Replace spaces with _
ds <-
  ds %>%
  mutate(Species = str_replace_all(Species, " ", "_"))

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = ds, data.names = ds$Species)

# Use drop.tip, and tell it to remove the species you found above that
# are not in the data
tree_new <- drop.tip(tree, matches$tree_not_data)

# Remove the missing species from the data
fix <- match(ds$Species, matches$data_not_tree, nomatch = 0)
ds_new <- subset(ds, fix == 0)

# Then order ds_new so it's the same order as the tree
ds_new <- ds_new[match(tree_new$tip.label, ds_new$Species),]

# Make sure ds_new is a dataframe
ds_new <- as.data.frame(ds_new)
ds_new
#----------------------------------------------------------------
# Create subsets of the data with just the variables of interest
# Make sure they are factors
# Add species names as rownames
#----------------------------------------------------------------
diet_data <- 
  ds_new %>%
  mutate(diet = as.factor(Diet)) %>%
  select(diet)
# Add rownames as species names
rownames(diet_data) <- tree_new$tip.label

repro_data <- 
  ds_new %>%
  mutate(repro = as.factor(Reproduction)) %>%
  select(repro)
# Add rownames as species names
rownames(repro_data) <- tree_new$tip.label

habit_data <- 
  ds_new %>%
  mutate(habit = as.factor(Habit)) %>%
  select(habit)
# Add rownames as species names
rownames(habit_data) <- tree_new$tip.label

origin_data <- 
  ds_new %>%
  mutate(Distribution = as.factor(Geography)) %>%
  select(Distribution)
# Add rownames as species names
rownames(origin_data) <- tree_new$tip.label

#----------------------------------------------------------------
# Set up colour palettes
#----------------------------------------------------------------
mycolours_habit <- c("blue", "#51dacf", "#c8808b", "#85d272", "#5b5b5b")

mycolours_diet <- c("#f7be16", "green", "blue", "red", "yellow", 
                    "brown", "black", "pink", "pink", "pink", "pink", "pink")

mycolours_repro <- c("#5bb274", "#4166af")
mycolours_origin <- c("#00ffff", "#ff00bf", "#ffbf00", "#ff0000", "#8000ff", "#cd9fe2","#0040ff", "#80ff00" )
#----------------------------------------------------------------
# Make trees using ggtree
# Note that this code will throw lots of warnings about scales
# which can be ignored
#----------------------------------------------------------------
# Make the tree base
base_tree <- ggtree(tree_new, layout = "rectangular")

# Plot the first thing (reproductive mode)
# This will throw some warnings about scales which can be ignored
p1 <- 
  gheatmap(base_tree, origin_data, offset = 0, width =.1, colnames = FALSE) +
  scale_fill_manual(values = mycolours_origin, name = "distribution", guide = guide_legend(order = 1))

# To add a different scale bar requires a bit of code
# from ggnewscale()
p2 <- p1 + new_scale_fill()

# Now plot the second trait, slightly further out
# distance is controlled by the offset value
# This will throw some warnings about scales which can be ignored
p3 <- 
  gheatmap(p2, repro_data, offset =4, width =.1, colnames = FALSE) +
  scale_fill_manual(values = mycolours_repro, name = "reproductive mode", guide = guide_legend(order = 2))

# To add a different scale bar requires a bit of code
# from ggnewscale()
p4 <- p3 + new_scale_fill()

# Now plot the third trait, slightly further out
# distance is controlled by the offset value
# This will throw some warnings about scales which can be ignored
p5 <- 
  gheatmap(p4, diet_data, offset = 8, width =.1, colnames = FALSE) +
  scale_fill_manual(values = mycolours_diet, name = "diet", guide = guide_legend(order =3))

p6 <- p5 + new_scale_fill()

# Now plot the fourth trait, slightly further out
# distance is controlled by the offset value
# This will throw some warnings about scales which can be ignored
p7 <- 
  gheatmap(p6, habit_data, offset = 12, width =.1, colnames = FALSE) +
  scale_fill_manual(values = mycolours_habit, name = "habit", guide = guide_legend(order =4))

# Save the plot
ggsave(p7, filename = "outputs/Figure5-tree-with-traits.png", height = 8.5)
