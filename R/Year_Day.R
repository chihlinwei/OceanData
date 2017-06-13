#' Regularly spaced year plus day of year
#' 
#' Regularly spaced year plus day of year. This year day format is commonly used in NASS Ocean Color product
#' 
#' @param from starting date, required.
#' @param to end date, optional. If supplied, to must be after (later than) from.
#' @param by a character string, containing one of "sec", "min", "hour", "day", "week", "month" or "year". 
#' This can optionally be preceded by an integer and a space, or followed by "s".
#' character string "quarter" that is equivalent to "3 months".
#' A number, taken to be in seconds.
#' A object of class 'difftime'
#' @param ... Arguments passed to \link[timeDate]{timeSequence}
#' @details This function's Arguments follow \link[timeDate]{timeSequence}
#' @return a numeric vector of year plus day of year
#' @author Chih-Lin Wei <chihlinwei@@gmail.com>
#' @export
#' @examples
#' Year_Day("1998-01-01", "1999-12-01", by="month")
#' LazyData: true

Year_Day <- function(...){
  tS <- timeSequence(...)
  yr <- unlist(lapply(strsplit(as.character(tS), split="-"), function(x)x[1]))
  as.numeric(yr)*1000+dayOfYear(tS)
}