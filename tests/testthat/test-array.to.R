context("array.to")

## Test
test_that("array.to works", {

    ## Loading the plethodon dataset
    require(geomorph)
    data(plethodon)

    ## Performing a procrustes superimposition
    procrustes <- geomorph::gpagen(plethodon$land, print.progress = FALSE)

    ## Sanitizing
    expect_error(array.to(matrix(), "list"))
    expect_error(array.to(procrustes, "blob"))

    ## Right output
    expect_is(
        array.to(procrustes, "matrix")
        , "matrix")
    expect_is(
        array.to(procrustes$coords, "matrix")
        , "matrix")
    expect_is(
        array.to(procrustes, "list")
        , "list")
    expect_is(
        array.to(procrustes$coords, "list")
        , "list")

})
