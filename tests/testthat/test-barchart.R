# library(testthat) We don't need to load these two every time, since we are loading them in the master testthat file.
# library(plotly)
#
# test_that("createBarChart returns a Plotly object", {
#   test_data <- data.frame(category = c("Income", "Expenses", "Savings"),
#                           amount = c(1000, 500, 500))
#   result <- createBarChart(test_data)
#
#   expect_true(is.plotly(result))
# })

# Test createBarChart function
test_that("createBarChart creates a Plotly object", {
  test_data <- data.frame(category = c("Income", "Expenses", "Savings"),
                          amount = c(1000, 500, 500))
  bar_chart <- createBarChart(test_data)
  expect_true("plotly" %in% class(bar_chart))
})
