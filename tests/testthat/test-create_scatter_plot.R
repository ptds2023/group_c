# Test create_scatter_plot function
test_that("create_scatter_plot creates a ggplot object", {
  expenses <- data.frame(category = c("Food", "Rent"), amount = c(100, 500))
  scatter_plot <- create_scatter_plot(expenses)
  expect_true("ggplot" %in% class(scatter_plot))
})
