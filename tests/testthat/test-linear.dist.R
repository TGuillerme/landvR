## Test
test_that("linear.dist works", {

    ## Sanitizing
    expect_error(linear.dist(1, c(1,2)))
    expect_error(linear.dist(matrix(NA), c(1)))

    ## Loading the plethodon dataset
    require(geomorph)
    data(plethodon)

    ## Performing a procrustes superimposition
    procrustes <- geomorph::gpagen(plethodon$land, print.progress = FALSE)

    ## Datasets
    array_test <- procrustes$coords
    matrix <- procrustes$coords[,,1]
    list <- array.to(procrustes, "list")

    ## Errors
    wrong_list <- list ; wrong_list[[40]] <- wrong_list[[40]][,-1, drop = FALSE] 
    error <- capture_error(linear.dist(wrong_list, c(1,2)))
    expect_equal(error[[1]], "Not all the specimens have the same number of dimensions!")
    wrong_list <- list ; wrong_list[[40]] <- wrong_list[[40]][-1,, drop = FALSE] 
    error <- capture_error(linear.dist(wrong_list, c(1,2)))
    expect_equal(error[[1]], "Not all the specimens have the same number of landmarks!")
    error <- capture_error(linear.dist(matrix, 1))
    expect_equal(error[[1]], "measurements must be a pair of landmarks (or multiple pairs).")
    error <- capture_error(linear.dist(matrix, c(1, 15)))
    expect_equal(error[[1]], "landmark IDs in measurements argument cannot be greater than the number of landmarks (12).")


    ## Right output for a single measurement
    expect_is(
        linear.dist(matrix, c(1,2))
        , "numeric")
    expect_equal(
        length(linear.dist(matrix, c(1,2)))
        , 1)
    expect_is(
        linear.dist(array_test, c(1,2))
        , "matrix")
    expect_equal(
        length(linear.dist(array_test, c(1,2)))
        , 40)
    expect_is(
        linear.dist(list, c(1,2))
        , "matrix")
    expect_equal(
        length(linear.dist(list, c(1,2)))
        , 40)

    ## Right output for multiple measurements
    test_mat <- linear.dist(matrix, list(c(1,2), c(2,3), c(4,5)))
    test_mat2 <- linear.dist(matrix, list("a" = c(1,2), "b" = c(2,3), "c" = c(4,5)))
    expect_is(test_mat, "numeric")
    expect_is(test_mat2, "numeric")
    expect_equal(length(test_mat), 3)
    expect_equal(names(test_mat2), letters[1:3])

    test_array_test <- linear.dist(array_test, list("a" = c(1,2), "b" = c(2,3), "c" = c(4,5)))
    expect_is(test_array_test, "matrix")
    expect_equal(dim(test_array_test), c(40, 3))

    test_list <- linear.dist(list, list("a" = c(1,2), "b" = c(2,3), "c" = c(4,5)))
    expect_is(test_list, "matrix")
    expect_equal(dim(test_list), c(40, 3))

    test_procrustes <- linear.dist(procrustes, list("a" = c(1,2), "b" = c(2,3), "c" = c(4,5)))
    expect_is(test_procrustes, "matrix")
    expect_equal(dim(test_procrustes), c(40, 3))



    data(scallops)
    proc_super_3D <- geomorph::gpagen(scallops$coorddata, print.progress = FALSE)
    test_procrustes <- linear.dist(proc_super_3D, list("a" = c(1,2), "b" = c(2,3), "c" = c(4,5)))
    expect_is(test_procrustes, "matrix")
    expect_equal(dim(test_procrustes), c(5, 3))



})
