#TESTING area.diff

context("select.procrustes")

#Test
test_that("select.procrustes sanitizing works", {

    ## Loading the geomorph dataset
    require(geomorph)
    data(plethodon)
    data(scallops)
    ## Performing the Procrustes superimposition
    proc_super_2D <- geomorph::gpagen(plethodon$land, print.progress = FALSE)
    proc_super_3D <- geomorph::gpagen(scallops$coorddata, print.progress = FALSE)

    ## Sanitizing
    expect_error(select.procrustes(proc_super_2D, selector = "mean", specimen = FALSE))
    expect_error(select.procrustes(proc_super_2D, selector = mean, factors = "bla", specimen = FALSE))
    expect_error(select.procrustes(proc_super_2D, selector = mean, factors = list(c(1:20), c(21:40)), specimen = "BLA"))
    expect_error(select.procrustes(proc_super_2D$coords, selector = var, specimen = FALSE))


    ## Should be equal to the consensus
    expect_equal(as.vector(round(select.procrustes(proc_super_2D$coords, selector = mean, specimen = FALSE)[[1]], 8)), as.vector(unname(round(proc_super_2D$consensus, 8))))
    expect_equal(as.vector(round(select.procrustes(proc_super_2D, selector = mean, specimen = FALSE)[[1]], 8)), as.vector(round(proc_super_2D$consensus, 8)))
    expect_equal(as.vector(round(select.procrustes(proc_super_3D$coords, selector = mean, specimen = FALSE)[[1]], 8)), as.vector(round(proc_super_3D$consensus, 8)))
    expect_equal(as.vector(round(select.procrustes(proc_super_3D, selector = mean, specimen = FALSE)[[1]], 8)), as.vector(round(proc_super_3D$consensus, 8)))

    ## Works with different functions
    default <- select.procrustes(proc_super_2D$coords)
    median <-  select.procrustes(proc_super_2D$coords, selector = median)
    expect_false(all(default[[1]] == median[[1]]))

    ## Works with numeric factors
    test1 <- select.procrustes(proc_super_2D, factors = list("a" = c(1:5), "b" = c(6,7), "c" = c(8:40)))
    expect_equal(length(test1), 3)
    expect_equal(names(test1), letters[1:3])

    ## Works with character factors
    names <- apply(expand.grid(letters[1:2], letters[1:26]), 1, function(x) paste(x, collapse = ""))[1:40]
    attributes(proc_super_2D$coord)$dimnames[[3]] <- apply(expand.grid(letters[1:2], letters[1:26]), 1, function(x) paste(x, collapse = ""))[1:40]
    factors <- sample(apply(expand.grid(letters[1:2], letters[1:26]), 1, function(x) paste(x, collapse = ""))[1:40])
    factors <- list(c(factors[1:21]), c(factors[22:40]))

    test2 <- select.procrustes(proc_super_2D$coord, factors = factors)
    expect_equal(length(test2), 2)
    expect_null(names(test2))
})
