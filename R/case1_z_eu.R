#' Euphotic depth function based on Morel and Berthon (1989, Limnol. Oceanogr., Vol 34: 1545-1562) Case I model
#' 
#' Convert chlorophyll concentration to euphotic depth
#' 
#' @param chl_mean A numeric vector of chlorophyll_a surface concentration in milligrams chlorophyl per cubic meter

#' @return euphotic depth in meter
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @references Morel A, Berthon J-F (1989) Surface pigments, algal biomass profiles, and potential production of the euphotic layer: Relationships reinvestigated in view of remote-sensing applications. Limnology and Oceanography 34:1545–1562
#' @export

case1_z_eu<-function(chl_mean){
  ## Calculate chl_tot from Satellite Surface Chlorophyll Data.
  chl_tot<-ifelse(chl_mean<1, 38*chl_mean^0.425, 40.2*chl_mean^0.507)  
  
  ## Calculate euphotic depth (z_eu) with Morel's Case I model.
  z_eu <- 200*chl_tot^-0.293
  z_eu<-ifelse(z_eu<=102, 568.2*chl_tot^-0.746, z_eu)
  return(z_eu)
}