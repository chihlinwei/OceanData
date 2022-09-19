#' Download near-bottom climatology data from World Ocean Atlas
#' 
#' Download and near-bottom climatology data from Nationa Oceanographic Data Center (NODC) World Ocean Atlas 2013 or Regional Climatology and then convert to a raster object
#' 
#' @param url A character string naming the URL of a CSV file to be downloaded
#' @param x Raster* object defining the spatial extent, resolution and projection of climatology data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads the near-bottom climatology from 
#' \url{http://www.nodc.noaa.gov/OC5/woa13/woa13data.html} or \url{http://www.nodc.noaa.gov/OC5/regional_climate/}.
#' The global or regional climatology data at standard depths will be download but only the near-bottom
#' data are retained based on a template raster object. 
#' @return a raster object
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples
#' # Raster template of Canadian Arctic
#' data(tmp)
#' 
#' # Download January temperature data as example
#' Get_Bottom_WOA("https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/temperature/csv/decav/0.25/woa18_decav_t01an04.csv.gz", 
#' tmp, plot=TRUE) 
#' 
#' #Download monthly near-bottom temperature
#' urls <- paste("https://www.ncei.noaa.gov/data/oceans/woa/WOA18/DATA/temperature/csv/decav/0.25/woa18_decav_t", 
#'               c(paste(0, 1:9, sep=""), 10:12), "an04.csv", sep="")
#' 
#' # Raster template of Canadian Arctic
#' data(tmp)
#' 
#' # Create a fold to save raster file
#' folder <- "../Arctic_ocean_data/Climatology2" 
#' dir.create(folder)
#' 
#' library(foreach)
#' library(doSNOW)
#' 
#' cl<-makeCluster(4) # change 4 to your number of CPU cores
#' registerDoSNOW(cl) # register the SNOW parallel backend with the foreach package
#' foreach(i=urls, .packages="OceanData", .export = "urls") %dopar% Get_Bottom_WOA(i, tmp, folder)
#' stopCluster(cl) # stop a SNOW cluster

Get_Bottom_WOA <- 
  function(url, x=NULL, outdir=NULL, plot=FALSE){
    download.file(url, basename(url), mode="wb") 
    dat <- read.csv(basename(url), skip = 1, check.names = FALSE) # take a few minutes
    file.remove(basename(url))
    
    # keep the bottom data
    r0 <- dat[, 3]
    for(i in 4:ncol(dat)){ 
      r1 <- dat[, i]
      r0[!is.na(r1)] <- r1[!is.na(r1)] }
    
    pts <- cbind(dat[, 1:2], r0)
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