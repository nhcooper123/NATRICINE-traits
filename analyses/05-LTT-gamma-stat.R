### Code for Lineage through time plots
### Code by V Deepak
### Tidied by Natalie Cooper Apr 2021

#-------------------------
# Load libraries
#-------------------------
library(ape)
library(tidyverse)
library(geiger)
library(phytools)
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

# Make sure tree is ultrametric
tree <- force.ultrametric(tree)

# Check the tree has the right number of tips, and nodes
# i.e. 249 tips and 248 nodes
tree

#----------------------------------------------------------------
# Read in the metadata
#--------------------------------------------------------------
# Read in the  metadata
ds <- read_csv("data/trait_data_natricine-corrected.csv")

# Replace spaces with _
ds <-
  ds %>%
  mutate(Species = str_replace_all(Species, " ", "_"))

#--------------------------------------------------------------
# Extract species for each clade and subet the tree
#--------------------------------------------------------------
# Extract species from african clade
Afr <- filter(ds, OriginLTT == "African")
Afr <- pull(Afr, Species)

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = Afr, data.names = Afr)

# Remove non African species from the tree
African <- drop.tip(tree, matches$tree_not_data)
#--------------------------------------------------------------
# Extract species from NAmerican clade
Amer <- filter(ds, OriginLTT == "American")
Amer <- pull(Amer, Species)

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = Amer, data.names = Amer)

# Remove non NAmerican species from the tree
American <- drop.tip(tree, matches$tree_not_data)
#--------------------------------------------------------------
# S,E & SE Asia (including Australia) = Origin
Asia1 <- filter(ds, Origin == "Asian")
Asia1 <- pull(Asia1, Species)

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = Asia1, data.names = Asia1)

# Match trees 
Asian1 <- drop.tip(tree, matches$tree_not_data)
#--------------------------------------------------------------
# S,E & SE Asia (excluding Australia) = OriginLTT2
Asia2 <- filter(ds, OriginLTT2 == "Asian")
Asia2 <- pull(Asia2, Species)

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = Asia2, data.names = Asia2)

# Match trees 
Asian2 <- drop.tip(tree, matches$tree_not_data)
#--------------------------------------------------------------
# S,E & SE Asia (including Europe, North Africa & Central Asia, excluding Australia)=OriginLTT1
Asia3 <- filter(ds, OriginLTT1 == "Asian")
Asia3 <- pull(Asia3, Species)

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = Asia3, data.names = Asia3)

# Match trees 
Asian3 <- drop.tip(tree, matches$tree_not_data)
#--------------------------------------------------------------
# Extract species from north European clade
Europe <- filter(ds, OriginLTT == "Asian-European")
Europe <- pull(Europe, Species)

# Now see if the names match using name.check
matches <- name.check(phy = tree, data = Europe, data.names = Europe)

# Match trees 
European <- drop.tip(tree, matches$tree_not_data)
#--------------------------------------------------------------
# Lineage through time plots & gamma stats
#--------------------------------------------------------------
# Extract gamma stats for all clades
ltt(American, gamma = TRUE)
ltt(African, gamma = TRUE)
ltt(Asian1, gamma = TRUE)
ltt(Asian2, gamma = TRUE)
ltt(Asian3, gamma = TRUE)
ltt(European, gamma = TRUE)

#--------------------------------------------------------------
# Simulate 200 pure-birth trees for comparison and plot LTTs
#--------------------------------------------------------------
# Set up PDF
#-----------------
pdf("outputs/Figure_LTTs.pdf", height = 10, width = 10)
par(mfrow = c(3, 2))

#-----------------------------------------------------------------
# American lineage plot
# Simulate 200 trees with same number of species as American tree
# scale rescales tree to have total length equal to American tree
NAmericatrees <- pbtree(n = length(American$tip.label), nsim = 200, 
                        scale = max(nodeHeights(American)))
# Plot LTT plot for 200 simulated trees
ltt95(NAmericatrees, log = TRUE)
# Add title
title(main = "North & Central America")
# Add observed data as red dashed line
ltt(American, add = TRUE, log.lineages = FALSE, 
                    col = "red", lwd = 2, lty = "dashed")

#-----------------------------------------------------------------
# African
SSAtrees <- pbtree(n = length(African$tip.label), nsim = 200,
                   scale = max(nodeHeights(African)))
ltt95(SSAtrees, log = TRUE)
title(main = "sub-Saharan Africa (including Seychelles")
ltt(African, add = TRUE, log.lineages = FALSE, 
                col = "red", lwd = 2, lty = "dashed")

#-----------------------------------------------------------------
# Europe
Eurotrees <- pbtree(n = length(European$tip.label), nsim = 200,
                    scale = max(nodeHeights(European)))
ltt95(Eurotrees, log = TRUE)
title(main = "Europe, North Africa & Central Asia")
ltt(European, add = TRUE, log.lineages = FALSE, 
                 col = "red", lwd = 2, lty = "dashed")

#-----------------------------------------------------------------
# S,E & SE Asia (including Australia) = Origin
As1trees <- pbtree(n = length(Asian1$tip.label), nsim = 200,
                   scale = max(nodeHeights(Asian1)))
ltt95(As1trees, log = TRUE)
title(main = "S, E & SE Asia (including Australia)")
ltt(Asian1, add = TRUE, log.lineages = FALSE, 
    col = "red", lwd = 2, lty = "dashed")

#-----------------------------------------------------------------
# S,E & SE Asia (excluding Australia) = OriginLTT2
As2trees <- pbtree(n = length(Asian2$tip.label), nsim = 200, 
                  scale = max(nodeHeights(Asian2)))
ltt95(As2trees, log = TRUE)
title(main = "S, E & SE Asia (excluding Australia)")
ltt(Asian2, add = TRUE, log.lineages = FALSE, 
                col = "red", lwd = 2, lty = "dashed")

#-----------------------------------------------------------------
# S,E & SE Asia (including Europe, North Africa & Central Asia, excluding Australia)=OriginLTT1
As3trees <- pbtree(n = length(Asian3$tip.label), nsim = 200,
                 scale = max(nodeHeights(Asian3)))
ltt95(As3trees, log = TRUE)
title(main = "S,E & SE Asia (including Europe, North Africa & Central Asia, excluding Australia)")
ltt(Asian3, add = TRUE, log.lineages = FALSE, 
             col = "red", lwd = 2, lty = "dashed")



#--------
# End PDF
dev.off()
