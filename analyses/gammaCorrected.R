# corrected gamma value to take into account the maximum value gamma can take, according to McPeek (2008)

gammaCorrected <- function (phy) {
	
	gammaStat(phy)->gamma_phy
	
	Ntip(phy)-> x
	
	(1/2)/sqrt(1/(12*(x-2)))-> gamma_Max
	
	gamma_phy/gamma_Max -> result
	
	return(result)
	
}