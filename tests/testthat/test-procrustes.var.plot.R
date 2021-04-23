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


    ## Errors
    error <- capture_error(procrustes.var.plot(M1, M2[,-1, drop = FALSE]))
    expect_equal(error[[1]], "M1 and M2 do not have the same number of dimensions!")
    error <- capture_error(procrustes.var.plot(M1[,-1, drop = FALSE], M2[,-1, drop = FALSE]))
    expect_equal(error[[1]],"M1 and M2 must be 2D or 3D matrices.")
    M1na <- M1 ; M1na[1,1] <- NA
    error <- capture_error(procrustes.var.plot(M1na, M2))
    expect_equal(error[[1]],"Data in M1 contains missing values. Estimate these first (see 'geomorph::estimate.missing').")
    M2na <- M2 ; M2na[1,1] <- NA
    error <- capture_error(procrustes.var.plot(M1, M2na))
    expect_equal(error[[1]],"Data in M2 contains missing values. Estimate these first (see 'geomorph::estimate.missing').")
    error <- capture_error(procrustes.var.plot(M1, M2, col = list(1)))
    expect_equal(error[[1]], "col argument must be a single value, vector (of the same number of rows as M1) or function or a list of two of any of the former.")
    error <- capture_error(procrustes.var.plot(M1, M2, col = list("red", "red", "red")))
    expect_equal(error[[1]], "col argument must be a single value, vector (of the same number of rows as M1) or function or a list of two of any of the former.")
    error <- capture_error(procrustes.var.plot(M1, M2, col = 1))
    expect_equal(error[[1]], "col argument must be a single value, vector (of the same number of rows as M1) or function or a list of two of any of the former.")
    error <- capture_error(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink"), col.val = var_val[1:2]))
    expect_equal(error[[1]],"col.val should be a list of two vectors or a vector, all of the same length as the number of rows in M1 and M2.")
    error <- capture_error(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink"), col.val = list(var_val[1:2], var_val)))
    expect_equal(error[[1]],"col.val should be a list of two vectors or a vector, all of the same length as the number of rows in M1 and M2.")
    error <- capture_error(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink")))
    expect_equal(error[[1]],"col.val argument is missing with no default.")


    ## Default plot
    expect_null(procrustes.var.plot(M1, M2))
    expect_warning(expect_null(procrustes.var.plot(geomorph::mshape(proc_super$coords), geomorph::mshape(proc_super$coords))))
    expect_null(procrustes.var.plot(M1, M2, magnitude = 3))
    expect_null(procrustes.var.plot(M1, M2, gridPar = list(tar.out.col = "black", tar.out.cex = 0.1)))
    expect_null(procrustes.var.plot(M1, M2, labels = TRUE, axes = TRUE))
    expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink"), col.val = var_val, pt.size = 2.5))
    expect_null(procrustes.var.plot(M1, M2, col = grDevices::rainbow, col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = "pink", col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = list("pink", grDevices::rainbow), col.val = var_val))
    expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::heat.colors, grDevices::rainbow), col.val = var_val))

    ## Example plots (with col.range)
    expect_null(procrustes.var.plot(M1, M2, main = "Uncolored variation"))
    expect_null(procrustes.var.plot(M1, M2, col = grDevices::heat.colors, col.val = var_val, main = "Relative colours"))
    expect_null(procrustes.var.plot(M1, M2, col = grDevices::heat.colors, col.val = var_val, col.range = c(0, 0.2), main = "Absolute colours (range = c(0, 0.2))"))


    # ## Loading the scallops 3D data from geomorph
    # require(geomorph)
    # data(scallops)

    # ## Procrustes superimposition
    # procrustes <- gpagen(scallops$coorddata, print.progress = FALSE)

    # ## Getting the range of variation
    # variation <- variation.range(procrustes, return.ID = TRUE)

    # ## Selecting the coordinates and the variation vector
    # M1 <- procrustes$coords[, , variation$min.max[1]]
    # M2 <- procrustes$coords[, , variation$min.max[2]]
    # var_val <- variation$range[, 1]
     
    # ## Default plot
    # expect_null(procrustes.var.plot(M1, M2))
    # expect_null(procrustes.var.plot(M1, M2, labels = TRUE, axes = TRUE))
    # expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::rainbow, "pink"), col.val = var_val, pt.size = 2.5))
    # expect_null(procrustes.var.plot(M1, M2, col = grDevices::rainbow, col.val = var_val))
    # expect_null(procrustes.var.plot(M1, M2, col = "pink", col.val = var_val))
    # expect_null(procrustes.var.plot(M1, M2, col = list("pink", grDevices::rainbow), col.val = var_val))
    # expect_null(procrustes.var.plot(M1, M2, col = list(grDevices::heat.colors, grDevices::rainbow), col.val = var_val))


})
