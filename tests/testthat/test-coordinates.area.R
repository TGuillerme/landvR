#TESTING area.diff

context("coordinates.area")

#Test
test_that("coordinates.area sanitizing works", {

    ## Loading the geomorph dataset
    require(geomorph)
    data(plethodon)
    data(scallops)
    ## Performing the Procrustes superimposition
    proc_super_2D <- geomorph::gpagen(plethodon$land, print.progress = FALSE)$coords
    proc_super_3D <- geomorph::gpagen(scallops$coorddata, print.progress = FALSE)$coords
    diff_2D <- coordinates.difference(proc_super_2D)
    diff_2D_coord <- coordinates.difference(proc_super_2D, type = "spherical")
    expect_warning(diff_3D <- coordinates.difference(proc_super_3D, type = "vector"))

    ## Sanitizing
    expect_error(coordinates.area("proc_super_2D$coords"))
    expect_error(coordinates.area(diff_2D))
    expect_error(coordinates.area(diff_2D[[1]], what = "1"))
    expect_error(coordinates.area(diff_2D[[1]], what = 5))

    ## Works with all different types
    expect_equal(round(coordinates.area(diff_2D[[1]]), digits = 5), -0.10307)
    expect_equal(round(coordinates.area(diff_2D[[1]], 2), digits = 5), -0.00585)
    expect_equal(round(coordinates.area(diff_2D[[1]], 3), digits = 5), -0.10307)
    expect_equal(round(coordinates.area(diff_2D[[1]], 4), digits = 5), -0.00585)

    ## Work with specific what
    expect_equal(round(coordinates.area(diff_2D_coord[[2]], what = "radius"), digits = 5), 0.16272)
    expect_equal(round(coordinates.area(diff_2D_coord[[2]], what = "azimuth")), 476)
    expect_equal(round(coordinates.area(diff_3D[[3]], what = "length"), digits = 5), 1.28929)
    expect_equal(round(coordinates.area(diff_3D[[3]], what = "angle")), 420)
})
