#' A raster template of the Canadian Arctic
#' 
#' A raster dataset showing Canadian Arctic between Longitude -140 to -50 and latitude 65 to 80.
#'  The raster are in Sinusoidal Eaqual area projection with grid resolution of 9.28km.
#'  The landmass are masked by GSHHG (\url{http://www.soest.hawaii.edu/pwessel/gshhg/index.html}) costaline data.
#' 
#' @docType data
#' @keywords datasets
#' @format A rasterLayer object
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @name tmp
#' @examples
#' # Example on making a raster template of the Canadian Arctic
#' 
#' library(raster)
#' library(maptools)
#' 
#' #### Create a global empty raster ####
#' # 9km or 1/12 degree global grids
#' tmp <- raster(nrow=2160, ncol=4320, xmn=-180, xmx=180, ymn=-90, ymx=90)
#' tmp <- setValues(tmp, numeric(2160*4320))
#' 
#' #### Subset the raster to Canadian High Arctic ####
#' ex <- extent(c(-140,-50,65,80))
#' tmp <- crop(tmp, ex)
#' plot(tmp)
#' 
#' #### Download GSHHG costaline data ####
#' # Create a folder in the parent directory to save GSHHG data
#' dir.create("../Arctic_ocean_data") 
#' 
#' # GSHHG FTP server address and path to save zip file
#' url <- "ftp://ftp.soest.hawaii.edu/gshhg/gshhg-bin-2.2.4.zip" 
#' dest <- "../Arctic_ocean_data/gshhg-bin-2.2.4.zip"
#' 
#' # download will take a while (109.2 Mb)
#' download.file(url, dest, mode="wb") 
#' 
#' # Unzip the data; use gshhs_h or gshhs_f if higher resolution is needed 
#' unzip(dest, files = c("gshhs_i.b", "gshhs_l.b", "gshhs_c.b"), 
#'       exdir = "../Arctic_ocean_data")
#' file.remove(dest) # Remove zip file; omit if you want keep it
#' 
#' #### Mask landmass using GSHHG costaline polygons ####
#' 
#' # Read GSHHG data
#' # getRgshhsMap() take longitude limits within 0-360
#' land<-getRgshhsMap("../Arctic_ocean_data/gshhs_l.b", 
#'                    xlim=c(360-140, 360-50), ylim=c(65, 80), level = 1, no.clip = TRUE)
#' plot(land, xlim=c(-140, -50), ylim=c(65, 80))
#' 
#' # Mask the raster by landmass
#' tmp <- mask(tmp, land, inverse = TRUE)
#' plot(tmp)
#' 
#' # re-project the raster template to Sinusoidal Equal Area Projection
#' sinu <- "+proj=sinu +lon_0=-95 +x_0=0 +y_0=0"
#' tmp <- projectRaster(tmp, res = 9280, crs = sinu) # Grid resolution is 9.28 km
#' plot(tmp)
#' 
#' # Export the raster template
#' names(tmp) <- "template"
#' writeRaster(tmp, "../Arctic_ocean_data/template.grd", format = "raster", overwrite=TRUE)
NULL