#' Download all SeaWiFS or MODIS HDF4 file from Ocean Productivity Web page
#' 
#' Download SeaWiFS or MODIS HDF4 file from Ocean Productivity Web page and then convert to a raster object
#' 
#' @param url_list A list string for each variable naming the time-series URLs of HDF4 file to be downloaded.
#' The names of the url_list (\code{names(url_list)}) should be given as a vector of variable names.
#' @param ts The number of urls to be download in url_list
#' @param x Raster* object defining the spatial extent, resolution and projection of climatology data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads multiple HDF4 files from Ocean Productivity Web page \url{http://www.science.oregonstate.edu/ocean.productivity/}
#' @return a raster object
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples 
#' #### Get data from 1998-01 to 2007-12 (using SeaWiFS) and 2008-01 to 2012-12 (using MODIS)
#' # Take serveral hours; best to leave it overnight
#' 
#' # Raster template of Canadian Arctic
#' data(tmp)
#' 
#' # Create a folder to output raster bricks 
#' folder <- "../Arctic_ocean_data/Ocean_Productivity"
#' dir.create(folder)
#' 
#' # Year and day of year by month from 1998-01-01 to 2012-12-0
#' seawifs <- Year_Day("1998-01-01", "2007-12-01", by="month") # SEAWiFS time series
#' modis <- Year_Day("2008-01-01", "2012-12-01", by="month") # MODIS time series
#' 
#' # URLs for each variable
#' # The url path may change depending on the NASA Ocean Color reprocessing version
#' # Check http://www.science.oregonstate.edu/ocean.productivity/ before using the following examplea
#' 
#' # Paticle Backscattering
#' bbp <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/bbp.r2010.gsm.v6.s/hdf/bbp", seawifs, "hdf.gz", sep="."), 
#'          paste("http://orca.science.oregonstate.edu/data/2x4/monthly/bbp.r2013.gsm.v7.m/hdf/bbp", modis, "hdf.gz", sep="."))
#'          
#' # Carbon concentration
#' carbon <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/carbon.s.r2010.gsm.v6/hdf/carbon", seawifs, "hdf.gz", sep="."), 
#'             paste("http://orca.science.oregonstate.edu/data/2x4/monthly/carbon.m.r2013.gsm.v7/hdf/carbon", modis, "hdf.gz", sep="."))
#'             
#' # Carbon-based primary production model
#' cbpm <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/cbpm2.s.r2010.gsm.v6/hdf/cbpm", seawifs, "hdf.gz", sep="."), 
#'           paste("http://orca.science.oregonstate.edu/data/2x4/monthly/cbpm2.m.r2013.gsm.v7/hdf/cbpm", modis, "hdf.gz", sep="."))
#'           
#' # Chlorophyll concentration
#' chl <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/chl.r2010.seawifs/hdf/chl", seawifs, "hdf.gz", sep="."), 
#'          paste("http://orca.science.oregonstate.edu/data/2x4/monthly/chl.modis.r2013/hdf/chl", modis, "hdf.gz", sep="."))
#'          
#' # Eppley variation of VGPM primary production
#' eppley <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/eppley.r2010.s.chl.a.sst/hdf/eppley", seawifs, "hdf.gz", sep="."), 
#'             paste("http://orca.science.oregonstate.edu/data/2x4/monthly/eppley.r2013.m.chl.m.sst4/hdf/eppley", modis, "hdf.gz", sep="."))
#'             
#' # Phytoplankton growth rate
#' growth <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/growth.s.r2010.gsm.v6/hdf/growth", seawifs, "hdf.gz", sep="."),
#'             paste("http://orca.science.oregonstate.edu/data/2x4/monthly/growth.m.r2013.gsm.v7/hdf/growth", modis, "hdf.gz", sep="."))
#'             
#' # Photosynthetically available radiation
#' par <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/par.r2010.seawifs/hdf/par", seawifs, "hdf.gz", sep="."), 
#'          paste("http://orca.science.oregonstate.edu/data/2x4/monthly/par.modis.r2013/hdf/par", modis, "hdf.gz", sep="."))
#'          
#' # Vertical General Production model
#' vgpm <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/vgpm.r2010.s.chl.a.sst/hdf/vgpm", seawifs, "hdf.gz", sep="."), 
#'           paste("http://orca.science.oregonstate.edu/data/2x4/monthly/vgpm.r2013.m.chl.m.sst4/hdf/vgpm", modis, "hdf.gz", sep="."))
#'           
#' # Sea surface temperature
#' sst <- c(paste("http://orca.science.oregonstate.edu/data/2x4/monthly/sst.avhrr/hdf/sst", seawifs, "hdf.gz", sep="."), 
#'          paste("http://orca.science.oregonstate.edu/data/2x4/monthly/sst4.modis.r2013/hdf/sst4", modis, "hdf.gz", sep="."))
#'          
#' # Mixed layer depth
#' soda <- paste("http://orca.science.oregonstate.edu/data/1x2/monthly/mld.soda/hdf/mld", Year_Day("1998-01-01", "2004-12-01", by="month"), "hdf.gz", sep=".")
#' tops <- paste("http://orca.science.oregonstate.edu/data/1x2/monthly/ild.fnmoc_tops/hdf/ild", Year_Day("2005-01-01", "2005-06-01", by="month"), "hdf.gz", sep=".")
#' fnmoc <- paste("http://orca.science.oregonstate.edu/data/1x2/monthly/mld.fnmoc_highres/hdf/mld", Year_Day("2005-07-01", "2008-09-01", by="month"), "hdf.gz", sep=".")
#' hycom <- paste("http://orca.science.oregonstate.edu/data/1x2/monthly/mld.hycom/hdf/mld", Year_Day("2008-10-01", "2012-12-01"), "hdf.gz", sep=".")
#' mld <- c(soda, tops, fnmoc, hycom)
#' 
#' url_list <- list(bbp, carbon, cbpm, chl, eppley, growth, par, vgpm, mld, sst)
#' names(url_list) <- c("bbp", "carbon", "cbpm", "chl", "eppley", "growth", "par", "vgpm", "mld", "sst")
#' 
#' # Use August 1998 as example
#' Get_all_Ocean_Prod(url_lis=url_list, ts=8, x=tmp, plot=TRUE)
#' 
#' # Download the entire time series 
#' 
#' library(foreach)
#' library(doSNOW)
#' 
#' cl<-makeCluster(4) # change 4 to your number of CPU cores
#' registerDoSNOW(cl) # register the SNOW parallel backend with the foreach package
#' foreach(i=1:2, .packages="OceanData") %dopar% Get_all_Ocean_Prod(url_list, ts=i, x=tmp, outdir=folder)
#' stopCluster(cl) # stop a SNOW cluster

Get_all_Ocean_Prod <- 
  function(url_list, ts, x=NULL, outdir=NULL, plot=FALSE){
    v <- brick()
    for(i in 1:length(url_list)){
      url <- url_list[[i]][ts]
      s <- Get_Ocean_Prod(url, x)
      if(!is.null(x)) v <- addLayer(v, mask(s, x)) else v <- addLayer(v, s)
    }
    names(v) <- names(url_list)
    if(plot) plot(v)
    
    #Save the raster brick 
    if(!is.null(outdir)){
      filename <- paste(unlist(strsplit(basename(url), split="[.]"))[2], "grd" , sep = ".")
      writeRaster(v, paste(outdir, filename, sep="/"), format = "raster", overwrite=TRUE)
    } 
  }