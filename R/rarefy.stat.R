#' @title Rarefy a statistic
#'
#' @description Rarefies or bootstraps a statistic
#'
#' @param data The dataset upon which to calculate the statistics (a \code{"matrix"} or \code{"data.frame"})
#' @param stat.fun The function to calculate the statistic (in format \code{fun(data, ...)}).
#' @param rarefaction The amount of data to resample. Leave as \code{NULL} for bootstrapping.
#' @param replicates The number of replicates (default is \code{100}).
#' @param observed Optional, an set observed statistic value.
#' @param ... Optional arguments to be passed to stat.fun.
#' 
#' @return
#' A vector of differences between the rarefy statistics and the observed statistics.
#' 
#' @details
#' The bootstrap/rarefaction procedure is used with replacement (\code{sample(..., replace = TRUE)}) so that when simply bootstrapping the data (no-rarefaction), each row of the dataset has a equal chance of being sampled multiple times.
#'
#' If the \code{observed} value is not provide, the observed statistic is directly measured as \code{stat.fun(data)}.
#' 
#' 
#' @examples
#' ## A dataset with two variables
#' data <- replicate(2, rnorm(50))
#' 
#' ## A function to get a statistic (the Student statistic)
#' my.stat <- function(data) {t.test(data[1, ], data[2, ])$statistic[[1]]}
#' 
#' ## Rarefy the statistic for only 10 rows
#' results <- rarefy.stat(data, my.stat, rarefaction = 10)
#' head(results)
#' 
#' ## Summarising the results
#' quantile(results)
#' boxplot(results); abline(h = 0, lty = 3)
#' 
#' @seealso
#' \code{\link{rand.test}}
#' 
#' @author Thomas Guillerme
#' @export

rarefy.stat <- function(data, stat.fun, rarefaction, replicates = 100, observed, ...) {
    ## Sanitizing
    check.class(data, c("matrix", "data.frame"))
    nrow_data <- nrow(data)
    check.class(stat.fun, "function")
    if(!is.null(rarefaction)) {
        check.class(rarefaction, c("numeric", "integer"))
        ## Check if rarefaction is bigger than the number of rows in the data set
        if(rarefaction > nrow_data) {
            warning(paste0("Rarefaction value (", rarefaction, ") is bigger than the number of rows in the data (", nrow_data, ").\nThe statistic will be only bootstrapped."))
            ## Set rarefaction as the number of rows in the data (bootstrap)
            rarefaction <- nrow_data    
        }
    } else {
        ## Set rarefaction as the number of rows in the data (bootstrap)
        rarefaction <- nrow(data)
    }
    check.class(replicates, c("numeric", "integer"))
    
    ## Check the observed value
    if(!missing(observed)) {
        check.class(observed, c("numeric", "integer"))
    } else {
        observed <- stat.fun(data)
    }

    ## Rarefaction function
    results <- replicate(replicates, stat.fun(data[sample(1:nrow_data, rarefaction, replace = TRUE), ]))

    ## Getting the differences
    return(results - observed)
}
