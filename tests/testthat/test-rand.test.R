#TESTING rand.test

context("rand.test")

#Test
test_that("rand.test sanitizing works", {

    expect_error(rand.test(rnorm(1), 1:10, test = t.test))
    expect_error(rand.test("a", 1:10, test = t.test))
    expect_error(rand.test(rnorm(100), "1:10", test = t.test))
    expect_error(rand.test(rnorm(100), 1:10, test = var))
    expect_error(rand.test(rnorm(100), 1:10, test = "var"))
    expect_error(rand.test(rnorm(100), 1:10, test = t.test, replicates = "q"))
    expect_error(rand.test(rnorm(100), 1:10, test = t.test, replicates = 100, resample = "FALSE"))
    expect_error(rand.test(rnorm(100), 1:10, test = t.test, test.parameter = "TRUE"))
    expect_error(rand.test(rnorm(100), 1:10, test = t.test, test.parameter = TRUE, parameter = "bob"))
    expect_error(rand.test(rnorm(100), 1:10, test = t.test, replicates = 100, resample = FALSE, test.parameter = TRUE, parameter = "statistic", alternative = "three-sided"))    
    error <- capture_error(rand.test(rnorm(100), 1:10, test = t.test, replicates = -1))
    expect_equal(error[[1]], "At least one replicate must be run.")
    error <- capture_error(rand.test(rnorm(100), 1:10, test = t.test, rarefaction = 12))
    expect_equal(error[[1]], "The rarefaction values is bigger than the subset size.")
    dumb.fun <- function(x,y) {return(list("bob" = x, "bib" =y))}
    error <- capture_error(rand.test(rnorm(100), 1:10, test = dumb.fun, test.parameter = TRUE))
    expect_equal(error[[1]], "Impossible to find a default parameter (statistic or simple output) to test.\nSpecify the parameter name with the argument:\nrand.test(..., parameter = \"my_parameter\")")
    warn <- capture_warning(rand.test(rnorm(100), 1:10, test = dumb.fun, test.parameter = FALSE))
    expect_equal(warn[[1]], "Impossible to find a default parameter (statistic or simple output) to output.\nplotting the results through plot(...) won't work directly.")
})

test_that("rand.test examples work", {
    ## Loading the geomorph dataset
    require(geomorph)
    data(plethodon)
    proc_super <- gpagen(plethodon$land, print.progress = FALSE)
    var_range <- variation.range(proc_super)

    set.seed(1)
    random_part <- sample(1:nrow(var_range), 6)

    ## Testing whether this difference is expected by chance
    random_test <- rand.test(var_range[, "radius"], random_part, test = stats::t.test,
                            test.parameter = TRUE)
    expect_is(random_test, "randtest")
    expect_equal(names(random_test), c("rep","observed", "random", "call", "sim", "obs", "plot", "alter", "pvalue", "expvar"))
    random_test <- rand.test(var_range[, "radius"], random_part, test = stats::t.test,
                            test.parameter = TRUE, alternative = "greater")
    expect_is(random_test, "randtest")
    expect_equal(names(random_test), c("rep","observed", "random", "call", "sim", "obs", "plot", "alter", "pvalue", "expvar"))
    random_test <- rand.test(var_range[, "radius"], random_part, test = stats::t.test,
                            test.parameter = TRUE, alternative = "lesser")
    expect_is(random_test, "randtest")
    expect_equal(names(random_test), c("rep","observed", "random", "call", "sim", "obs", "plot", "alter", "pvalue", "expvar"))

    ## Rarefied test
    rarefy_test <- rand.test(var_range[, "radius"], random_part, rarefaction = 5,
                             test = t.test)
    expect_is(rarefy_test, "randtest")
    expect_equal(names(rarefy_test), c("rep","observed", "random", "call", "sim", "obs", "plot", "alter", "pvalue", "expvar"))

    rarefy_test2 <- rand.test(var_range[, "radius"], random_part, rarefaction = 5,
                             test = t.test, test.parameter = TRUE)
    expect_is(rarefy_test2, "randtest")
    expect_equal(names(rarefy_test2), c("rep","observed", "random", "call", "sim", "obs", "plot", "alter", "pvalue", "expvar"))

})
