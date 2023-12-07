#' Compare User Expenses to Swiss Average
#'
#' This function creates a scatter plot comparing the user's expenses
#' in different categories to the Swiss average expenses.
#'
#' @param user_data User's expenses data frame.
#' @param swiss_data Numeric vector of Swiss average expenses.
#' @param categories Character vector of expense categories.
#' @return A ggplot object representing the comparison scatter plot.
#' @export
#' @examples
#' user_data <- data.frame(category = c("Food", "Rent"), amount = c(100, 500))
#' swiss_data <- c(120, 700) # Example Swiss data
#' categories <- c("Food", "Rent")
#' comparison_plot <- compare_to_average(user_data, swiss_data, categories)
compare_to_average <- function(user_data, swiss_data, categories) {
  user_vs_swiss <- data.frame(
    category = categories,
    user_amount = ifelse(is.na(match(categories, user_data$category)), 0, user_data$amount),
    swiss_amount = swiss_data
  )

  p <- ggplot(user_vs_swiss, aes(x = user_amount, y = category)) +
    geom_point(aes(color = "User"), size = 4) +
    geom_point(aes(x = swiss_amount, color = "Swiss Average"), size = 4) +
    labs(title = "User vs Swiss Average Expenses", x = "Amount", y = "Category") +
    theme_minimal() +
    scale_color_manual(values = c("User" = "#66c2a5", "Swiss Average" = "#fc8d62")) +
    theme(legend.position = "bottom")

  return(p)
}
