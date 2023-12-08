#' Create a Scatter Plot of Expenses Data
#'
#' Generates a scatter plot showing the distribution and percentage share of
#' each expense category in the total expenses.
#'
#' @param expenses_data A data frame containing expenses data.
#' @return A ggplot object representing the scatter plot.
#' @export
#' @examples
#' expenses <- data.frame(category = c("Food", "Rent"), amount = c(100, 500))
#' scatter_plot <- create_scatter_plot(expenses)
create_scatter_plot <- function(expenses_data) {
  total_expenses <- sum(expenses_data$amount)
  expenses_data_summary <- expenses_data %>%
    mutate(percentage = amount / total_expenses * 100)

  p <- ggplot(expenses_data_summary, aes(x = percentage, y = amount, label = category)) +
    geom_point(color = "#66c2a5", size = expenses_data_summary$amount * 0.01, alpha = 0.5) +
    geom_text(size = 3) +
    labs(title = "Expenses by Category", x = "% Share of Expenses", y = "Amount") +
    theme_minimal()

  return(p)
}
