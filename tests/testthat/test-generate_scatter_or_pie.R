library(RColorBrewer)

test_that("generate_scatter_or_pie creates correct scatter plot", {
  expenses_summary <- data.frame(
    category = c("Food", "Transport"),
    amount = c(200, 150),
    percentage = c(40, 30)
  )
  expect_error(
    generate_scatter_or_pie(expenses_summary, "Scatter Plot", FALSE),
    NA  # Expecting no error
  )
})

test_that("generate_scatter_or_pie creates correct pie chart", {
  expenses_summary <- data.frame(
    category = c("Food", "Transport"),
    amount = c(200, 150),
    percentage = c(40, 30)
  )
  expect_error(
    generate_scatter_or_pie(expenses_summary, "Pie Chart", FALSE),
    NA  # Expecting no error
  )
})
