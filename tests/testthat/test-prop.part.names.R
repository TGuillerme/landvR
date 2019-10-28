context("prop.part.names")

## Test
test_that("prop.part.names works", {

    ## Sanitizing
    error <- capture_error(prop.part.names("1"))
    expect_equal(error[[1]], "phy must be a \"phylo\" object.")
    error <- capture_error(prop.part.names(ape::rtree(4), singletons = "FALSE"))
    expect_equal(error[[1]], "singletons must be logical.")

    ## Right (simple) output
    set.seed(1)
    test_tree <- ape::rtree(5)
    test_names <- prop.part.names(test_tree)
    expect_names <- list(c("t2", "t1", "t3", "t4", "t5"), c("t1", "t3", "t4", "t5"), c("t1", "t3", "t4"), c("t3", "t4"))
    expect_is(
        test_names
        , "list")
    expect_equal(
        length(test_names)
        , length(ape::prop.part(test_tree)))
    for(t in seq_along(test_names)) {
        expect_equal(test_names[t], expect_names[t])
    }

    ## Output with tip labels
    test_names_tips <- prop.part.names(test_tree, singletons = TRUE)
    expect_names_tip <- c(list(c("t2", "t1", "t3", "t4", "t5"), c("t1", "t3", "t4", "t5"), c("t1", "t3", "t4"), c("t3", "t4")), as.list(test_tree$tip.label))
    expect_is(
        test_names_tips
        , "list")
    expect_equal(
        length(test_names_tips)
        , length(ape::prop.part(test_tree)) + Ntip(test_tree))
    for(t in seq_along(test_names_tips)) {
        expect_equal(test_names_tips[t], expect_names_tip[t])
    }


    ## Works with multifurcations
    star <- stree(5)
    expect_equal(prop.part.names(star), list(attr(prop.part(star), "labels")))
})
