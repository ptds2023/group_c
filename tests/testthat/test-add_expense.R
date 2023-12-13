# Test add_expense function
test_that("add_expense adds a new expense correctly", {
  expenses <- data.frame(category = character(), amount = numeric())
  new_expenses <- add_expense(expenses, "Food", 100)
  expect_equal(nrow(new_expenses), 1)
  expect_equal(new_expenses$category, "Food")
  expect_equal(new_expenses$amount, 100)
})
