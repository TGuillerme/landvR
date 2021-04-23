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
    expect_error(select.procrustes(proc_super_2D, selector = "mean"))
    expect_error(select.procrustes(proc_super_2D, selector = mean, factors = "bla"))
    expect_error(select.procrustes(proc_super_2D$coords, selector = var))
    error <- capture_error(select.procrustes(proc_super_2D, factors = list(mean, var)))
    expect_equal(error[[1]], "factors must be of class integer or numeric or character.")
    error <- capture_error(select.procrustes(proc_super_2D, factors = list("a", "b", "c")))
    expect_equal(error[[1]], "There are no names in proc_super_2D matching with the factors argument.")
    named_spec <- proc_super_2D
    dimnames(named_spec$coords)[[3]] <- paste0("sp", (1:40))
    error <- capture_error(select.procrustes(named_spec, factors = list("sp1", "sp2", "sp41")))
    expect_equal(error[[1]], "The following names where not found in named_spec: sp41.")    

    ## Should be equal to the consensus
    expect_equal(as.vector(round(select.procrustes(proc_super_2D$coords, selector = mean)[[1]], 8)), as.vector(unname(round(proc_super_2D$consensus, 8))))
    expect_equal(as.vector(round(select.procrustes(proc_super_2D, selector = mean)[[1]], 8)), as.vector(round(proc_super_2D$consensus, 8)))
    expect_equal(as.vector(round(select.procrustes(proc_super_3D$coords, selector = mean)[[1]], 8)), as.vector(round(proc_super_3D$consensus, 8)))
    expect_equal(as.vector(round(select.procrustes(proc_super_3D, selector = mean)[[1]], 8)), as.vector(round(proc_super_3D$consensus, 8)))

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

    test3 <- select.procrustes(named_spec, factors = list("sp1", "sp2", "sp40"))
    expect_equal(length(test3), 3)
    expect_null(names(test3))
})
