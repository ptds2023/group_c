# Test compare_to_average function
test_that("compare_to_average compares user expenses to average correctly", {
  user_data <- data.frame(category = c("Groceries", "Rent"), amount = c(300, 1200))
  average_data <- c(Groceries = 350, Rent = 1000)
  comparison <- compare_to_average(user_data, average_data, c("Groceries", "Rent"))
  expect_equal(nrow(comparison), 2)
  expect_true(all(comparison$Category %in% c("Groceries", "Rent")))
})
