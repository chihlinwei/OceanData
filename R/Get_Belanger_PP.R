#' Download Arctic primary production data from Belanger et al. (2013)
#' 
#' Download Arctic primary production data from Belanger et al. (2013) and then convert to a raster object. 
#' 
#' @param url A character string naming the URL of a txt file to be downloaded
#' @param x Raster* object defining the spatial extent, resolution and projection of climatology data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads primary production data from Belanger et al (2013). 
#' The units of the variables: Chla : mg m^-3, KPUR : m^-1, PAR : E m^-2 month^-1, PP : mg C m^-2 month^-1
#' @return a raster object
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples
#' # Raster template of Canadian Arctic
#' data(tmp)
#' 
#' # Download August 2010 as example
#' Get_Belanger_PP(url = "ftp://ftparcticnetl:nord.a13@@ftp.uqar.ca/Arcticnet/donnees_pour_VRoy/Monthly_PAR_CHL_KPUR_PP_201008_52.0_-140.0_80.0_-50.0.txt", 
#' x = tmp, plot = TRUE)
#' 
#' # Use foreach loop to download monthly data from 1998 to 2010
#' library(RCurl)
#' library(foreach)
#' library(doSNOW)
#' 
#' # UQAR FTP server 
#' # Embed the User ID and Password in the URL
#' User <- "ftparcticnetl"
#' Pass <- "nord.a13"
#' url <- paste("ftp://", User, ":", Pass, "@@ftp.uqar.ca/Arcticnet/donnees_pour_VRoy/", sep="")
#' 
#' filenames = getURL(url, ftp.use.epsv = FALSE, ftplistonly = TRUE, crlf = TRUE) 
#' filenames = paste(url, strsplit(filenames, "\r*\n")[[1]], sep = "") 
#' 
#' # Create a folder to save raster file
#' folder <- "../Arctic_ocean_data/Productivity_Belanger_2013/" 
#' dir.create(folder)
#' 
#' cl<-makeCluster(4) # change 4 to your number of CPU cores
#' registerDoSNOW(cl) # register the SNOW parallel backend with the foreach package
#' foreach(i=filenames, .packages="OceanData") %dopar% Get_Belanger_PP(i, tmp, folder)
#' stopCluster(cl) # stop a SNOW cluster


Get_Belanger_PP <- 
  function(url, x, outdir=NULL, plot=FALSE){
    con <- file(url, "r")
    dat <- read.table(con, header = FALSE)
    close(con)
    names(dat) <- c("PixelID", "Region", "Year", "Month", "Lat", "Lon", "PAR", "Chla", "KPUR", "PP")
    coordinates(dat) <- c("Lon", "Lat")
    proj4string(dat)=CRS("+proj=longlat +datum=WGS84") # set it to lat-long
    dat2 <- spTransform(dat[c("PAR", "Chla", "KPUR", "PP")], CRS(projection(x)))
    r <- rasterize(dat2, x)
    r <- resample(r, x)
    r <- mask(r, x)
    if(plot) plot(r) # Plot it
    if(!is.null(outdir)){
      filename <- gsub(".txt", ".grd", basename(url))
      writeRaster(r, paste(outdir, filename, sep=""), format = "raster", overwrite=TRUE)
    } else return(r)  
  }