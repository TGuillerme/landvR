#' @title Get the partitions tip labels from a tree
#'
#' @description Get the names of the tip labels in each bipartition (clade) of a tree.
#'
#' @param phy an object of class \code{"phylo"}
#' @param singletons logical, whether to include tips as singletons (\code{TRUE}) or not (\code{FALSE} - default)
#' 
#' @examples
#' ## The partition's tip labels
#' prop.part.names(ape::rtree(5))
#' 
#' ## The partition's tip labels (including singletons)
#' prop.part.names(ape::rtree(3), singletons = TRUE)
#' 
#' ## The partition's tip labels of a list of trees
#' lapply(ape::rmtree(2, 3), prop.part.names)
#'
#' @seealso \code{\link[ape]{prop.part}}
#' 
#' @author Thomas Guillerme
#' @export
# @importFrom ape prop.part
# @importFrom ape rtree
# @importFrom ape rmtree

prop.part.names <- function(phy, singletons = FALSE) {
    ## Sanitizing
    if(class(phy) != "phylo") {
        stop("phy must be a \"phylo\" object.")
    }
    if(class(singletons) != "logical") {
        stop("singletons must be logical.")
    }

    ## Get the bipartitions
    clades <- ape::prop.part(phy)

    ## Get the tips names for each clades
    clades <- lapply(clades, function(clade, labels) labels[clade], labels = attr(clades, "labels"))

    ## Add the tip names
    if(singletons) {
        clades <- c(clades, as.list(phy$tip.label))
    }

    return(clades)
}