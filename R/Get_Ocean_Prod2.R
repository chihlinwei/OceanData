#' Download SeaWiFS or MODIS HDF4 file from Ocean Productivity Web page using ncdf4 package
#' 
#' Download SeaWiFS or MODIS HDF4 file from Ocean Productivity Web page and then convert to a raster object
#' 
#' @param url A character string naming the URL of a HDF4 file to be downloaded
#' @param x Raster* object defining the spatial extent, resolution and projection of climatology data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads HDF4 file from Ocean Productivity Web page \url{http://www.science.oregonstate.edu/ocean.productivity/} 
#' This is an R wrapper for the \code{\link[ncdf4]{nc_open}} and \code{\link[ncdf4]{ncvar_get}} functions. Detailed description of the usage 
#' can be found in \url{https://hdfeos.org/software/r.php}  
#' @return a raster object
#' @references \url{https://hdfeos.org/software/r.php}
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples
#' # Download July 2002 VGPM as example
#' url <- "http://orca.science.oregonstate.edu/data/2x4/monthly/vgpm.r2018.m.chl.m.sst/hdf/vgpm.2002182.hdf.gz"
#' Get_Ocean_Prod2(url)
#' 
#' # Download July 2002 chl as example
#' url <- "http://orca.science.oregonstate.edu/data/1x2/monthly/chl.modis.r2018/hdf/chl.2002182.hdf.gz"
#' Get_Ocean_Prod2(url)

Get_Ocean_Prod2 <-
  function(url, outdir=NULL){
    dest <- basename(url)
    download.file(url, dest)
    src <- sub(".gz", "", dest)
    gunzip(dest, src)
    nc <- nc_open(src)
    vn <- names(nc$var)
    z <- ncvar_get(nc, vn)
    nc_close(nc)
    file.remove(src)
    m <- as.matrix(z)
    m[m==-9999] <- NA
    r <- raster(t(m), xmn=-180, xmx=180, ymn=-90, ymx=90, crs= "+proj=longlat +datum=WGS84")
    
    #Save the raster brick 
    if(!is.null(outdir)){
      writeRaster(r, paste(outdir, sub(".hdf", ".grd", src), sep="/"), format = "raster", overwrite=TRUE)
    } else return(r)
  }