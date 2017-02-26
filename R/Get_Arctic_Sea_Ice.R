#' Download Arctic Sea Ice Concentrations from NSIDC  
#' 
#' Download National Snow and Ice Data Center (NSIDC) Arctic Sea Ice Concentrations binary flat file and then convert to a raster object
#' 
#' @param url A character string naming the URL of a binary file to be downloaded
#' @param x Raster* object defining the spatial extent, resolution and projection of sea ice data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads the northern hemisphere NSIDC Sea Ice Concentrations from Nimbus-7 SMMR 
#' and DMSP SSM/I-SSMIS Passive Microwave Data (\url{http://nsidc.org/data/nsidc-0051.html}). 
#' Function was Modified from codes written by Tony Fischbach at Walrus Research Program, Alaska Science Center, USGS. 
#' Metadata information for the northern hemisphere sea ice data is available at \url{https://support.nsidc.org/entries/21680984-How-do-I-import-the-0051-sea-ice-concentration-data-into-ArcGIS-}  
#' @return a raster object
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples 
#' # Raster template of Canadian Arctic
#' data(tmp)
#' 
#' # Download January 1998 data as an example
#' url <- "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/north/monthly/nt_199801_f13_v01_n.bin"
#' Get_Arctic_Sea_Ice(url=url, x=tmp, plot=TRUE)
#' 
#' # Use foreach loop to download sea ice data for all months from 1998 to 2012
#' library(RCurl) 
#' library(foreach)
#' library(doSNOW)
#' 
#' url<-c("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/north/monthly/")
#' filenames = getURL(url, ftp.use.epsv = FALSE, ftplistonly = TRUE, crlf = TRUE) 
#' filenames = paste(url, strsplit(filenames, "\r*\n")[[1]], sep = "")
#' 
#' # Create a folder to save raster files
#' folder <- "../Arctic_ocean_data/Sea_Ice_Nimbus-7_SMMR_DMSP_SSMI_SSMIS/" 
#' dir.create(folder)
#' 
#' cl<-makeCluster(4) # change 4 to your number of CPU cores
#' registerDoSNOW(cl) # register the SNOW parallel backend with the foreach package
#' foreach(i = filenames[232:423], .packages="OceanData") %dopar% Get_Arctic_Sea_Ice(i, tmp, folder)
#' stopCluster(cl) # stop a SNOW cluster

Get_Arctic_Sea_Ice <- 
  function(url, x=NULL, outdir=NULL, plot=FALSE){
    con <- file(url, "rb")
    dat <- readBin(con, "raw", 300)
    dat <- readBin(con,"int", size=1, signed=FALSE, 150000)
    close(con)
    newdat <- numeric(length(dat)) #new variable for recoding the 'raw' byte data
    newdat[dat==251] <- 1 # arbitrarily set the the polar data hole to 100% ice
    newdat[dat>251] <- 0 # set all non-ice pixels to 0% ice cover
    newdat[dat<251] <- dat[dat<251]/250 #scale ice cover to 1
    
    #### empty raster to hold the sea ice data ####
    pixel <- 25000 #pixel dimension in meters for both x and y 
    xMin <- -3837500 #From NSIDC: ulxmap -3837500
    xMax <- xMin + (pixel*304) 
    yMax <- 5837500 #From NSIDC: ulymap 5837500
    yMin <- yMax - (pixel*448) 
    r0 <- raster(nrow=448, ncol=304, xmn=xMin, xmx=xMax, ymn=yMin, ymx=yMax)
    projection(r0) <- '+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449 +units=m +no_defs'
    
    r <- setValues(r0, newdat)  # place result in raster
    if(!is.null(x)){
      r <- projectRaster(r, x) # re-projected to Sinusoidal Equal Area
      r <- mask(r, x)
      r <- resample(r, x)
      r <- mask(r, x)
    }
    names(r) <- "ice"
    if(plot) plot(r) # Plot it 
    if(!is.null(outdir)){
      filename <- gsub(".bin", ".grd", basename(url))
      writeRaster(r, paste(outdir, filename, sep=""), format = "raster", overwrite=TRUE) 
    } else return(r)
  }