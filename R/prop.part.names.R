#' @title Get the partitions tip labels from a tree
#'
#' @description Get the names of the tip labels in each bipartition (clade) of a tree.
#'
#' @param phy an object of class \code{"phylo"}
#' @param singletons logical, whether to include tips as singletons (\code{TRUE}) or not (\code{FALSE} - default)
#' @param inc.nodes logical, whether to include nodes in the clades (\code{TRUE}) or not (\code{FALSE} - default). If \code{TRUE}, \code{phy} must have node labels.
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

prop.part.names <- function(phy, singletons = FALSE, inc.nodes = FALSE) {
    ## Sanitizing
    if(!is(phy, "phylo")) {
        stop("phy must be a \"phylo\" object.")
    }
    if(!is(singletons, "logical")) {
        stop("singletons must be logical.")
    }
    if(!is(inc.nodes, "logical")) {
        stop("inc.nodes must be logical.")
    }
    if(inc.nodes && is.null(phy$node.label)) {
        stop("no node labels found in phy for the option inc.nodes.")
    }

    ## Get the bipartitions
    clades <- ape::prop.part(phy)

    ## Get the tips names for each clades
    clades <- lapply(clades, function(clade, labels) labels[clade], labels = attr(clades, "labels"))

    ## Add node labels
    if(inc.nodes) {
        get.node.labels <- function(tips, phy) {
            if(length(tips) != Ntip(phy)) {
                return(drop.tip(phy, tip =phy$tip.label[!(phy$tip.label %in% tips)])$node.label)
            } else {
                return(phy$node.label)
            }
        }
        clade_nodes <- lapply(clades, get.node.labels, phy = phy)
        clades <- mapply(c, clades, clade_nodes)
    }

    ## Add the tip names
    if(singletons) {
        clades <- c(clades, as.list(phy$tip.label))
    }

    return(clades)
}