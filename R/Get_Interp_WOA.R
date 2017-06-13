#' Download climatology data from World Ocean Atlas and calculate the iso-value depth
#' 
#' Download and surface climatology data from Nationa Oceanographic Data Center (NODC) World Ocean Atlas 2013 or Regional Climatology, calculate iso-value depth surface and then convert to a raster object
#' 
#' @param url A character string naming the URL of a CSV file to be downloaded
#' @param IsoValue A numeric values specifying where interpolation is to take place.
#' @param x Raster* object defining the spatial extent, resolution and projection of climatology data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads the surface climatology from 
#' \url{http://www.nodc.noaa.gov/OC5/woa13/woa13data.html} or \url{http://www.nodc.noaa.gov/OC5/regional_climate/}.
#' The global or regional climatology data at standard depths will be download but only the iso-value depth surface
#' are retained based on a template raster object. 
#' @return a raster object
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples
#' # Raster template of Canadian Arctic
#' data(tmp)
#' 
#' # Download January temperature data and calculate the 10-degree depth surface
#' Get_IsoValueDepth_WOA("http://data.nodc.noaa.gov/woa/WOA13/DATAv2/temperature/csv/decav/0.25/woa13_decav_t01an04v2.csv.gz", 
#' IsoValue=10, tmp, plot=TRUE) 
#' 

Get_IsoValueDepth_WOA <- 
  function(url, IsoValue=10, x=NULL, outdir=NULL, plot=FALSE){
    download.file(url, basename(url), mode="wb") 
    dat <- read.csv(basename(url), skip = 1, check.names = FALSE) # take a few minutes
    file.remove(basename(url))
    
    depth<-names(dat)[-1:-2]
    depth[1]<-0
    depth<-as.numeric(depth)
    # Interpolate iso-value depth
    int_fun <- function(i){
      value<-as.numeric(dat[i, -1:-2])
      approx(value, depth, method = "constant", xout=IsoValue)$y
    }
    cl<-makeCluster(4) # change 4 to your number of CPU cores
    registerDoSNOW(cl) # register the SNOW parallel backend with the foreach package
    d<-foreach(i=1:dim(dat)[1]) %dopar% int_fun(i)
    stopCluster(cl) # stop a SNOW cluster
    
    pts <- cbind(dat[, 1:2], unlist(d))
    names(pts) <- c("y", "x", "z")
    coordinates(pts)=~x+y
    gridded(pts) = TRUE
    proj4string(pts)=CRS("+proj=longlat +datum=WGS84") # set it to lat-long
    r <- raster(pts)
    
    if(!is.null(x)){
      r <- projectRaster(r, x) # projected to raster template
      r <- resample(r, x)
      r <- mask(r, x)
    }
    if(plot) plot(r)
    
    if(!is.null(outdir)){
      writeRaster(r, paste(outdir, sub(".csv", ".grd", basename(url)), sep="/"), 
                  format = "raster", overwrite=TRUE)
    } else return(r)
  }