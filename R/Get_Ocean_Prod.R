#' Download SeaWiFS or MODIS HDF4 file from Ocean Productivity Web page
#' 
#' Download SeaWiFS or MODIS HDF4 file from Ocean Productivity Web page and then convert to a raster object
#' 
#' @param url A character string naming the URL of a HDF4 file to be downloaded
#' @param x Raster* object defining the spatial extent, resolution and projection of climatology data 
#' to be retrived. If not provide, returning full data set.
#' @param outdir output directory to write raster file
#' @param plot Logical, whether or not to plot the output raster
#' @details This function dowloads HDF4 file from Ocean Productivity Web page \url{http://www.science.oregonstate.edu/ocean.productivity/} 
#' This is an R wrapper for the \code{\link[gdalUtils]{gdal_translate}} function that is part of the Geospatial Data Abstraction Library (GDAL), which assumes the 
#' user has a working GDAL on their system. However, if the GDAL not working, \code{\link{Get_Ocean_Prod2}} can be used as alternative.
#' @return a raster object
#' @references \url{http://www.gdal.org/gdal_translate.html}
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples
#' # Download August 2002 VGPM as example
#' url <- "http://orca.science.oregonstate.edu/data/2x4/monthly/vgpm.r2018.m.chl.m.sst/hdf/vgpm.2002182.hdf.gz"
#' Get_Ocean_Prod(url)

Get_Ocean_Prod <-
  function(url, outdir=NULL){
    dest <- basename(url)
    download.file(url, dest, mode="wb")
    src <- sub(".gz", "", dest)
    gunzip(dest, src)
    dst <- basename(sub("hdf", "tif", src))
    r <-gdal_translate(src, dst, a_srs = "+proj=longlat +datum=WGS84",
                            a_nodata=-9999, output_Raster=TRUE)
    extent(r) <- extent(c(-180, 180, -90, 90))
    file.remove(src)
    file.remove(dst)
    
    #Save the raster brick 
    if(!is.null(outdir)){
      writeRaster(r, paste(outdir, sub(".hdf", ".grd", src), sep="/"), format = "raster", overwrite=TRUE)
    } else return(r)
    

  }