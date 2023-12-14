#' @title Create a Bar Chart with Plotly
#' @name generate_bar_chart
#' @description This function creates a bar chart for visualizing data such as income, expenses, and savings. It supports a colorblind-friendly mode by changing the color palette. The function is primarily designed for use in a Shiny application to display financial data.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param data A data frame containing the data to be plotted. Expected to contain at least two columns: 'category' for the data categories and 'amount' for the values.
#' @param colorblind_switch Logical flag indicating whether to use a colorblind-friendly color palette.
#' @return A Plotly ggplot object representing the bar chart.
#' @importFrom ggplot2 ggplot aes geom_bar scale_fill_manual labs theme_minimal
#' @importFrom plotly ggplotly
#' @examples
#' # Example usage:
#' data <- data.frame(
#'   category = c("Income", "Expenses", "Savings"),
#'   amount = c(1000, 750, 250)
#' )
#' # Example for a colorblind-friendly chart
#' plot <- generate_bar_chart(data, TRUE)
#' # In a Shiny app, use renderPlotly() to display this plot
#'
#' @export
generate_bar_chart <- function(data, colorblind_switch) {
  color_palette <- if (colorblind_switch) c("#1b9e77", "#d95f02", "#7570b3") else c("#66c2a5", "#fc8d62", "#8da0cb")
  p <- ggplot(data, aes(x = category, y = amount, fill = category)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = color_palette) +
    labs(title = "Income, Expenses, and Savings", x = "Category", y = "Amount") +
    theme_minimal() +
    theme(legend.position = "none")

  ggplotly(p)
}
