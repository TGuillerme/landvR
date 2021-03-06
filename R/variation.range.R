#' @title Range of variation
#'
#' @description Selecting the range of differences between the specimen with the maximum and minimum variation
#'
#' @param procrustes Procrustes data of class \code{"gpagen"} or \code{"array"}.
#' @param type Which type of coordinates to calculate (see \code{\link{coordinates.difference}} - default is \code{"spherical"}). See details.
#' @param angle Which type of angle to calculate (see \code{\link{coordinates.difference}} - default is \code{"degree"}).
#' @param what Which element from the \code{\link{coordinates.difference}} to use (default is \code{"radius"}).
#' @param ordination Optional, either \code{TRUE} to perform an ordination or directly an ordinated PCA matrix (\code{"prcomp"}) to calculate the range from there.
#' @param axis Optional, if an ordinated matrix is used, which axis (axes) to use. If left empty, all the axes will be used.
#' @param return.ID \code{logical}, whether to return the ID of the max/min specimens or not.
#' @param CI Optional, a value of confidence interval to use (rather than the max/min).
#' 
#' 
#' @details
#' When \code{type = "spherical"}, the distances are relative to each landmark, the selection of the two most extreme specimen is based on their absolute value (i.e. to select the two most distant specimen). Potential CI limits only affect the right side of the curve (the maxima).
#' When \code{type = "vector"}, the distances are absolute from the centre of the specimen (and can be negative), the selection of the two most extreme specimen is thus based on the absolute values as well (to select the most distance specimen). However, potential CI limits affect both size of the curve (removing the maxima and minima).
#'
#' @examples
#' ## Loading the geomorph dataset
#' require(geomorph)
#' data(plethodon)
#' 
#' ## Performing the Procrustes superimposition
#' proc_super <- gpagen(plethodon$land, print.progress = FALSE)
#' 
#' ## Getting the two most different specimen based on their landmark change radii
#' spec_range <- variation.range(proc_super, return.ID = TRUE)
#' 
#' ## The minimum and maximum specimen
#' spec_range$min.max
#' 
#' ## The range of variation per landmark
#' spec_range$range
#' 
#' ## Getting the two most different specimen based on the first axis of the ordination
#' variation.range(proc_super, ordination = TRUE, axis = 1, type = "vector", what = "length")
#' 
#' ## Getting the range variation between specimen using a 95 confidence interval range
#' spec_range95 <- variation.range(proc_super, CI = 0.95, return.ID = TRUE)
#' 
#' ## The absolute maximum and minimum specimens
#' spec_range$min.max
#' 
#' ## The lower and upper 95% range CI specimens
#' spec_range95$min.max
#'
#' @seealso \code{\link{coordinates.difference}}, \code{\link{area.diff}}, \code{\link{rand.test}}
#' 
#' @author Thomas Guillerme
#' @export
#' @importFrom stats prcomp quantile
#' @importFrom geomorph two.d.array

