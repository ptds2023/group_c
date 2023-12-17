#' @title Demonstration of shiny app
#' @name runDemo
#' @description This function is used to demonstrate how the shiny app works.
#' @details The `runDemo` function uses `shiny::addResourcePath` to set the resource path to the package's internal `styles` directory, ensuring that Shiny can access the CSS file upon deployment. It then includes a link to the CSS file in the app's HTML header using `tags$link`. This setup allows for custom styling of the Shiny dashboard elements.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @return Open the app of Budget Overview Shiny Dashboard
#' @import shiny
#' @examples \dontrun{runDemo()}
#' @export

runDemo <- function() {
  # Load required libraries
  requireNamespace("shiny")
  requireNamespace("plotly")
  requireNamespace("DT")
  requireNamespace("ggplot2")
  requireNamespace("dplyr")

  # Load data set
  swiss_budget <- read.csv(system.file("extdata", "swiss-budget.csv", package = "budgetoverview"))
  # Predefined list of categories
  categories <- swiss_budget$grouped_expenses

  # Swiss average expenses (monthly)
  swiss_expenses <- swiss_budget$total_CH
  #  Set resource path for CSS
  shiny::addResourcePath("styles", system.file("styles", package = "budgetoverview"))

  # Define UI
  ui <- shiny::dashboardPage(
    dashboardHeader(title = "Expense Tracker"),
    dashboardSidebar(
      # Custom CSS inclusion
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "styles/styles.css")
      ),
      numericInput("income", "Enter Income:", value = NULL),
      h4("Enter Expenses:"),
      selectInput("category", "Category:", categories),
      numericInput("expense", "Expense:", value = 0),
      actionButton("add_expense", "Add Expense"),
      radioButtons("scatter_plot_type", "Select Plot Type For Expenses by Category:", choices = c("Scatter Plot", "Pie Chart"), selected = "Scatter Plot"),
      checkboxInput("colorblind_switch", "Colorblind-Friendly", value = FALSE)  # Corrected to checkboxInput
    ),
    dashboardBody(
      tabsetPanel(
        tabPanel("Summary",
                 fluidRow(
                   box(plotlyOutput("bar_chart"), width = 6),
                   box(DTOutput("expense_table"), width = 6),
                   box(plotlyOutput("scatter_plot"), width = 12))
        ),
        tabPanel("Compare to the average",
                 box(plotlyOutput("compare_scatter_plot"), width = 12)
        )
      )
    )
  )

  # Define server
  server <- function(input, output, session) {
    # Initialize reactive values
    expenses_data <- reactiveVal(data.frame(category = character(), amount = numeric()))
    selected_categories <- reactiveVal(character())

    # Add expense when button is clicked
    observeEvent(input$add_expense, {
      category <- input$category
      amount <- input$expense

      # Check if category and amount are provided
      if (!is.null(category) && !is.na(amount)) {
        # Check if the category has already been selected
        if (!(category %in% selected_categories())) {
          # Update reactiveValues with new expense
          expenses_data(rbind(expenses_data(), data.frame(category = category, amount = amount)))

          # Add selected category to the list
          selected_categories(c(selected_categories(), category))

          # Remove selected category from the dropdown list
          categories <- setdiff(categories, category)
          updateSelectInput(session, "category", choices = categories, selected = NULL)

          # Clear input fields
          updateNumericInput(session, "expense", value = 0)
        } else {
          # Category has already been selected, show a message or take appropriate action
          showModal(modalDialog(
            title = "Category Already Selected",
            "You can only choose each category once. Please select a different category.",
            easyClose = TRUE
          ))
        }
      }
    })

    # Generate editable table for editing
    output$expense_table <- renderDT({
      datatable(expenses_data(), editable = TRUE, options = list(dom = 't'))
    })

    # Update graphs when the table is edited
    observe({
      total_expenses <- sum(expenses_data()$amount)
      savings <- ifelse(is.null(input$income), 0, input$income) - total_expenses

      data <- data.frame(
        category = c("Income", "Expenses", "Savings"),
        amount = c(ifelse(is.null(input$income), 0, input$income), ifelse(total_expenses == 0, 0, total_expenses), savings)
      )

      # Bar Chart
      output$bar_chart <- renderPlotly({
        p <- ggplot(data, aes(x = category, y = amount, fill = category)) +
          geom_bar(stat = "identity") +
          scale_fill_manual(values = if (input$colorblind_switch) c("#1b9e77", "#d95f02", "#7570b3") else c("#66c2a5", "#fc8d62", "#8da0cb")) +
          labs(title = "Income, Expenses, and Savings", x = "Category", y = "Amount") +
          theme_minimal() +
          theme(legend.position = "none")  # Hide legend

        ggplotly(p)
      })

      expenses_data_summary <- expenses_data() %>%
        mutate(percentage = amount / total_expenses * 100)

      color_vector <- if (input$colorblind_switch) brewer.pal(3, "Set1") else brewer.pal(3, "Pastel1")

      if (input$scatter_plot_type == "Scatter Plot") {
        # Scatter Plot
        p <- ggplot(expenses_data_summary, aes(x = percentage, y = amount, label = category)) +
          geom_point(color = color_vector[1], size = expenses_data_summary$amount * 0.01, alpha = 0.5) +
          geom_text(size = 2) +
          labs(title = "Expenses by Category", x = "% Share of Expenses", y = "Amount") +
          theme_minimal()

        output$scatter_plot <- renderPlotly({
          ggplotly(p)
        })
      } else if (input$scatter_plot_type == "Pie Chart") {
        # Pie Chart
        p <- plot_ly(labels = expenses_data_summary$category, values = expenses_data_summary$amount, type = 'pie',
                     textinfo = 'label+percent', insidetextorientation = 'radial') %>%
          layout(title = "Expenses by Category", showlegend = FALSE)  %>%
          add_trace(marker = list(colors = color_vector),
                    hoverinfo = "label+percent+value",
                    textposition = "outside")

        output$scatter_plot <- renderPlotly({
          p
        })
      }
    })

    # Update selected categories for comparison
    observe({
      selected_categories(expenses_data()$category)
    })

    # Update scatter plot for comparison
    observe({
      user_vs_swiss <- data.frame(
        category = selected_categories(),
        user_amount = expenses_data()$amount,
        swiss_amount = swiss_expenses[match(selected_categories(), categories)]
      )

      color_vector_2 <- if (input$colorblind_switch) brewer.pal(12, "Set1") else brewer.pal(12, "Pastel1")

      p <- ggplot(user_vs_swiss) +
        geom_point(aes(x = amount / sum(amount) * 100, y = amount, shape = type, color = category), size = user_vs_swiss$amount * 0.01, alpha = 0.5) +
        labs(title = "Compare to the Average Swiss Expenses", x = "% Share of Expenses", y = "Amount") +
        theme_minimal() +
        theme(legend.position = "right") +
        scale_color_manual(values = color_vector, breaks = unique(user_vs_swiss$category), name = "Category")

      output$compare_scatter_plot <- renderPlotly({
        ggplotly(p)
      })
    })
  }

  # Run the application
  shinyApp(ui = ui, server = server)
}
