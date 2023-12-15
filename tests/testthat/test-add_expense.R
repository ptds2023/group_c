# # Test add_expense function
# test_that("add_expense adds a new expense correctly", {
#   expenses <- data.frame(category = character(), amount = numeric())
#   new_expenses <- add_expense(expenses, "Food", 100)
#   expect_equal(nrow(new_expenses), 1)
#   expect_equal(new_expenses$category, "Food")
#   expect_equal(new_expenses$amount, 100)
# })



# #Testing add_expense function
#
# test_that("add_expense handles valid input correctly", {
#   expenses_data <- reactiveVal(data.frame(category = character(), amount = numeric()))
#   selected_categories <- reactiveVal(character())
#
#   result <- add_expense("Groceries", 100, expenses_data, selected_categories, NULL)
#   expect_true(result)
#   expect_equal(expenses_data(), data.frame(category = "Groceries", amount = 100))
# })
#
# test_that("add_expense handles invalid amount correctly", {
#   expenses_data <- reactiveVal(data.frame(category = character(), amount = numeric()))
#   selected_categories <- reactiveVal(character())
#
#   result <- add_expense("Groceries", -10, expenses_data, selected_categories, NULL)
#   expect_false(result)
# })
#
# test_that("add_expense handles duplicate category correctly", {
#   expenses_data <- reactiveVal(data.frame(category = "Groceries", amount = 100))
#   selected_categories <- reactiveVal("Groceries")
#
#   result <- add_expense("Groceries", 50, expenses_data, selected_categories, NULL)
#   expect_false(result)
# })



# Define the mock reactive value function
mockReactiveVal <- function(initialValue) {
  value <- initialValue
  list(
    get = function() value,
    set = function(newValue) value <<- newValue
  )
}

test_that("add_expense handles valid input correctly", {
  expenses_data <- mockReactiveVal(data.frame(category = character(), amount = numeric()))
  selected_categories <- mockReactiveVal(character())

  result <- add_expense("Groceries", 100, expenses_data$get, expenses_data$set, selected_categories$get, selected_categories$set)
  expect_true(result)
  expect_equal(expenses_data$get(), data.frame(category = "Groceries", amount = 100))
})

test_that("add_expense handles invalid amount correctly", {
  expenses_data <- mockReactiveVal(data.frame(category = character(), amount = numeric()))
  selected_categories <- mockReactiveVal(character())

  result <- add_expense("Groceries", -10, expenses_data$get, expenses_data$set, selected_categories$get, selected_categories$set)
  expect_false(result)
})

test_that("add_expense handles duplicate category correctly", {
  expenses_data <- mockReactiveVal(data.frame(category = "Groceries", amount = 100))
  selected_categories <- mockReactiveVal("Groceries")

  result <- add_expense("Groceries", 50, expenses_data$get, expenses_data$set, selected_categories$get, selected_categories$set)
  expect_false(result)
})
