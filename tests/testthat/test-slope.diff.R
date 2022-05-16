## Test
test_that("slope.diff works", {

    ## Sanitizing
    error <- capture_error(slope.diff("1", "a"))
    expect_equal(error[[1]], "slope1 must be of class numeric or integer.")
    error <- capture_error(slope.diff(1, "a"))
    expect_equal(error[[1]], "slope2 must be of class numeric or integer.")
    error <- capture_error(slope.diff(1, 2, "degreee"))
    expect_equal(error[[1]], "angle must be one of the following: degree, radian.")
    error <- capture_error(slope.diff(1, 2, "degree", "a"))
    expect_equal(error[[1]], "significance must be of class numeric or integer.")
    
    ## Right output
    expect_is(
        slope.diff(1, 2)
        , "numeric")

    set.seed(1)
    ## A random dataset
    data <- as.data.frame(replicate(3, rnorm(10)))
    colnames(data) <- letters[1:3]

    ## Two slopes
    slope_b <- lm(a ~ b, data)$coefficients[["b"]]
    slope_c <- lm(a ~ c, data)$coefficients[["c"]]

    ## The slope difference
    expect_equal(round(slope.diff(slope_b, slope_c), 4), 25.3117)
    ## The slope difference in radian
    expect_equal(round(slope.diff(slope_b, slope_c, "radian"), 4), 0.4418)
    ## Whether the slope difference is lower than 4.5 degrees
    expect_false(slope.diff(slope_b, slope_c, significance = 25))
    expect_true(slope.diff(slope_b, slope_c, significance = 26))
})
