% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/variation.range.R
\name{variation.range}
\alias{variation.range}
\title{Range of variation}
\usage{
variation.range(
  procrustes,
  type = "spherical",
  angle = "degree",
  what = "radius",
  ordination,
  axis,
  return.ID = FALSE,
  CI
)
}
\arguments{
\item{procrustes}{Procrustes data of class \code{"gpagen"} or \code{"array"}.}

\item{type}{Which type of coordinates to calculate (see \code{\link{coordinates.difference}} - default is \code{"spherical"}). See details.}

\item{angle}{Which type of angle to calculate (see \code{\link{coordinates.difference}} - default is \code{"degree"}).}

\item{what}{Which element from the \code{\link{coordinates.difference}} to use (default is \code{"radius"}).}

\item{ordination}{Optional, either \code{TRUE} to perform an ordination or directly an ordinated PCA matrix (\code{"prcomp"}) to calculate the range from there.}

\item{axis}{Optional, if an ordinated matrix is used, which axis (axes) to use. If left empty, all the axes will be used.}

\item{return.ID}{\code{logical}, whether to return the ID of the max/min specimens or not.}

\item{CI}{Optional, a value of confidence interval to use (rather than the max/min).}
}
\description{
Selecting the range of differences between the specimen with the maximum and minimum variation
}
\details{
When \code{type = "spherical"}, the distances are relative to each landmark, the selection of the two most extreme specimen is based on their absolute value (i.e. to select the two most distant specimen). Potential CI limits only affect the right side of the curve (the maxima).
When \code{type = "vector"}, the distances are absolute from the centre of the specimen (and can be negative), the selection of the two most extreme specimen is thus based on the absolute values as well (to select the most distance specimen). However, potential CI limits affect both size of the curve (removing the maxima and minima).
}
\examples{
## Loading the geomorph dataset
require(geomorph)
data(plethodon)

## Performing the Procrustes superimposition
proc_super <- gpagen(plethodon$land, print.progress = FALSE)

## Getting the two most different specimen based on their landmark change radii
spec_range <- variation.range(proc_super, return.ID = TRUE)

## The minimum and maximum specimen
spec_range$min.max

## The range of variation per landmark
spec_range$range

## Getting the two most different specimen based on the first axis of the ordination
variation.range(proc_super, ordination = TRUE, axis = 1, type = "vector", what = "length")

## Getting the range variation between specimen using a 95 confidence interval range
spec_range95 <- variation.range(proc_super, CI = 0.95, return.ID = TRUE)

## The absolute maximum and minimum specimens
spec_range$min.max

## The lower and upper 95\% range CI specimens
spec_range95$min.max

}
\seealso{
\code{\link{coordinates.difference}}, \code{\link{area.diff}}, \code{\link{rand.test}}
}
\author{
Thomas Guillerme
}
