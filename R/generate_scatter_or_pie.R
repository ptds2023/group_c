#' @title Generate Scatter Plot or Pie Chart
#' @name generate_scatter_or_pie
#' @description This function dynamically creates either a scatter plot or a pie chart based on the user's choice in a Shiny application. The function adapts the plot type depending on the input provided: 'Scatter Plot' or 'Pie Chart'. The plots are designed to provide insights into the distribution of expenses across different categories, represented both in amounts and percentages.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska, and Konstantinos Kourlimpinis.
#' @param expenses_data_summary A data frame summarizing expenses data. It should contain at least the columns 'category', 'amount', and 'percentage', where 'percentage' represents the percentage share of each category in the total expenses.
#' @param scatter_plot_type A character string specifying the type of plot to generate. Expected values are "Scatter Plot" or "Pie Chart".
#' @param colorblind_switch A logical value indicating whether to use a colorblind-friendly color palette. The palette changes based on the value of this parameter.
#' @return A Plotly object representing the specified type of plot (either a scatter plot or a pie chart). The function returns NULL if there is no data to plot.
#' @import ggplot2
#' @import dplyr
#' @import plotly
#' @importFrom magrittr %>%
#' @importFrom RColorBrewer brewer.pal
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
#' @export

generate_scatter_or_pie <- function(expenses_data_summary, scatter_plot_type, colorblind_switch) {
  color_vector <- if (colorblind_switch) brewer.pal(3, "Set1") else brewer.pal(3, "Pastel1")

  if (nrow(expenses_data_summary) > 0) {
    if (scatter_plot_type == "Scatter Plot") {
      expenses_data_summary$hover_text <- paste(
        "Category: ", expenses_data_summary$category,
        "<br>Percentage: ", round(expenses_data_summary$percentage, 2), "%",
        "<br>Amount: ", round(expenses_data_summary$amount, 2),
        sep = ""
      )

      p <- ggplot(expenses_data_summary, aes(x = percentage, y = amount, text = hover_text)) +
        geom_point(color = color_vector[1], size = 4, alpha = 0.5) +
        geom_text(aes(label = category), size = 2, hjust = 1.1, vjust = 1.1) +
        labs(title = "Expenses by Category", x = "% Share of Expenses", y = "Amount") +
        theme_minimal()

      gg <- ggplotly(p, tooltip = "text")
      gg$data[[1]]$hoverinfo <- 'text'
      gg$data[[1]]$hovertemplate <- '%{text}<extra></extra>'

      return(gg)
    } else {
      expenses_data_summary$hover_text <- paste(
        "Category: ", expenses_data_summary$category,
        "<br>Percentage: ", round(expenses_data_summary$percentage, 2), "%",
        "<br>Amount: ", round(expenses_data_summary$amount, 2),
        sep = ""
      )

      plot_ly(expenses_data_summary, labels = ~category, values = ~amount, type = 'pie',
              textinfo = 'label+percent', insidetextorientation = 'radial',
              hoverinfo = 'label+percent+value', marker = list(colors = color_vector)) %>%
        layout(title = "Expenses by Category", showlegend = FALSE) %>%
        add_trace(text = ~hover_text, hoverinfo = "text", hovertemplate = ~hover_text)
    }
  } else {
    return(NULL) # Return NULL if there is no data to plot
  }
}
