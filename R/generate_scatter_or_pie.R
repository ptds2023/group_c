#' @title Generate Scatter Plot or Pie Chart
#' @name generate_scatter_or_pie
#' @description This function creates either a scatter plot or a pie chart based on user input. It is designed to be used within a Shiny application.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param expenses_data_summary A data frame summarizing expenses data. It should contain at least two columns: 'category' for the expense categories and 'percentage' for the percentage share of each category.
#' @param scatter_plot_type A character string specifying the type of plot to generate. Expected values are "Scatter Plot" or "Pie Chart".
#' @param colorblind_switch A logical value indicating whether to use a colorblind-friendly palette.
#' @return A Plotly object representing the specified type of plot (scatter plot or pie chart).
#' @import ggplot2
#' @import dplyr
#' @import plotly
#' @importFrom magrittr %>%
#' @export
#' @examples
#' # Example usage within a Shiny server function:
#' expenses_summary <- data.frame(
#'   category = c("Food", "Transport", "Utilities"),
#'   amount = c(200, 150, 100),
#'   percentage = c(40, 30, 30)
#' )
#' output$myPlot <- renderPlotly({
#'   generate_scatter_or_pie(expenses_summary, input$plotType, input$colorblindSwitch)
#' })

generate_scatter_or_pie <- function(expenses_data_summary, scatter_plot_type, colorblind_switch) {
  color_vector <- if (colorblind_switch) brewer.pal(3, "Set1") else brewer.pal(3, "Pastel1")

  if (scatter_plot_type == "Scatter Plot") {
    p <- ggplot(expenses_data_summary, aes(x = percentage, y = amount, label = category)) +
      geom_point(color = color_vector[1], size = expenses_data_summary$amount * 0.01, alpha = 0.5) +
      geom_text(size = 2) +
      labs(title = "Expenses by Category", x = "% Share of Expenses", y = "Amount") +
      theme_minimal()

    ggplotly(p)
  } else {
    plot_ly(labels = expenses_data_summary$category, values = expenses_data_summary$amount, type = 'pie',
            textinfo = 'label+percent', insidetextorientation = 'radial') %>%
      layout(title = "Expenses by Category", showlegend = FALSE) %>%
      add_trace(marker = list(colors = color_vector),
                hoverinfo = "label+percent+value",
                textposition = "outside")
  }
}
