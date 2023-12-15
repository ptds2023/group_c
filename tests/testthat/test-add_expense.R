test_that("add_expense handles invalid amount correctly", {
  expect_error(
    add_expense("Groceries", -10, expenses_data$get, expenses_data$set, selected_categories$get, selected_categories$set)
  )
})

test_that("add_expense handles duplicate category correctly", {
  expect_error(
    add_expense("Groceries", 50, expenses_data$get, expenses_data$set, selected_categories$get, selected_categories$set)
  )
})
