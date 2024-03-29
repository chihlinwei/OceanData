% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Get_Arctic_Sea_Ice.R
\name{Get_Arctic_Sea_Ice}
\alias{Get_Arctic_Sea_Ice}
\title{Download Arctic Sea Ice Concentrations from NSIDC}
\usage{
Get_Arctic_Sea_Ice(url, x = NULL, outdir = NULL, plot = FALSE)
}
\arguments{
\item{url}{A character string naming the URL of a binary file to be downloaded}

\item{x}{Raster* object defining the spatial extent, resolution and projection of sea ice data 
to be retrived. If not provide, returning full data set.}

\item{outdir}{output directory to write raster file}

\item{plot}{Logical, whether or not to plot the output raster}
}
\value{
a raster object
}
\description{
Download National Snow and Ice Data Center (NSIDC) Arctic Sea Ice Concentrations binary flat file and then convert to a raster object
}
\details{
This function dowloads the northern hemisphere NSIDC Sea Ice Concentrations from Nimbus-7 SMMR 
and DMSP SSM/I-SSMIS Passive Microwave Data (\url{http://nsidc.org/data/nsidc-0051.html}). 
Function was Modified from codes written by Tony Fischbach at Walrus Research Program, Alaska Science Center, USGS. 
Metadata information for the northern hemisphere sea ice data is available at \url{https://support.nsidc.org/entries/21680984-How-do-I-import-the-0051-sea-ice-concentration-data-into-ArcGIS-}
}
\examples{
# Raster template of Canadian Arctic
data(tmp)

# Download January 1998 data as an example
url <- "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/north/monthly/nt_199801_f13_v01_n.bin"
Get_Arctic_Sea_Ice(url=url, x=tmp, plot=TRUE)

# Use foreach loop to download sea ice data for all months from 1998 to 2012
library(RCurl) 
library(foreach)
library(doSNOW)

url<-c("ftp://sidads.colorado.edu/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/north/monthly/")
filenames = getURL(url, ftp.use.epsv = FALSE, ftplistonly = TRUE, crlf = TRUE) 
filenames = paste(url, strsplit(filenames, "\r*\n")[[1]], sep = "")

# Create a folder to save raster files
folder <- "../Arctic_ocean_data/Sea_Ice_Nimbus-7_SMMR_DMSP_SSMI_SSMIS/" 
dir.create(folder)

cl<-makeCluster(4) # change 4 to your number of CPU cores
registerDoSNOW(cl) # register the SNOW parallel backend with the foreach package
foreach(i = filenames[232:423], .packages="OceanData") \%dopar\% Get_Arctic_Sea_Ice(i, tmp, folder)
stopCluster(cl) # stop a SNOW cluster
}
\author{
Chih-Lin Wei <chihlinwei@gmail.com>
}
