#' @title Update GPA and PCA
#' 
#' @description Adds new specimens (landmarks) to an existing GPA and PCA.
#'
#' @param original_data Either an \code{"array"} that is a named set of n landmarks in D dimensions corresponding to the original specimens; or directly a \code{"nosymproc"} or \code{"symproc"} object output from \code{Morpho::procSym}.
#' @param new_landmarks a named set of n landmarks in D dimensions corresponding to the new specimens
#' @param ... any optional arguments to pass to ProcSym
#' 
#' @details
#' This function does the following:
#' \begin{itemize}
#' \item 1- Either runs a GPA (using \code{Morpho::ProcSym}) and a PCA (using \code{stats::prcomp}) if the input is an \code{"array"} of landmarks; or extracts the GPA and runs a PCA (using \code{stats::prcomp}) if the input is a \code{"nosymproc"} or \code{"symproc"} object.
#' \item 2- Aligns the new landmarks onto the original GPA (using \code{Morpho::align2procSym}).
#' \item 3- Projects these superimposed landmarks onto the original PCA (using \code{stats::predict}).
#' \item 4- Merges and output the combined PCA containing the new specimens.
#' \end{itemize}
#'
#' @examples
#'
#' ## Get some 3D data from Morpho
#' library(Morpho)
#' data(boneData)
#' original_landmarks <- boneLM
#' 
#' ## Generate some random 3D data
#' new_spec <- array(data = c(apply(original_landmarks, c(1,2), mean),
#'                            apply(original_landmarks, c(1,2), median),
#'                            unlist(select.procrustes(proc_orig$rotated, selector = min))),
#'                            dim = c(10, 3, 3))
#' dimnames(new_spec)[[3]] <- paste0("new_", c("mean", "median", "min"))
#' 
#' 
#' ## Run the GPA/PCA from the landmarks
#' update.gpa.pca(original_landmarks, new_spec)
#' 
#' ## Run the GPA/PCA from a GPA
#' proc_orig <- Morpho::procSym(original_landmarks)
#' update.gpa.pca(proc_orig, new_spec)
#'
#' 
#' @author Thomas Guillerme
#' @export

update.gpa.pca <- function(original_data, new_landmarks, ...) {

    ## Sanitizing
    input_class <- check.class(original_data, c("array", "symproc", "nosymproc"))
    check.class(new_landmarks, "array")
    if(is.null(dimnames(new_landmarks)[[3]])) {
        stop("No names found for the new landmarks. You can add them using:\ndimnames(new_landmarks)[[3]] <- my_names")
    }

    if(input_class == "array") {
        ## Run the GPA for the original landmarks
        original_gpa <- Morpho::procSym(original_data, ...)
    } else {
        original_gpa <- original_data
    }

    ## Transform the GPA into a matrix
    original_gpa_matrix <- array.to(original_gpa$rotated, to = "matrix")
    ## Run the PCA for the original GPA
    original_pca <- stats::prcomp(original_gpa_matrix)

    ## Project the new specimens on the original GPA
    new_gpa <- Morpho::align2procSym(original_gpa, new_landmarks)
    dimnames(new_gpa)[[3]] <- dimnames(new_landmarks)[[3]]
    ## Transform the GPA into a matrix
    new_gpa_matrix <- array.to(new_gpa, to = "matrix")
    ## Project the new GPAed specimens onto the PCA
    new_pca <- stats::predict(original_pca, newdata = new_gpa_matrix)

    ## Combine the new and old matrices for the output PCA
    return(rbind(original_pca$x, new_pca))
}

# test <- update.gpa.pca(original_landmarks, new_spec)
# expect_is(test, "matrix")
# expect_equal(dim(test), c(dim(original_landmarks)[3]+ dim(new_spec)[3], 30))