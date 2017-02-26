#' Export POC flux function based on Lutz et al. (2007, J. Geophys. Res., Vol 112, C10011)
#' 
#' Convert mean and seasonal index of primary production and export depth to export POC flux
#' 
#' @param npp_mean A numeric vector of nnual mean surface production
#' @param npp_svi A numeric vector of Seasonal variation index of production (SVI; annual standard deviation divided by average)
#' @param z_ex A numeric vector of eport depth = water depth (z) - euphotic depth (z_eu)
#' @describeIn lutz_p_flux the labile fraction of export
prd<-function(npp_svi)(31*npp_svi^2+49*npp_svi+7.8)*10^-3
#' @describeIn lutz_p_flux remineralization length scale
rld<-function(npp_svi)1400*exp(0.54*npp_svi)
#' @describeIn lutz_p_flux rapidly sinking fraction of export
prr<-function(npp_svi)(2.6*npp_svi^2-4.2*npp_svi+4.8)*10^-3
#' @describeIn lutz_p_flux Annual Particulate Organic Carbon Flux to Depth Normalized to Overlying Production
p.ratio<-function(prd, z_ex, rld, prr)prd*exp(-z_ex/rld)+prr
#' @return Export POC flux in the same unit as input primary production
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @references Lutz MJ, Caldeira K, Dunbar RB, Behrenfeld MJ (2007) Seasonal rhythms of net primary production and particulate organic carbon flux to depth describe the efficiency of biological pump in the global ocean. Journal of Geophysical Research: Oceans 112:C10011
#' @export
lutz_p_flux<-function(npp_mean, npp_svi, z_ex){
  prd<-(31*npp_svi^2+49*npp_svi+7.8)*10^-3
  rld<-1400*exp(0.54*npp_svi)
  prr<-(2.6*npp_svi^2-4.2*npp_svi+4.8)*10^-3
  p.ratio<-prd*exp(-z_ex/rld)+prr
  p.flux<-npp_mean*p.ratio
  return(p.flux)
}
#' @export
prd<-function(npp_svi)(31*npp_svi^2+49*npp_svi+7.8)*10^-3
#' @export
rld<-function(npp_svi)1400*exp(0.54*npp_svi)
#' @export
prr<-function(npp_svi)(2.6*npp_svi^2-4.2*npp_svi+4.8)*10^-3
#' @export
p.ratio<-function(prd, z_ex, rld, prr)prd*exp(-z_ex/rld)+prr