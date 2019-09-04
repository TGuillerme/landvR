#TESTING area.diff

context("variation.range")

#Test
test_that("variation.range sanitizing works", {

    ## Loading the geomorph dataset
    require(geomorph)
    data(plethodon)
    data(scallops)
    ## Performing the Procrustes superimposition
    proc_super_2D <- geomorph::gpagen(plethodon$land, print.progress = FALSE)
    proc_super_3D <- geomorph::gpagen(scallops$coorddata, print.progress = FALSE)

    ## Errors
    expect_error(variation.range("proc_super_2D"))
    expect_error(variation.range(proc_super_2D, type = "bob"))
    expect_error(variation.range(proc_super_2D, angle = "bob"))
    expect_error(variation.range(proc_super_2D, what = "bob"))
    expect_error(variation.range(proc_super_2D, return.ID = "FALSE"))
    expect_error(variation.range(proc_super_2D, CI = 1209))
    error <- capture_error(variation.range(proc_super_2D, CI = -1))
    expect_equal(error[[1]], "CI must be a percentage or a probability.")
    expect_error(variation.range(proc_super_2D, ordination = "woops"))
    expect_error(variation.range(proc_super_2D, ordination = TRUE, axis = TRUE))
    expect_error(variation.range(proc_super_2D, ordination = TRUE, axis = 0))
    expect_error(variation.range(proc_super_2D, ordination = TRUE, axis = c(0,1,88)))


    ## No ordination
    test095 <- variation.range(proc_super_2D, CI = 0.95)
    test100 <- variation.range(proc_super_2D)
    test100_no_ord <- variation.range(proc_super_2D, ordination = FALSE)
    test095ID <- variation.range(proc_super_3D, CI = 0.95, return.ID = TRUE)
    test100ID <- variation.range(proc_super_3D, return.ID = TRUE)
    expect_is(test095, "matrix")
    expect_is(test100, "matrix")
    expect_equal(test100, test100_no_ord)
    expect_equal(dim(test095), c(12, 2))
    expect_equal(dim(test100), c(12, 2))
    expect_is(test095ID, "list")
    expect_is(test100ID, "list")
    expect_equal(names(test095ID), c("range", "min.max"))
    expect_equal(names(test100ID), c("range", "min.max"))
    expect_equal(dim(test095ID[[1]]), c(46, 3))
    expect_equal(dim(test100ID[[1]]), c(46, 3))

    ## Ordination (auto)
    test095 <- variation.range(proc_super_2D, ordination = TRUE, CI = 0.95)
    test100 <- variation.range(proc_super_2D, ordination = TRUE)
    expect_warning(test095ID <- variation.range(proc_super_2D, ordination = TRUE, CI = 0.95, axis = 1, return.ID = TRUE))
    expect_warning(test100ID <- variation.range(proc_super_2D, ordination = TRUE, axis = c(1,2), return.ID = TRUE))
    
    expect_is(test095, "matrix")
    expect_is(test100, "matrix")
    expect_equal(dim(test095), c(12, 2))
    expect_equal(dim(test100), c(12, 2))
    expect_is(test095ID, "list")
    expect_is(test100ID, "list")
    expect_equal(names(test095ID), c("range", "min.max"))
    expect_equal(names(test100ID), c("range", "min.max"))
    expect_equal(dim(test095ID[[1]]), c(12, 2))
    expect_equal(dim(test100ID[[1]]), c(12, 2))

    ## Ordination (input)
    array_2d <- geomorph::two.d.array(proc_super_2D$coords)
    tol <- stats::prcomp(array_2d)$sdev^2
    tolerance <- cumsum(tol)/sum(tol)
    tolerance <- length(which(tolerance < 1)) 
    if(length(tolerance) < length(tol)){
        tolerance <- tolerance + 1
    }
    tolerance <- max(c(tol[tolerance]/tol[1],0.005))
    ordination <- stats::prcomp(array_2d, center = TRUE, scale. = FALSE, retx = TRUE, tol = tolerance)
    test100_input <- variation.range(proc_super_2D, ordination = ordination)
    expect_true(all(test100 == test100_input))

    ## Input is an array
    test100 <- variation.range(proc_super_2D)
    test_array <- variation.range(proc_super_2D$coords)
    expect_is(test_array, "matrix")
    expect_is(test100, "matrix")
    expect_equal(dim(test_array), c(12, 2))
    expect_equal(dim(test100), c(12, 2))
    expect_equal(test100, test_array)

})
