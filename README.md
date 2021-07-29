# NATRICINE-traits
Code for Natricine traits paper from V.Deepak's NATRICINE MSCA project. 

*This README is a work in progress...*

Author(s): V.Deepak, Gustavo Burin and Natalie Cooper.

This repository contains the R code and data used in the manuscript *Multilocus phylogeny, natural-history traits, and classification of natricine (Serpentes: Natricinae) snakes* [Link to final published pdf will be here](). Analyses done using other packages are not included here.

To cite the paper: 
> DEEPAK, V., NATALIE COOPER, NIKOLAY A. POYARKOV, FRED KRAUS, ABHIJIT DAS, SURYA NARAYANAN, JEFFERY W. STREICHER, GUSTAVO BURIN, SARAH-JANE SMITH and DAVID J. GOWER. Multilocus phylogeny, natural-history traits, and classification of natricine (Serpentes: Natricinae) snakes. 2021. Zoological Journal of the Linnaean Society. In revision. 

To cite this repo: 
> DEEPAK, V., GUSTAVO BURIN, and NATALIE COOPER. NATRICINE-traits. R code for the paper. ZENODO LINK TO BE ADDED ON ACCEPTANCE.

![Figure 6](https://github.com/nhcooper123/NATRICINE-traits/blob/main/outputs/Figure6-tree-with-traits.png)

------

## Data

Data required to run the analyses is included in the `data/` folder. The full dataset and sets of trees from the paper are available on the NHM Data Portal [here]( https://doi.org/10.5519/0070625). If you use these data please cite the data portal:

> Deepak V, Cooper N, Gower DJ. 2020. Dataset: NATRICINE. Natural History Museum Data Portal (data.nhm.ac.uk). https://doi.org/10.5519/0070625.

------

## Analyses
All code used to run R analyses and make figures is included in the `analyses/` folder. Before starting remember to open an RStudio project from that folder. Note that analyses using something other than R are not included here. BioGeoBEARS analyses were written by V.Deepak. BAMM analyses were written by Gustavo Burin. Remaining code was written by V Deepak, and tidied by Natalie Cooper.

* *01-BioGeoBEARS*. BioGeoBEARS code and data [Deepak]. Runs biogeography analyses, results in Table 4, and Figure 3.
* *02-summary_bamm.Rmd*. [Gustavo] Runs the BAMM analyses and trait transition analyses. Figures 4 and 5, supplementary Figure S2. Results in Table 5, supplementary Tables S5 and S6.
* *03-four-trait-tree-figures.R*. Creates Figure 6.
* *04-ancestral-state-estimation.R*. Runs ancestral state estimations for natural history traits and creates supplementary Figure S3
* *05-plot-phylogeny-node-support.R*. Code for adding support values to branches of phylogenies.

-------
## Other folders

* `/outputs` contains the figures created in R. Figure 1 used PhotoShop. Figure 2 used FigTree and PhotoShop.
