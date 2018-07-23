#' @title Area difference
#'
#' @description Measure the area difference between two ranked distribution
#'
#' @param x,y the two distributions to compare.
#' @param rarefy Optional, if the length of \code{x} is is not equal to the one of \code{y}, how many rarefaction samples to use. If left empty a default number of replicates between 100 and 1000 is used (see details).
#' @param cent.tend Optional, if the length of \code{x} is is not equal to the one of \code{y}, which central tendency to use (\code{defaut = mean}).
#' @param sort \code{logical}, whether to always sort the x,y values (\code{TRUE}; default) or not (\code{FALSE}).
#' 
#' @details
#' The number of replicates is chosen based on the variance of the distribution to rarefy using the Silverman's rule of thumb (Silverman 1986, pp.48, eqn 3.31) for choosing the bandwidth of a Gaussian kernel density estimator multiplied by 1000 with a result comprised between 100 and 1000.
#' For example, for rarefying \code{x}, \code{rarefy = round(stats::bw.nrd0(x) * 1000)}.
#' With \code{100 <= rarefy <= 1000}.
#' 
#' @references
#' Silverman, B. W. (1986) Density Estimation. London: Chapman and Hall.
#' 
#' @examples
#' set.seed(1)
#' ## Two distributions
#' x <- rnorm(10)
#' y <- runif(10)
#' 
#' ## The area difference
#' area.diff(x, y)
#' 
#' ## Visualising the difference
#' plot(sort(x), type = "l", col = "orange", lwd = 2)
#' lines(sort(y), col = "blue", lwd = 2)
#' polygon(c(1:10, 10:1), c(sort(x), sort(y, TRUE)), col = "grey", border = NA)
#' legend("topleft", legend  = c("x", "y", "area difference"), col = c("orange", "blue", "grey"),
#'        lty = c(1,1,0), pch = c(NA,NA,15))
#' 
#' 
#' ## Two unequal distributions
#' z <- rnorm(100)
#' 
#' ## The area difference estimation
#' area.diff(x, z)
#' 
#' ## The area difference estimation with a fixed rarefaction value using the median
#' area.diff(x, z, rarefy = 500, cent.tend = median)
#' 
#'
#' @seealso \code{\link{variation.range}}
#' 
#' @author Thomas Guillerme
#' @export
#' @importFrom zoo rollmean
#' @importFrom stats bw.nrd0

area.diff <- function(x, y, rarefy, cent.tend = mean, sort = TRUE) {

    match_call <- match.call()

    ## Sanitizing
    silent <- check.class(x, c("integer", "numeric"))
    silent <- check.class(y, c("integer", "numeric"))
    if(!missing(rarefy)) {
        silent <- check.class(rarefy, c("integer", "numeric"))
    }
    check.class(cent.tend, "function")
    test_fun <- make.metric(cent.tend, silent = TRUE)
    if(test_fun != "level1") {
        stop(paste0("Central tendency function ", as.expression(match_call$cent.tend), " must output a single value."))
    }
    check.class(sort, "logical")

    ## Sort both distributions (y axis)
    if(sort) {
        y_x <- sort(x, decreasing = TRUE)
        y_y <- sort(y, decreasing = TRUE)
    } else {
        y_x <- x
        y_y <- y
    }

    ## Getting the vectors lengths
    length_x <- length(x)
    length_y <- length(y)

    if(length_x == length_y) {
        do_rarefy <- FALSE
        ## Samples have the same size
        x_axis <- 1:length_x
    } else {
        do_rarefy <- TRUE
        ## Samples have different sizes
        if(length_x > length_y) {
            x_rare <- TRUE

            ## If rarefying is missing sample 1000 times the sd with a max of 500 and a min of 100
            if(missing(rarefy)) {
                rarefy <- round(stats::bw.nrd0(x) * 1000)
                rarefy <- ifelse(rarefy > 1000, 1000, rarefy)
                rarefy <- ifelse(rarefy < 100, 100, rarefy)
            }

            ## x > y
            x_rarefied <- lapply(replicate(rarefy, sample(x, length_y), simplify = FALSE), sort)
            y_rarefied <- y_y
            x_axis <- 1:length_y
        } else {
            x_rare <- FALSE

            ## If rarefying is missing sample 1000 times the sd with a max of 500 and a min of 100
            if(missing(rarefy)) {
                rarefy <- round(stats::bw.nrd0(y) * 1000)
                rarefy <- ifelse(rarefy > 1000, 1000, rarefy)
                rarefy <- ifelse(rarefy < 100, 100, rarefy)
            }

            ## x < y
            y_rarefied <- lapply(replicate(rarefy, sample(y, length_x), simplify = FALSE), sort)
            x_rarefied <- y_x
            x_axis <- 1:length_x
        }
    }

    if(!do_rarefy) {
        ## Calculate the x~y area
        x_area <- sum(diff(x_axis) * zoo::rollmean(y_x,2))
        y_area <- sum(diff(x_axis) * zoo::rollmean(y_y,2))
        
    } else {

        if(x_rare) {
            x_area <- cent.tend(unlist(lapply(x_rarefied, function(X, x_axis) return(sum(diff(x_axis) * zoo::rollmean(X,2))), x_axis)))
            y_area <- sum(diff(x_axis) * zoo::rollmean(y_y,2))
        } else {
            x_area <- sum(diff(x_axis) * zoo::rollmean(y_x,2))
            y_area <- cent.tend(unlist(lapply(y_rarefied, function(X, x_axis) return(sum(diff(x_axis) * zoo::rollmean(X,2))), x_axis)))
        }

    }

    return(x_area - y_area)
}
