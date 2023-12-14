#' @title Generate Comparison Scatter Plot
#' @name generate_comparison_plot
#' @description Creates a scatter plot for comparing user expenses with Swiss average expenses. This function is designed for use within a Shiny application, particularly for financial comparison visualizations. It supports a colorblind-friendly mode by altering the color palette.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param user_vs_swiss A data frame containing the user's expenses and Swiss average expenses for comparison. The data frame should have columns 'category', 'user_amount', and 'swiss_amount'.
#' @param colorblind_switch Logical flag indicating whether to use a colorblind-friendly color palette.
#' @return A Plotly ggplot object representing the comparison scatter plot.
#' @importFrom ggplot2 ggplot aes geom_point labs theme_minimal scale_color_manual
#' @importFrom plotly ggplotly
#' @examples
#' # Example usage within a Shiny server function:
#' user_vs_swiss <- data.frame(
#'   category = c("Food", "Transport", "Utilities"),
#'   user_amount = c(200, 150, 100),
#'   swiss_amount = c(250, 180, 120)
#' )
#' # Assume colorblind_switch is a boolean input from Shiny
#' output$comparisonPlot <- renderPlotly({
#'   generate_comparison_plot(user_vs_swiss, colorblind_switch)
#' })
#'
#' @export
generate_comparison_plot <- function(user_vs_swiss, colorblind_switch) {
  color_vector <- if (colorblind_switch) brewer.pal(12, "Set1") else brewer.pal(12, "Pastel1")

  p <- ggplot(user_vs_swiss) +
    geom_point(aes(x = user_amount / sum(user_amount) * 100, y = user_amount, shape = "User", color = category), size = user_vs_swiss$user_amount * 0.01, alpha = 0.5) +
    geom_point(aes(x = swiss_amount / sum(swiss_amount) * 100, y = swiss_amount, shape = "Swiss", color = category), size = user_vs_swiss$user_amount * 0.01, alpha = 0.5) +
    labs(title = "Compare to the Average Swiss Expenses", x = "% Share of Expenses", y = "Amount") +
    theme_minimal() +
    theme(legend.position = "right") +
    scale_color_manual(values = color_vector, breaks = unique(user_vs_swiss$category), name = "Category")

  ggplotly(p)
}
