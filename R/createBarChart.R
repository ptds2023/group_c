#' @title Create a Bar Chart with Plotly
#' @name createBarChart
#' @description This function creates an interactive bar chart using ggplot2 and Plotly. It is designed to visualize data in categories with their corresponding amounts. The chart uses a minimalistic color palette and hides the legend for a cleaner appearance.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param data A data frame containing the variables `category` and `amount`.
#' @param title Title of the plot, default is "Income, Expenses, and Savings".
#' @param xLabel Label for the x-axis, default is "Category".
#' @param yLabel Label for the y-axis, default is "Amount".
#' @return An interactive Plotly object.
#' @import ggplot2
#' @importFrom plotly ggplotly
#' @examples
#' test_data <- data.frame(category = c("Income", "Expenses", "Savings"),
#'                        amount = c(1000, 500, 500))
#' createBarChart(test_data)
#' @export
# createBarChart <- function(data, title = "Income, Expenses, and Savings", xLabel = "Category", yLabel = "Amount") {
#   require(ggplot2)
#   require(plotly)
#
#   p <- ggplot(data, aes(x = category, y = amount, fill = category)) +
#     geom_bar(stat = "identity") +
#     scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) +
#     labs(title = title, x = xLabel, y = yLabel) +
#     ggplot2::theme_minimal() +
#     theme(legend.position = "none")
#
#   ggplotly(p)
# }

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
