#TESTING area.diff

context("variation.range")

#Test
test_that("variation.range sanitizing works", {

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



})