variation.range <- function(procrustes, type = "spherical", angle = "degree", what = "radius", ordination, axis, return.ID = FALSE, CI) {
    match_call <- match.call()

    ## procrustes
    proc_class <- check.class(procrustes, c("gpagen", "array"))

    ## If procrustes is an array make the "gpagen" object
    if(proc_class == "array") {
        ## Add the coords and the consensus to the "gpagen" object
        procrustes <- list(coords = procrustes,
                           consensus = select.procrustes(procrustes, mean)[[1]])
        class(procrustes) <- "gpagen"
    }

    ## CI
    if(missing(CI)) {
        do_CI <- FALSE
    } else {

        do_CI <- TRUE

        check.length(CI, 1, msg = " must be on confidence interval in probability or percentage.")

        if(CI > 100) {
            stop("CI must be a percentage or a probability.", call. = FALSE)
        }
        if(CI < 0) {
            stop("CI must be a percentage or a probability.", call. = FALSE)
        }
        if(CI <= 1) {
            CI <- CI * 100  
        }

        ## Convert the CI value into quantile boundaries
        cis <- sort(c(50-CI/2, 50+CI/2)/100)
        quantile_max <- cis[2]
        quantile_min <- cis[1]
    }

    ## ordination
    if(!missing(ordination)) {

        if(class(ordination) == "logical") {
            if(ordination) {
                do_ordinate <- TRUE

                ## Convert the array in 2D
                array_2d <- geomorph::two.d.array(procrustes$coords)

                ## measure the tolerance (to be equivalent to geomorph procedures)
                tol <- stats::prcomp(array_2d)$sdev^2
                tolerance <- cumsum(tol)/sum(tol)
                tolerance <- length(which(tolerance < 1)) 
                if(length(tolerance) < length(tol)){
                    tolerance <- tolerance + 1
                }
                tolerance <- max(c(tol[tolerance]/tol[1],0.005))

                ## Ordinating the data
                ordination <- stats::prcomp(array_2d, center = TRUE, scale. = FALSE, retx = TRUE, tol = tolerance)

            } else {
                do_ordinate <- FALSE
            }


        } else {
            ## Ordination is a prcomp object
            check.class(ordination, "prcomp")
            do_ordinate <- TRUE
        }

    } else {
        do_ordinate <- FALSE
    }

    ## axis
    if(do_ordinate) {
        if(missing(axis)) {
            axis <- 1:ncol(ordination$x)
        } else {
            silent <- check.class(axis, c("numeric", "integer"))

            axis_test <- axis %in% 1:ncol(ordination$x)
            if(any(!axis_test)) {
                if(length(which(axis_test == FALSE)) == 1) {
                    stop(paste0("Axis number ", axis[!axis_test], " not found."), call. = FALSE)
                } else {
                    stop(paste0("Axes number ", paste(axis[!axis_test], collapse = ", "), " not found."), call. = FALSE)
                }
            }
        }
    }
    
    ## return.ID
    check.class(return.ID, "logical")

    ## Applying the method to the Procrustes
    if(!do_ordinate) {

        ## Add names to the list to keep track of each specimen
        if(is.null(names(procrustes$coords)) || is.null(attributes(procrustes$coords)$dimnames[[3]])) {
            attributes(procrustes$coords)$dimnames[[3]] <- seq(1:dim(procrustes$coords)[3])
        }

        ## Get the distances from the consensus
        diff_consensus <- coordinates.difference(procrustes$coords, procrustes$consensus, type = type, angle = angle)

        ## Get the volume of change for each element (area under the curve)
        areas <- abs(unlist(lapply(diff_consensus, coordinates.area, what = what)))

        ## Finding the max specimen
        if(do_CI) {
            ## Take the the specimen in the upper CI
            max_specimen <- which(areas == max(areas[which(areas <= quantile(areas, probs = quantile_max))])) #add abs(areas)?
    
            ## Adding the specimens to remove
            max_specimen <- c(max_specimen, which(areas > areas[max_specimen]))
        } else {
            ## Take the actual max specimen
            max_specimen <- which(areas == max(areas)) #add abs(areas)?
        }
        ## Save the ID of the max specimen
        max_specimenID <- names(max_specimen[1])

        ## Get the distances from the maximum
        diff_from_max <- coordinates.difference(procrustes$coords[, , -max_specimen], procrustes$coords[, , max_specimen[1]], type = type, angle = angle)

        ## Getting all the areas
        areas_max <- abs(unlist(lapply(diff_from_max, coordinates.area, what = what)))

        ## Finding the min specimen
        if(do_CI) {
            min_specimen <- which(areas_max == max(areas_max[which(areas_max <= quantile(areas_max, probs = quantile_max))])) #add abs(areas)?
            
        } else {
            ## Take the actual max specimen
            min_specimen <- which(areas_max == max(areas_max)) #add abs(areas)?
        }
        ## Save the ID of the min specimen
        min_specimenID <- names(min_specimen)

        if(!is.na(as.numeric(max_specimenID))) {
            max_specimenID <- as.numeric(max_specimenID)
        }
        if(!is.na(as.numeric(min_specimenID))) {
            min_specimenID <- as.numeric(min_specimenID)
        }

        ## Get the variation range
        variation_range <- coordinates.difference(procrustes$coords[, , min_specimenID], procrustes$coords[, , max_specimenID], type = type, angle = angle)[[1]]
    

    } else {

        ## Internal function from geomorph:plotTangentSpace
        get.pc.min.max <- function(axis, what, PCA, GPA, CI) {
            ## Transforming the matrix (generalised from geomorph::plotRefToTarget)
            if(length(axis) == 1){
                transform_matrix <- as.vector(t(GPA$consensus)) + c(what(PCA$x[,axis], CI = CI), rep(0, ncol(PCA$x)-length(axis))) %*% t(PCA$rotation)
            } else {
                transform_matrix <- as.vector(t(GPA$consensus)) + c(apply(PCA$x[, axis], 2, what, CI = CI), rep(0, ncol(PCA$x[, axis])-length(axis))) %*% t(PCA$rotation[, axis])
            }
            ## Converting into a array
            output <- geomorph::arrayspecs(A = transform_matrix, p = dim(GPA$consensus)[1], k = dim(GPA$consensus)[2])
            return(output)
        }

        ## Get the selector function
        if(do_CI) {
            fun_max <- function(x, CI) return(max(x[which(x <= quantile(x, probs = CI))]))
            fun_min <- function(x, CI) return(min(x[which(x >= quantile(x, probs = CI))]))
        } else {
            CI <- NULL
            fun_max <- function(x, CI) return(max(x))
            fun_min <- function(x, CI) return(min(x))
        }

        ## Applying the method the an ordination
        max_coordinates <- get.pc.min.max(axis = axis, what = fun_max, PCA = ordination, GPA = procrustes, CI = quantile_max)
        dimensions <- dim(max_coordinates)
        max_coordinates <- matrix(max_coordinates, dimensions[1], dimensions[2])
        min_coordinates <- get.pc.min.max(axis = axis, what = fun_min, PCA = ordination, GPA = procrustes, CI = quantile_min)
        min_coordinates <- matrix(min_coordinates, dimensions[1], dimensions[2])


        ## Get the variation range
        variation_range <- coordinates.difference(min_coordinates, max_coordinates, type = type, angle = angle)[[1]]

        ## Finding the max/min specimen
        if(length(axis) != 1) {
            axis <- axis[1]
        }
        max_specimenID <- which(ordination$x[,axis] == fun_max(ordination$x[,axis], quantile_max))
        min_specimenID <- which(ordination$x[,axis] == fun_min(ordination$x[,axis], quantile_min))
    }
    
    if(!do_ordinate && return.ID){   
        return(list("range" = variation_range, "min.max" = c(min_specimenID, max_specimenID)))
    } else {
        if(return.ID) {
            warning("If return.ID = TRUE, be aware that the returned min and max specimen IDs do not correspond to the PC min/max hypothetical specimen but to the nearest observed ones.\nUse geomorph::plotTangentSpace(...)$pc.shapes coordinates instead.", call. = FALSE)
            return(list("range" = variation_range, "min.max" = c(min_specimenID, max_specimenID)))
        } else {
            return(variation_range)
        }
    }
}
