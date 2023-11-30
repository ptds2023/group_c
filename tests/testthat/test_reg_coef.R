test_that("regression coefficient input check",{
  expect_error(cars$speed %r% cars)
})
test_that("regression coefficient output",{
  expect_type(cars$speed %r% cars$dist, "double")
})
