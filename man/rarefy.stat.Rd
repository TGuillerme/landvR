% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rarefy.stat.R
\name{rarefy.stat}
\alias{rarefy.stat}
\title{Rarefy a statistic}
\usage{
rarefy.stat(data, stat.fun, rarefaction, replicates = 100, observed, ...)
}
\arguments{
\item{data}{The dataset upon which to calculate the statistics (a \code{"matrix"} or \code{"data.frame"})}

\item{stat.fun}{The function to calculate the statistic (in format \code{fun(data, ...)}).}

\item{rarefaction}{The amount of data to resample. Leave as \code{NULL} for bootstrapping.}

\item{replicates}{The number of replicates (default is \code{100}).}

\item{observed}{Optional, an set observed statistic value.}

\item{...}{Optional arguments to be passed to stat.fun.}
}
\value{
A vector of differences between the rarefy statistics and the observed statistics.
}
\description{
Rarefies or bootstraps a statistic
}
\details{
The bootstrap/rarefaction procedure is used with replacement (\code{sample(..., replace = TRUE)}) so that when simply bootstrapping the data (no-rarefaction), each row of the dataset has a equal chance of being sampled multiple times.

If the \code{observed} value is not provide, the observed statistic is directly measured as \code{stat.fun(data)}.
}
\examples{
## A dataset with two variables
data <- replicate(2, rnorm(50))

## A function to get a statistic (the Student statistic)
my.stat <- function(data) {t.test(data[1, ], data[2, ])$statistic[[1]]}

## Rarefy the statistic for only 10 rows
results <- rarefy.stat(data, my.stat, rarefaction = 10)
head(results)

## Summarising the results
quantile(results)
boxplot(results); abline(h = 0, lty = 3)

}
\seealso{
\code{\link{rand.test}}
}
\author{
Thomas Guillerme
}
