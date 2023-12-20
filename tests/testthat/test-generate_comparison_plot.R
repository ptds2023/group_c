library(RColorBrewer)

#Test 1
test_that("generate_comparison_plot returns a Plotly object", {
  # Original data
  original_data <- data.frame(
    category = c("Food", "Transport", "Utilities"),
    user_amount = c(200, 150, 100),
    swiss_amount = c(250, 180, 120)
  )

  # Create hover text
  hover_text <- paste("Category:", original_data$category,
                      "<br>User Amount:", original_data$user_amount,
                      "<br>Swiss Amount:", original_data$swiss_amount)

  # Transform data to match the expected format
  user_data <- original_data %>%
    mutate(type = "User's Expenses", amount = user_amount, hover_text = hover_text)

  swiss_data <- original_data %>%
    mutate(type = "Swiss Average Expenses", amount = swiss_amount, hover_text = hover_text)

  user_vs_swiss <- rbind(user_data, swiss_data)

  # Testing the function
  result <- generate_comparison_plot(user_vs_swiss, FALSE)
  expect_true(inherits(result, "plotly"))
})


#Test 2
test_that("generate_comparison_plot handles empty data appropriately", {
  empty_data <- data.frame(category = character(), amount = numeric(), type = character(), hover_text = character())

  result <- generate_comparison_plot(empty_data, FALSE)

  # Checking if it returns an empty plot or an error
  expect_true(is.null(result) || inherits(result, "plotly"))
})


