# NATRICINE
Code for papers from V.Deepak's NATRICINE MSCA project

*This README is a work in progress...*

Author(s): V.Deepak and Natalie Cooper.

This repository contains all the code and data used in the manuscript [Link to final published pdf will be here]().

To cite the paper: 
> 

To cite this repo: 
> 


![alt text](https://github.com/nhcooper123/natricine/raw/master/outputs/GMM/PC123-diet-habit-GMM.png)

------

## Data


------
## Analyses
All code used to run analyses and make figures is included in the `analyses/` folder. Before starting remember to open an RStudio project from that folder.

### Running the analyses 
The main analyses are in the following scripts within the `analyses/Linear` folder.

1. *XXXX.R*. 

We also repeated several analyses using landmarks that represent the head shape of the snakes. These analyses are found in the `analyses/GMM` folder.

-------
## Other folders

* `/outputs` contains the figures and tables. These are in two folders, one for the main analyses (Linear) and another for the supplementary GMM analyses.


------
## Session Info
For reproducibility purposes, here is the output of `devtools:session_info()` used to perform the analyses in the publication.

## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2020-03-01") 
```
