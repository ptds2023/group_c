library(RColorBrewer)


test_that("generate_bar_chart creates correct plot", {
  data <- data.frame(category = c("Income", "Expenses", "Savings"), amount = c(1000, 750, 250))
  plot <- generate_bar_chart(data, FALSE)
  expect_s3_class(plot, "plotly")
})
