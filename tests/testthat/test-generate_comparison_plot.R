# # Test compare_to_average function
# test_that("compare_to_average compares user expenses to average correctly", {
#   user_data <- data.frame(category = c("Groceries", "Rent"), amount = c(300, 1200))
#   average_data <- c(Groceries = 350, Rent = 1000)
#   comparison <- compare_to_average(user_data, average_data, c("Groceries", "Rent"))
#   expect_equal(nrow(comparison), 2)
#   expect_true(all(comparison$Category %in% c("Groceries", "Rent")))
# })
context("Testing generate_comparison_plot function")

test_that("generate_comparison_plot creates correct plot structure", {
  user_vs_swiss <- data.frame(
    category = c("Food", "Transport"),
    user_amount = c(200, 150),
    swiss_amount = c(250, 180)
  )
  plot <- generate_comparison_plot(user_vs_swiss, FALSE)
  expect_is(plot, "plotly")
})

