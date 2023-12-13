# Test calculate_financials function
test_that("calculate_financials calculates totals and savings correctly", {
  expenses <- data.frame(category = c("Food", "Rent"), amount = c(100, 500))
  financials <- calculate_financials(expenses, 2000)
  expect_equal(financials$total_expenses, 600)
  expect_equal(financials$savings, 1400)
})
