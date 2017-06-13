#' Download and extract oceanographic data from various online sources
#'
#' OceanData is developed for Canadian Healthy Oceans Network (CHONe) benthic biodiversity 
#' and habitat mapping group. It provides wraper functions to download gloabl oceanographic 
#' data from various online sources and convert them to native raster files for futher processing. 
#' If monthly time-series oceanographic data are downloaded, multi-scale environmental variables 
#' can be extracted based on given sampling years, months and spatial coordinates. The environmental 
#' variables at various tiem lag (month) and extration radius (km) can be used to optimized 
#' bio-environmental or species distribution models. More information about each function can be 
#' found in its help documentation.
#'
#' OceanData's downloading functions read url strings into R. 
#' Users can choose functions to download sea inc concentration \link{Get_Arctic_Sea_Ice},
#'  primary production \link{Get_Belanger_PP}, or \link{Get_Ocean_Prod},
#'  near-bottom climatology \link{Get_Bottom_WOA}.
#' 
#' ...
#' 
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @references Chih-Lin Wei (2014). Surrogacy methods & use of global oceanographic databases.
#' DFO Technical Report
#' @import R.utils gdalUtils timeDate
#' @docType package
#' @name OceanData
NULL