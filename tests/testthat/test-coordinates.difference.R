#TESTING area.diff

context("coordinates.difference")

## Loading the geomorph dataset
require(geomorph)
data(plethodon)
data(scallops)

## Performing the Procrustes superimposition
proc_super_2D <- geomorph::gpagen(plethodon$land, print.progress = FALSE)
proc_super_3D <- geomorph::gpagen(scallops$coorddata, print.progress = FALSE)
coord <- proc_super_2D$coord
tmp <- sapply(1:dim(coord)[3], function(x, coord) return(list(coord[,,x])), coord)
tmp[[40]] <- matrix(rnorm(25), 5, 5)
names(coord) <- seq(1:40)
attributes(proc_super_2D$coord)$dimnames[[3]] <- seq(1:40)
#Test
test_that("coordinates.difference sanitizing works", {

    ## Data must be array list or matrix
    expect_error(coordinates.difference("proc_super_2D$coords", proc_super_2D$consensus))
    expect_error(coordinates.difference(proc_super_2D$coords, "proc_super_2D$consensus"))
    expect_error(coordinates.difference(tmp))

    ## Reference must be a matrix
    expect_error(coordinates.difference(proc_super_2D$coords, proc_super_2D$coords))
    ## Can't be different sizes
    expect_error(coordinates.difference(proc_super_2D$coords, proc_super_3D$consensus))

    ## Adding the names works
    expect_equal(names(coordinates.difference(coord)), as.character(seq(1:40)))
    expect_equal(names(coordinates.difference(proc_super_2D$coord)), as.character(seq(1:40)))

    ## Method are checked properly
    expect_error(coordinates.difference(coord, type = "whatever"))
    expect_error(coordinates.difference(coord, angle = "whatever"))
    expect_error(coordinates.difference(coord, absolute.distance = "whatever"))

})

test_that("cartesian works", {

    ## Example 2D
    cartesian_diff <- coordinates.difference(proc_super_2D$coords, proc_super_2D$consensus)

    ## Right format
    expect_is(cartesian_diff, "list")
    expect_equal(length(cartesian_diff), dim(proc_super_2D$coords)[3])
    expect_equal(dim(cartesian_diff[[1]]), c(dim(proc_super_2D$coords)[1], dim(proc_super_2D$coords)[2]*2))
    expect_equal(colnames(cartesian_diff[[1]]), c("x0", "y0", "x1", "y1"))
    
    ## Example 3D
    ## Example 2D
    cartesian_diff <- coordinates.difference(proc_super_3D$coords, proc_super_3D$consensus)

    ## Right format
    expect_is(cartesian_diff, "list")
    expect_equal(length(cartesian_diff), dim(proc_super_3D$coords)[3])
    expect_equal(dim(cartesian_diff[[1]]), c(dim(proc_super_3D$coords)[1], dim(proc_super_3D$coords)[2]*2))
    expect_equal(colnames(cartesian_diff[[1]]), c("x0", "y0", "z0", "x1", "y1", "z1"))
    
})


test_that("spherical works", {

    ## Example 2D
    spherical_diff <- coordinates.difference(proc_super_2D$coords, proc_super_2D$consensus, type = "spherical")

    ## Right format
    expect_is(spherical_diff, "list")
    expect_equal(length(spherical_diff), dim(proc_super_2D$coords)[3])
    expect_equal(dim(spherical_diff[[1]]), c(dim(proc_super_2D$coords)[1], dim(proc_super_2D$coords)[2]))
    expect_equal(colnames(spherical_diff[[1]]), c("radius", "azimuth"))
    
    ## Example 3D
    spherical_diff <- coordinates.difference(proc_super_3D$coords, proc_super_3D$consensus, type = "spherical")

    ## Right format
    expect_is(spherical_diff, "list")
    expect_equal(length(spherical_diff), dim(proc_super_3D$coords)[3])
    expect_equal(dim(spherical_diff[[1]]), c(dim(proc_super_3D$coords)[1], dim(proc_super_3D$coords)[2]))
    expect_equal(colnames(spherical_diff[[1]]), c("radius", "azimuth", "polar"))
    
})


test_that("vector works", {

    ## Example 3D
    vector_diff <- coordinates.difference(proc_super_3D$coords, proc_super_3D$consensus, type = "vector")

    ## Right format
    expect_is(vector_diff, "list")
    expect_equal(length(vector_diff), dim(proc_super_3D$coords)[3])
    expect_equal(dim(vector_diff[[1]]), c(dim(proc_super_3D$coords)[1], dim(proc_super_3D$coords)[2]-1))
    expect_equal(colnames(vector_diff[[1]]), c("length", "angle"))

    ## Example 2D
    vector_diff <- coordinates.difference(proc_super_2D$coords, proc_super_2D$consensus, type = "vector")

    ## Right format
    expect_is(vector_diff, "list")
    expect_equal(length(vector_diff), dim(proc_super_2D$coords)[3])
    expect_equal(dim(vector_diff[[1]]), c(dim(proc_super_2D$coords)[1], dim(proc_super_2D$coords)[2]))
    expect_equal(colnames(vector_diff[[1]]), c("length", "angle"))
    

    ## With absolute distance
  
    ## Example 3D
    expect_warning(vector_diff_noabs <- coordinates.difference(proc_super_2D$coords, type = "vector", absolute.distance = FALSE))
    expect_lt(vector_diff_noabs[[40]][1,1], 0)
    expect_gt(vector_diff[[40]][1,1], 0)

})
