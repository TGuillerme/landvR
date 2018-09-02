#TESTING procrustes.var.plot

context("procrustes.var.plot")

#Test
test_that("procrustes.var.plot sanitizing works", {
    ## Loading the geomorph dataset
    require(geomorph)
    data(plethodon)

    ## Performing the Procrustes superimposition
    proc_super <- gpagen(plethodon$land, print.progress = FALSE)
    variation <- variation.range(proc_super, return.ID = TRUE)
    M1 <- proc_super$coords[, , variation$min.max[1]]
    M2 <- proc_super$coords[, , variation$min.max[2]]
    var_val <- variation$range[, 1]

    ## Default plot
    expect_null(procrustes.var.plot(M1, M2))
    expect_null(procrustes.var.plot(M1, M2, labels = TRUE, axes = TRUE))
    expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink"), col.val = var_val, pt.size = 2.5))
    expect_null(procrustes.var.plot(M1, M2, col = grDevices::rainbow, col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = "pink", col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = list("pink", grDevices::rainbow), col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::heat.colors, grDevices::rainbow), col.val = var_val))

    ## Loading the scallops 3D data from geomorph
    require(geomorph)
    data(scallops)

    ## Procrustes superimposition
    procrustes <- gpagen(scallops$coorddata, print.progress = FALSE)

    ## Getting the range of variation
    variation <- variation.range(procrustes, return.ID = TRUE)

    ## Selecting the coordinates and the variation vector
    M1 <- procrustes$coords[, , variation$min.max[1]]
    M2 <- procrustes$coords[, , variation$min.max[2]]
    var_val <- variation$range[, 1]
     
    ## Default plot
    expect_null(procrustes.var.plot(M1, M2))
    expect_null(procrustes.var.plot(M1, M2, labels = TRUE, axes = TRUE))
    expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink"), col.val = var_val, pt.size = 2.5))
    expect_null(procrustes.var.plot(M1, M2, col = grDevices::rainbow, col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = "pink", col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = list("pink", grDevices::rainbow), col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::heat.colors, grDevices::rainbow), col.val = var_val))


})
