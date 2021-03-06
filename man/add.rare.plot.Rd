% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add.rare.plot.R
\name{add.rare.plot}
\alias{add.rare.plot}
\title{Add the rarefaction plot}
\usage{
add.rare.plot(x, ...)
}
\arguments{
\item{x}{The \code{randtest} object}

\item{...}{Any optional parameters to be passed to \code{\link[ade4]{plot.randtest}} or \code{\link[graphics]{plot}}.}
}
\description{
Add the rarefaction plot to a called \code{\link[ade4]{plot.randtest}} plot
}
\examples{
## Loading the geomorph dataset
require(geomorph)
data(plethodon)

## Performing the Procrustes superimposition
proc_super <- gpagen(plethodon$land, print.progress = FALSE)

## Getting the two most different specimen based on their landmark change radii
var_range <- variation.range(proc_super)

\dontrun{

set.seed(1)
## Selecting 6 random landmarks
random_part <- sample(1:nrow(var_range), 6)

## Rarefying the area difference to 5 elements without testing the parameter
rarefy_test <- rand.test(var_range[, "radius"], random_part, rarefaction = 5,
                         test = area.diff)

## Plotting the results (central tendency)
plot(rarefy_test)

## Add the rarefied observations to the plot
add.rare.plot(rarefy_test)
}

}
\seealso{
\code{\link{rand.test}}
}
\author{
Thomas Guillerme
}
