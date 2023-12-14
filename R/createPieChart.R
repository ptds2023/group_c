#' @title Create a Pie Chart with Plotly
#' @name createPieChart
#' @description This function takes a data frame with categories and their corresponding values and generates a pie chart. It optionally supports colorblind-friendly color palettes.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param data A data frame with at least two columns: category and value.
#' @param colorblind_switch A boolean flag to use colorblind-friendly palette. Default is FALSE.
#' @return A ggplot object representing the pie chart.
#' @import scales
#' @export
#' @examples
#' data <- data.frame(
#'   category = c("Category 1", "Category 2", "Category 3"),
#'   value = c(10, 20, 30)
#' )
#' create_pie_chart(data, TRUE)
createPieChart <- function(data, colorblind_switch = FALSE) {
  if (!"ggplot2" %in% installed.packages()) {
    stop("ggplot2 is not installed. Please install it to use this function.")
  }

  library(ggplot2)

  # Choosing a color palette
  if (colorblind_switch) {
    colors <- scales::brewer_pal(palette = "Set2")(length(unique(data$category)))
  } else {
    colors <- scales::brewer_pal(palette = "Set1")(length(unique(data$category)))
  }

  ggplot(data, aes(x = "", y = value, fill = category)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y", start = 0) +
    scale_fill_manual(values = colors) +
    theme_void() +
    labs(fill = "Category")
}
