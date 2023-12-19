#' @title Generate Comparison Scatter Plot
#' @name generate_comparison_plot
#' @description Creates an interactive scatter plot for comparing user expenses with Swiss average expenses using Plotly. The plot is designed for use within a Shiny application and features a comparison between user and Swiss average expenses across various categories. It supports a colorblind-friendly mode by altering the color palette and includes interactive hover text with detailed expense information.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska, and Konstantinos Kourlimpinis.
#' @param user_vs_swiss A data frame containing the user's and Swiss average expenses for comparison. The data frame should have columns 'category', 'user_amount', and 'swiss_amount'. It should also have 'type' and 'hover_text' for plot aesthetics and interactivity.
#' @param colorblind_switch Logical flag indicating whether to use a colorblind-friendly color palette.
#' @return A Plotly interactive scatter plot object representing the comparison of expenses.
#' @importFrom ggplot2 ggplot aes geom_point labs theme_minimal scale_color_manual scale_shape_manual
#' @importFrom plotly ggplotly layout
#' @examples
#' # Example usage within a Shiny server function:
#' user_vs_swiss <- data.frame(
#'   category = c("Food", "Transport", "Utilities"),
#'   user_amount = c(200, 150, 100),
#'   swiss_amount = c(250, 180, 120),
#'   type = c("User's Expenses", "User's Expenses", "User's Expenses"),
#'   hover_text = c("Food: 200", "Transport: 150", "Utilities: 100")
#' )
#' # Assume colorblind_switch is a boolean input from Shiny
#' output$comparisonPlot <- renderPlotly({
#'   generate_comparison_plot(user_vs_swiss, colorblind_switch)
#' })
#'
#' @export
generate_comparison_plot <- function(user_vs_swiss, colorblind_switch) {
  # Define colors for each type of expense
  color_vector <- c("User's Expenses" = "blue", "Swiss Average Expenses" = "red")

  # Create a ggplot object
  p <- ggplot(user_vs_swiss, aes(x = amount / sum(amount) * 100, y = amount, color = type, text = hover_text, shape = type)) +
    geom_point(size = 4, alpha = 0.5) +
    labs(title = "Compare to the Average Swiss Expenses", x = "% Share of Expenses", y = "Amount") +
    theme_minimal() +
    theme(legend.position = "right") +
    scale_shape_manual(values = c("User's Expenses" = 17, "Swiss Average Expenses" = 16)) + # 17 is triangle, 16 is circle
    scale_color_manual(values = color_vector)

  # Convert ggplot object to interactive plot using ggplotly
  gg <- ggplotly(p, tooltip = "text") %>%
    layout(legend = list(
      title = "",
      labels = c("User's expenses", "Swiss average expenses")
    ))

  # Here we ensure each point has the correct hover text
  for (i in seq_along(gg$data)) {
    gg$data[[i]]$hoverinfo <- 'text'
    gg$data[[i]]$hovertemplate <- paste(
      'Category: %{meta}<br>',
      'Percentage: %{x:.2f}%<br>',
      'Amount: %{y:.2f}<extra></extra>'
    )
    gg$data[[i]]$meta <- user_vs_swiss$category
  }

  return(gg)
}

