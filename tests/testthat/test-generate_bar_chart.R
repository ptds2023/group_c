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

# # Test createBarChart function
# test_that("createBarChart creates a Plotly object", {
#   test_data <- data.frame(category = c("Income", "Expenses", "Savings"),
#                           amount = c(1000, 500, 500))
#   bar_chart <- createBarChart(test_data)
#   expect_true("plotly" %in% class(bar_chart))
# })
test_that("generate_bar_chart creates correct plot structure", {
  data <- data.frame(
    category = c("Income", "Expenses", "Savings"),
    amount = c(1000, 750, 250)
  )
  plot <- generate_bar_chart(data, FALSE)
  expect_is(plot, "plotly")
  expect_equal(length(plot$x$data), 1) # Expecting one bar for each category
})

test_that("generate_bar_chart handles colorblind mode", {
  data <- data.frame(
    category = c("Income", "Expenses", "Savings"),
    amount = c(1000, 750, 250)
  )
  plot1 <- generate_bar_chart(data, TRUE)
  plot2 <- generate_bar_chart(data, FALSE)

  expect_not_equal(plot1$x$data[[1]]$marker$color, plot2$x$data[[1]]$marker$color)
})
