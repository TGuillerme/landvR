#' @title Slope difference
#'
#' @description Measuring the difference between slopes in angles
#'
#' @param slope1 A slope.
#' @param slope2 Another slope.
#' @param angle Either \code{"degree"} (default) or \code{"radian"}.
#' @param significance Optional, an angle value below which angles are not significant (in degree or radian)
#' 
#' @return
#' Either the value of the angle (if \code{significance} is left empty) or a \code{logical} whether the angle is below the \code{significance} value.
#' 
#' @examples
#' ## A random dataset
#' data <- as.data.frame(replicate(3, rnorm(10)))
#' colnames(data) <- letters[1:3]
#' 
#' ## Two slopes
#' slope_b <- lm(a ~ b, data)$coefficients[["b"]]
#' slope_c <- lm(a ~ c, data)$coefficients[["c"]]
#' 
#' ## The slope difference
#' slope.diff(slope_b, slope_c)
#' ## The slope difference in radian
#' slope.diff(slope_b, slope_c, angle = "radian")
#' ## Whether the slope difference is lower than 4.5 degrees
#' slope.diff(slope_b, slope_c, significance = 4.5)
#'
#' @seealso
#' 
#' @author Thomas Guillerme and Ariel Marcy
#' @export

slope.diff <- function(slope1, slope2, angle = "degree", significance) {
    ## Sanitizing
    check.class(slope1, c("numeric", "integer"))
    check.class(slope2, c("numeric", "integer"))
    check.method(angle, c("degree", "radian"), msg = "angle")
    if(!missing(significance)) {
        check.class(significance, c("numeric", "integer"))    
    }

    ## Calculating the angle
    slope_angle <- abs(atan(slope2/(1 + slope1 * (slope1 + slope2))))
    ## Convert to degrees
    if(angle == "degree") {
        slope_angle <- slope_angle * 180/pi
    }

    ## Return the value
    if(!missing(significance)) {
        ## Testing for significance
        return(ifelse(slope_angle < significance, TRUE, FALSE))
    } else {
        ## Simply returning the angle
        return(slope_angle)
    }
}
