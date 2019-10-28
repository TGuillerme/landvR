context("rarefy.stat")

## Test
test_that("rarefy.stat works", {

    ## Some data
    data <- replicate(2, rnorm(50))
    my.stat <- function(data) {t.test(data[1, ], data[2, ])$statistic[[1]]}

    ## Sanitizing
    error <- capture_error(rarefy.stat("data", stat.fun = my.stat, rarefaction = 5))
    expect_equal(error[[1]], "data must be of class matrix or data.frame.")
    error <- capture_error(rarefy.stat(data, stat.fun = "my.stat", rarefaction = 5))
    expect_equal(error[[1]], "stat.fun must be of class function.")
    error <- capture_error(rarefy.stat(data, stat.fun = my.stat, rarefaction = "5"))
    expect_equal(error[[1]], "rarefaction must be of class numeric or integer.")
    error <- capture_warning(rarefy.stat(data, stat.fun = my.stat, rarefaction = 500))
    expect_equal(error[[1]], "Rarefaction value (500) is bigger than the number of rows in the data (50).\nThe statistic will be only bootstrapped.")
    error <- capture_error(rarefy.stat(data, stat.fun = my.stat, rarefaction = 5, replicates = "1"))
    expect_equal(error[[1]], "replicates must be of class numeric or integer.")
    error <- capture_error(rarefy.stat(data, stat.fun = my.stat, rarefaction = 5, observed = "ha"))
    expect_equal(error[[1]], "observed must be of class numeric or integer.")


    ## Right output
    results <- rarefy.stat(data, my.stat, rarefaction = 10)
    expect_is(
        results
        , "numeric")
    expect_equal(
        length(results)
        , 100)
})