#TESTING area.diff

context("area.diff")

#Test
test_that("area.diff works", {

    ## Errors handling
    expect_error(area.diff(rnorm(10), "a"))
    expect_error(area.diff("a", rnorm(10)))
    expect_error(area.diff(rnorm(10), rnorm(10), rarefy = "a"))
    expect_error(area.diff(rnorm(10), rnorm(10), rarefy = 10, cent.tend = "a"))
    expect_error(area.diff(rnorm(10), rnorm(10), rarefy = 10, cent.tend = centroids))
    expect_error(area.diff(rnorm(10), rnorm(10), sort = "a"))

    ## Correct calculations for simple areas
    x <- seq(1:10)
    y <- seq(1:10)
    expect_equal(area.diff(x, y), 0)
    expect_equal(area.diff(x, rev(y)), 0)
    expect_equal(area.diff(x, rev(y), sort = FALSE), 0)

    ## Calculation works for different sized samples
    x <- rnorm(10)
    y <- rnorm(100)
    expect_is(area.diff(x,y), "numeric")
    expect_is(area.diff(x,y, rarefy = 50), "numeric")
    expect_is(area.diff(y,x), "numeric")
    expect_is(area.diff(y,x, rarefy = 50), "numeric")
})
