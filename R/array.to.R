#' @title Array to ...
#' 
#' @description Converts a \code{"gpagen"} array to a \code{"list"} or a \code{"matrix"}
#'
#' @param array A \code{"gpagen"} object or an array of landmarks
#' @param to Either \code{"list"} or \code{"matrix"}.
#' 
#' @examples
#' ## Loading the plethodon dataset
#' require(geomorph)
#' data(plethodon)
#' 
#' ## Performing a procrustes superimposition
#' procrustes <- geomorph::gpagen(plethodon$land, print.progress = FALSE)
#' 
#' ## Transforming it into a list
#' array.to(procrustes, "list")
#' 
#' ## Transforming it into a matrix
#' array.to(procrustes, "matrix")
#'
#' @seealso
#' 
#' @author Thomas Guillerme
#' @export

array.to <- function(array, to) {

    ## array
    array_class <- check.class(array, c("array", "gpagen"))
    if(array_class == "gpagen") {
        array <- array$coords
    }

    ## to
    allowed <- c("matrix", "list")
    check.class(to, c("character"))
    check.method(to, allowed, "to argument")

    ## matrix
    if(to == "matrix") {
        return(geomorph::two.d.array(array))
    }

    ## matrix
    if(to == "list") {
        return(lapply(seq(dim(array)[3]), function(x) array[ , , x]))
    }

}