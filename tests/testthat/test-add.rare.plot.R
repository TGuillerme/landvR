#TESTING add.rare.plot

context("add.rare.plot")

#Test
test_that("add.rare.plot works", {

    require(geomorph)
    data(plethodon)
    proc_super <- gpagen(plethodon$land, print.progress = FALSE)
    var_range <- variation.range(proc_super)
    set.seed(1)
    random_part <- sample(1:nrow(var_range), 6)

    ## Rarefying the area difference to 4 elements without testing the parameter
    rarefy_test <- rand.test(var_range[, "radius"], random_part, rarefaction = 5,
                             test = area.diff)
    expect_is(rarefy_test, "randtest")
    expect_equal(names(rarefy_test), c("rep", "observed", "random", "call", "sim", "obs", "plot", "alter", "pvalue", "expvar"))

    ## Plotting the results (central tendency)
    expect_null(plot(rarefy_test))

    ## Add the rarefied observations to the plot
    expect_null(add.rare.plot(rarefy_test))

})
