### Plot phylogeny with node support values
### Code by V Deepak
### Tidied by Natalie Cooper Mar 2021

#------------------------------
# Install packages from GitHub
#-----------------------------
# install.packages("remotes")
# remotes::install_github("fmichonneau/phyloch")

#-------------------------
# Load libraries
#-------------------------
library(phyloch)
library(ape)
library(tidyverse)
library(geiger)
library(treeio) # Install via Bioconductor
#-------------------------------------------------
# Read in the tree and tidy names
# Note this is an unrooted ML tree
#-------------------------------------------------
treeML <- read.tree("data/259leaves_ML.tre")

# Fix up species names
# These are weird because the tip labels include sequence info

# 1. Remove the seq_ tag from the start of the name
treeML$tip.label <- str_remove(treeML$tip.label, "seq_[:alpha:]+_\\d+_")

# 2. Note there are some labels with "-" instead of "_" which is removed here
treeML$tip.label <- str_remove(treeML$tip.label, "seq_[:alpha:]+-\\d+_")

# 3. Remove the punctuation in some of the names
treeML$tip.label <- str_remove_all(treeML$tip.label, "[\']")

# Check the tree has the right number of tips, and nodes
# i.e. 259 tips and 258 nodes
treeML

#-------------------------------------------------
# Extract node labels with support values
#-------------------------------------------------
# Extract support values from node labels
nodelabels <- treeML$node.label

# Make this into a dataframe
nodelabels <- as.data.frame(nodelabels)

# Write to file
# write_csv(nodelabels, path = "outputs/node-labels-ML-tree.csv")
#-------------------------------------------------
# Root tree and remove outgroups 
#-------------------------------------------------
# Drop Grayia as we only need one outgroup to root
treeML <- drop.tip(treeML, "Grayia_ornata")

# Now root the tree on Sibynophis
treeML <- root(treeML, "Sibynophis_subpunctatus")

# Delete the outgroup
treeML <- drop.tip(treeML, "Sibynophis_subpunctatus")

#-------------------------------------------------
# Plot the tree with support values
#-------------------------------------------------
# Save PDF output figure as 12X40 portrait 
pdf("outputs/all-bootstrap-values-ML-tree.pdf", height = 40, width = 12)

# Plot arranged tree
plot(ladderize(treeML, FALSE), main = " ")
# Add scale bar
add.scale.bar(x = 0.0, y = -0.7)

# Display bootstrap support as values 
node.support(treeML$node.label, 
             cutoff = 0.9, 
             pos = "pretty",
             col = "blue")

# Stop saving to PDF
dev.off()

#-------------------------------------------------
# Plot the tree with support values > 0.9 as dots
#-------------------------------------------------
# Save PDF output figure as 12X40 portrait 
pdf("outputs/all-supported-nodes-ML-tree.pdf", height = 40, width = 12)

# New plot
plot(ladderize(treeML, FALSE), main = " ")
# Add scale bar
add.scale.bar(x = 0.0, y = -0.7)

# Display support as coloured nodes by omitting nodes below threshold 0.9
node.support(treeML$node.label, 
             cutoff = 0.9, 
             mode = "dots",
             col = "blue")

# Stop saving to PDF
dev.off()

#-------------------------------------------------------
# Read in the 50% majority rule consensus tree and tidy
# The format is different from ML output.
#------------------------------------------------------
treeBI <- treeio::read.mrbayes("data/PA.out.con.tre")

# Fix up species names
# 1. Remove the seq_ tag from the start of the name
treeBI@phylo$tip.label <- str_remove(treeBI@phylo$tip.label, "seq_[:alpha:]+_\\d+_")

# 2. Note there are some labels with "-" instead of "_" which is removed here
treeBI@phylo$tip.label <- str_remove(treeBI@phylo$tip.label, "seq_[:alpha:]+-\\d+_")

# 3. Remove the punctuation in some of the names
treeBI@phylo$tip.label <- str_remove_all(treeBI@phylo$tip.label, "[\']")

# Check the tree has the right number of tips, and nodes
# i.e. 260 tips and 238 nodes
treeBI@phylo

#-------------------------------------------------
# Root tree and remove outgroups 
#-------------------------------------------------
treeBI <- root(treeBI@phylo, "Grayia_ornata")

# Now drop the outgroups
treeBI <- drop.tip(treeBI, "Sibynophis_subpunctatus")
treeBI <- drop.tip(treeBI, "Grayia_ornata")


plot(treeBI@phylo, cex = 0.5)

plot(ladderize(treeBI@phylo, FALSE), main=" ")
add.scale.bar(x=0.0, y=-0.7)


node.support(round(as.numeric(treeBI@data$prob),2), cutoff = 0.95, pos = "above", cex = 0.5)

node.support(round(as.numeric(treeBI@data$prob),2), cutoff = 0.95, pos = "above", cex = 0.5, mode = "dots",
             col = "blue")

#-------------------------------------------------
# Plot the tree with support values
#-------------------------------------------------
# Save PDF output figure as 12X40 portrait 
pdf("outputs/all-support-values-BI-tree.pdf", height = 40, width = 12)

# Plot arranged tree
plot(ladderize(treeBI@phylo, FALSE), main = " ")
# Add scale bar
add.scale.bar(x = 0.0, y = -0.7)

# Display Bayes support as values 
node.support(round(as.numeric(treeBI@data$prob),2), 
             cutoff = 0.95, 
             pos = "above", 
             col = "blue")

# Stop saving to PDF
dev.off()

#-------------------------------------------------
# Plot the tree with support values > 0.95 as dots
#-------------------------------------------------
# Save PDF output figure as 12X40 portrait 
pdf("outputs/all-supported-nodes-BI-tree.pdf", height = 40, width = 12)

# New plot
plot(ladderize(treeBI@phylo, FALSE), main = " ")
# Add scale bar
add.scale.bar(x = 0.0, y = -0.7)

# Display support as coloured nodes by omitting nodes below threshold 0.9
node.support(round(as.numeric(treeBI@data$prob),2), 
             cutoff = 0.95, 
             pos = "above", 
             mode = "dots",
             col = "blue")

# Stop saving to PDF
dev.off()