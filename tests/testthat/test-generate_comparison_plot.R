library(RColorBrewer)


test_that("generate_comparison_plot creates correct plot", {
  user_vs_swiss <- data.frame(category = c("Food", "Transport"), user_amount = c(200, 150), swiss_amount = c(250, 180))
  plot <- generate_comparison_plot(user_vs_swiss, FALSE)
  expect_s3_class(plot, "plotly")
})

test_that("generate_scatter_or_pie creates correct plots", {
  expenses_summary <- data.frame(category = c("Food", "Transport"), amount = c(200, 150), percentage = c(40, 30))
  scatter_plot <- generate_scatter_or_pie(expenses_summary, "Scatter Plot", FALSE)
  pie_chart <- generate_scatter_or_pie(expenses_summary, "Pie Chart", FALSE)

  expect_s3_class(scatter_plot, "plotly")
  expect_s3_class(pie_chart, "plotly")
})
