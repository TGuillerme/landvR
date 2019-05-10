#' @title Select Procrustes values
#'
#' @description Selects specific values of specimens from a Procrustes superimposition
#'
#' @param procrustes Procrustes data of class \code{"gpagen"} or an \code{"array"} or \code{"list"} of coordinates.
#' @param selector A \code{function} of which values to select (default = \code{\link{mean}}).
#' @param factors A \code{list} of elements names or IDs to split the data.
# @param specimen Whether to return the values of the estimated selector (\code{FALSE} - default - a non-existing specimen) or the specimen the closest to the the estimated selector (\code{TRUE}).
#' 
#' @return
#' The coordinates of a hypothetical specimen (e.g. the mean specimen).
#' 
#' 
#' @examples
#' ## Loading the plethodon dataset
#' require(geomorph)
#' data(plethodon)
#' 
#' ## Performing a procrustes superimposition
#' procrustes <- geomorph::gpagen(plethodon$land, print.progress = FALSE)
#' 
#' ## Selecting the mean Procrustes
#' mean_procrustes <- select.procrustes(procrustes, selector = mean)
#'
#' ## Selecting the minimum Procrustes shape for each species
#' min_procrustes <- select.procrustes(procrustes, selector = min,
#'                                     factors = list(which(plethodon$species == "Jord"),
#'                                                    which(plethodon$species == "Teyah")))
#' 
#' @seealso
#' 
#' @author Thomas Guillerme
#' @export

select.procrustes <- function(procrustes, selector = mean, factors){#, specimen = FALSE) {

    match_call <- match.call()

    ## procrustes
    class_procrustes <- check.class(procrustes, c("gpagen", "array", "list"))
    
    ## selector
    check.class(selector, "function")
    fun_level <- dispRity::make.metric(selector, silent = TRUE)
    if(fun_level != "level1") {
        stop("selector should output a single specific value.")
    }

    ## specimen
    # check.class(specimen, "logical")
    specimen <- FALSE

    ## Transform into array format
    if(class_procrustes != "array") {
        proc_bkp <- procrustes
        procrustes <- procrustes$coords
    }

    ## factors
    if(missing(factors)) {
        ## Try to return the consensus directly
        if(specimen == FALSE && class_procrustes == "gpagen" && is.null(match_call$selector)) {
            return(proc_bkp$consensus)
        } 
        do_factors <- FALSE
        factor_has_names <- FALSE
    
    } else {

        do_factors <- TRUE
        factor_has_names <- !is.null(names(factors))

        check.class(factors, "list")

        factor_classes <- c("integer", "numeric", "character")
        class_factors <- match(unique(unlist(lapply(factors, class))), factor_classes)
        if(any(is.na(class_factors))) {
            stop(paste0("factors must be of class ", paste(factor_classes, collapse = " or "), "."))
        }

        ## Check if the coordinates have names
        if(!is.null(attributes(procrustes)$dimnames[[3]])) {
            has_names <- TRUE
            coordi_names <- attributes(procrustes)$dimnames[[3]]
        } else {
            has_names <- FALSE
        }

        ## Check the factors dimensions and names
        if(all(class_factors == "character")) {
            if(!has_names) {
                stop(paste0("There are no names in ", as.expression(match_call$procrustes), " matching with the factors argument."))
            } else {
                ## Checking if the names match
                matching_names <- lapply(factors, match, coordi_names)
                if(any(is.na(unlist(matching_names)))) {
                    stop(paste0("The following names where not found in ", as.expression(match_call$procrustes), ": ", paste(which(is.na(unlist(matching_names))), collapse = ", "), "."))
                }
            }
            ## Convert the names into numerics
            factors <- matching_names
        }
    }

    if(do_factors) {
        ## Sort by factors
        procrustes <- lapply(factors, function(factor, procrustes) return(procrustes[,,factor]), procrustes = procrustes)
    } else {
        ## List the procrustes
        procrustes <- list(procrustes)
    }


    ## Get the selected value
    apply.fun <- function(procrustes_list, selector) {
        return(apply(procrustes_list, c(1,2) , selector))
    }
    selected_procrustes <- lapply(procrustes, apply.fun, selector)

    ## Adding names
    if(factor_has_names) {
        names(selected_procrustes) <- names(factors)
    }

    if(!specimen) {
        ## Return the selected procrustes
        return(selected_procrustes)
    
    } else {
        ## Find the closest specimen
        stop("The function does not work with specimen = TRUE yet.")
    }
}