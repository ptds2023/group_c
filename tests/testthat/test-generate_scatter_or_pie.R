# # Test create_scatter_plot function
# test_that("create_scatter_plot creates a ggplot object", {
#   expenses <- data.frame(category = c("Food", "Rent"), amount = c(100, 500))
#   scatter_plot <- create_scatter_plot(expenses)
#   expect_true("ggplot" %in% class(scatter_plot))
# })
context("Testing generate_scatter_or_pie function")

test_that("generate_scatter_or_pie creates scatter plot correctly", {
  expenses_summary <- data.frame(
    category = c("Food", "Transport"),
    amount = c(200, 150),
    percentage = c(40, 30)
  )
  plot <- generate_scatter_or_pie(expenses_summary, "Scatter Plot", FALSE)
  expect_is(plot, "plotly")
  # ... additional checks on scatter plot structure
})

test_that("generate_scatter_or_pie creates pie chart correctly", {
  expenses_summary <- data.frame(
    category = c("Food", "Transport"),
    amount = c(200, 150),
    percentage = c(40, 30)
  )
  plot <- generate_scatter_or_pie(expenses_summary, "Pie Chart", FALSE)
  expect_is(plot, "plotly")
  # ... additional checks on pie chart structure
})
