library(testthat)
library(plotly)

test_that("createBarChart returns a Plotly object", {
  test_data <- data.frame(category = c("Income", "Expenses", "Savings"),
                          amount = c(1000, 500, 500))
  result <- createBarChart(test_data)

  expect_true(is.plotly(result))
})
