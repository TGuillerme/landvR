#' @title Linear distance
#'
#' @description Measure the linear distance between pairs of landmarks
#'
#' @param landmarks A \code{"matrix"}, \code{"list"} or \code{"array"}, where the landmarks are rows and the columns are dimensions. 
#' @param measurements A pair of landmark IDs or a \code{"list"} of pairs of landmarks IDs.
#' @param dist The type of distance as passed to \code{\link[stats]{dist}} (default is \code{"euclidean"}).
#' 
#' @examples
#' ## Loading the plethodon dataset
#' require(geomorph)
#' data(plethodon)
#' data(scallops)
#'
#' ## One measurement on multiple specimen
#' linear.dist(plethodon$land, c(1,2))
#' 
#' ## List of multiple measurements on multiple specimen
#' linear.dist(scallops$coorddata, list("a" = c(1,2), "b" = c(2,15)))
#' 
#' 
#' @seealso
#' 
#' @author Thomas Guillerme
#' @export

linear.dist <- function(landmarks, measurements, dist = "euclidean") {

    ## landmarks
    class_landmarks <- check.class(landmarks, c("gpagen", "matrix", "array", "list"))

    ## Converting to a list
    if(class_landmarks == "matrix") {
        land_names <- NULL
        landmarks <- list(landmarks)
    }
    if(class_landmarks == "gpagen") {
        land_names <- dimnames(landmarks$coords)[[3]]
        landmarks <- array.to(landmarks, "list")   
    }
    if(class_landmarks == "array") {
        land_names <- dimnames(landmarks)[[3]]
        landmarks <- array.to(landmarks, "list")
    }
    if(class_landmarks == "list") {
        land_names <- names(landmarks)
    }

    ## Getting the names of the elements
    if(is.null(land_names)) {
        names(landmarks) <- seq(1:length(landmarks))
    } else {
        names(landmarks) <- land_names
    }

    ## Getting the dimensionality
    n_dimensions <- unique(unlist(lapply(landmarks, ncol)))
    if(length(n_dimensions) > 1) {
        stop("Not all the specimens have the same number of dimensions!")
    }
    n_landmarks <- unique(unlist(lapply(landmarks, nrow)))
    if(length(n_landmarks) > 1) {
        stop("Not all the specimens have the same number of landmarks!")
    }

    ## selector
    class_measurements <- check.class(measurements, c("list", "numeric", "integer"))
    if(class_measurements != "list") {
        ## Check the measurement is a pair
        check.length(measurements, 2, " must be a pair of landmarks (or multiple pairs).")
        measurements <- list(measurements)
    } else {
        ## Check they are all pairs
        if(any(unlist(lapply(measurements, length)) > 2)) {
            stop("measurements must be a pair of landmarks (or multiple pairs).")
        }
    }
    ## Check if all the measurements are below the number of landmarks
    if(any(unlist(measurements) > n_landmarks)) {
        stop(paste0("landmark IDs in measurements argument cannot be greater than the number of landmarks (", n_landmarks, ")."))
    }


    ## Dist
    allowed_dist <- c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")
    check.method(dist, allowed_dist, "distance ")
    dist_type <- dist

    ## Function for getting the distance on one matrix
    get.one.distance <- function(matrix, pair, dist_type) {
        return(dist(matrix[pair,], dist_type))
    }

    ## Applying that to all the matrices
    get.all.distances <- function(pair, list, dist_type) {
        return(unlist(lapply(list, get.one.distance, pair, dist_type)))
    }

    ## Running the function for all pairs of measurements
    all_distances <- lapply(measurements, get.all.distances, list = landmarks, dist_type = dist_type)

    ## Return
    if(length(landmarks) == 1) {
        distances <- unlist(all_distances)
        names(distances) <- names(measurements)
        return(distances)
    } else {
        ## Make a distance matrix
        distance_matrix <- do.call(cbind, all_distances)
        rownames(distance_matrix) <- land_names
        colnames(distance_matrix) <- names(measurements)
        return(distance_matrix)
    }
}