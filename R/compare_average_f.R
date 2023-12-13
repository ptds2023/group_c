#' @title Compare User Expenses to Swiss Average
#' @name compare_to_average
#' @description This function compares user's expenses in various categories to the Swiss average expenses. It produces a ggplot object that visualizes this comparison using point plots.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param user_data A data frame containing the user's expenses data with columns 'category' and 'amount'.
#' @param swiss_data A vector containing the Swiss average expenses for each category.
#' @param categories A vector of categories to compare.
#'
#' @return A ggplot object representing the comparison between user expenses and Swiss average expenses across different categories.
#'
#' @import ggplot2
#' @examples
#' user_data <- data.frame(category = c("Groceries", "Rent", "Utilities"),
#'                         amount = c(300, 1200, 150))
#' swiss_data <- c(350, 1000, 200)
#' categories <- c("Groceries", "Rent", "Utilities", "Entertainment", "Transport")
#'
#' plot <- compare_to_average(user_data, swiss_data, categories)
#' print(plot)
#'
#' @export
compare_to_average <- function(user_data, average_data, selected_categories) {
  # Check if user_data is empty or if there are no selected categories
  if (nrow(user_data) == 0 || length(selected_categories) == 0) {
    return(data.frame())  # Return an empty data frame or a suitable default value
  }

  # Ensure that user_data only contains the selected categories
  user_data <- user_data[user_data$category %in% selected_categories, ]

  # Create a new data frame for comparison
  comparison_data <- data.frame(
    Category = selected_categories,
    UserExpenses = numeric(length(selected_categories)),
    AverageExpenses = average_data[selected_categories]
  )

  # Fill in the UserExpenses column with user data
  for (cat in selected_categories) {
    if (cat %in% user_data$category) {
      comparison_data[comparison_data$Category == cat, "UserExpenses"] <- user_data[user_data$category == cat, "amount"]
    }
  }

  # Return the comparison data
  return(comparison_data)
}
