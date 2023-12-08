#' Compare User Expenses to Swiss Average
#'
#' This function compares user's expenses in various categories to the Swiss average expenses. It produces a ggplot object that visualizes this comparison using point plots.
#'
#' @param user_data A data frame containing the user's expenses data with columns 'category' and 'amount'.
#' @param swiss_data A vector containing the Swiss average expenses for each category.
#' @param categories A vector of categories to compare.
#'
#' @return A ggplot object representing the comparison between user expenses and Swiss average expenses across different categories.
#'
#' @importFrom ggplot2 ggplot aes geom_point labs theme_minimal scale_color_manual theme
#'
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
compare_to_average <- function(user_data, swiss_data, categories) {
  # Create a data frame for categories
  category_df <- data.frame(category = categories)

  # Join user data with category data
  user_vs_swiss <- merge(category_df, user_data, by = "category", all.x = TRUE)

  # Replace NA in user_amount with 0
  user_vs_swiss$user_amount[is.na(user_vs_swiss$user_amount)] <- 0

  # Add Swiss data to the data frame
  user_vs_swiss$swiss_amount <- swiss_data

  # Create the plot
  p <- ggplot(user_vs_swiss, aes(x = user_amount, y = category)) +
    geom_point(aes(color = "User"), size = 4) +
    geom_point(aes(x = swiss_amount, color = "Swiss Average"), size = 4) +
    labs(title = "User vs Swiss Average Expenses", x = "Amount", y = "Category") +
    theme_minimal() +
    scale_color_manual(values = c("User" = "#66c2a5", "Swiss Average" = "#fc8d62")) +
    theme(legend.position = "bottom")

  return(p)
}

