#' Create a Bar Chart of Financial Data
#'
#' Generates a bar chart visualizing income, expenses, and savings based on user input data.
#'
#' @param financial_data A data frame with financial categories and amounts.
#' @return A ggplot object representing the bar chart.
#' @export
#' @examples
#' financial_data <- data.frame(category = c("Income", "Expenses", "Savings"),
#'                             amount = c(2000, 1500, 500))
#' bar_chart <- create_bar_chart(financial_data)
create_bar_chart <- function(financial_data) {
  p <- ggplot(financial_data, aes(x = category, y = amount, fill = category)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) +
    labs(title = "Income, Expenses, and Savings", x = "Category", y = "Amount") +
    theme_minimal() +
    theme(legend.position = "none")

  return(p)
}
