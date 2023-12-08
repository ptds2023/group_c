# Install required packages if not already installed
if (!require("shiny")) install.packages("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("dplyr")) install.packages("dplyr")
if (!require("plotly")) install.packages("plotly")
if (!require("DT")) install.packages("DT")

# Load libraries
library(shiny)
library(shinydashboard)
library(dplyr)
library(plotly)
library(DT)

# Predefined list of categories
categories <- swiss_budget$grouped_expenses

# Swiss average expenses (monthly)
swiss_expenses <- swiss_budget$total_CH

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Expense Tracker"),
  dashboardSidebar(
    numericInput("income", "Enter Income:", value = NULL),
    h4("Enter Expenses:"),
    selectInput("category", "Category:", categories),
    numericInput("expense", "Expense:", value = 0),
    actionButton("add_expense", "Add Expense")
  ),
  dashboardBody(
    tabsetPanel(
      tabPanel("Summary",
               fluidRow(
                 box(plotlyOutput("bar_chart"), width = 6),
                 box(DTOutput("expense_table"), width = 6),
                 box(plotlyOutput("scatter_plot"), width = 12),
                 box("Note: You can edit the table if you made a mistake.", width = 12)
               )
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
      # Update reactiveValues with new expense
      expenses_data(rbind(expenses_data(), data.frame(category = category, amount = amount)))

      # Add selected category to the list
      selected_categories(c(selected_categories(), category))

      # Remove selected category from the dropdown list
      categories <- setdiff(categories, category)
      updateSelectInput(session, "category", choices = categories, selected = NULL)

      # Clear input fields
      updateNumericInput(session, "expense", value = 0)
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

    output$bar_chart <- renderPlotly({
      p <- ggplot(data, aes(x = category, y = amount, fill = category)) +
        geom_bar(stat = "identity") +
        scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) +  # Minimalistic color palette
        labs(title = "Income, Expenses, and Savings", x = "Category", y = "Amount") +
        theme_minimal() +
        theme(legend.position = "none")  # Hide legend

      ggplotly(p)
    })

    output$scatter_plot <- renderPlotly({
      expenses_data_summary <- expenses_data() %>%
        mutate(percentage = amount / total_expenses * 100)

      p <- ggplot(expenses_data_summary, aes(x = percentage, y = amount, label = category)) +
        geom_point(color = "#66c2a5", size = expenses_data_summary$amount * 0.01, alpha = 0.5) +
        geom_text(size = 3) +
        labs(title = "Expenses by Category", x = "% Share of Expenses", y = "Amount") +
        theme_minimal()

      ggplotly(p)
    })

    # Update selected categories for comparison
    selected_categories(expenses_data()$category)
  })

  # Update scatter plot for comparison
  observe({
    user_vs_swiss <- data.frame(
      category = selected_categories(),
      user_amount = expenses_data()$amount,
      swiss_amount = swiss_expenses[match(selected_categories(), categories)]
    )

    p <- ggplot(user_vs_swiss, aes(x = user_amount / sum(user_amount) * 100, y = user_amount)) +
      geom_point(aes(color = factor(1)), size = user_vs_swiss$user_amount * 0.01, alpha = 0.5) +
      geom_point(aes(x = swiss_amount / sum(swiss_amount) * 100, y = swiss_amount), color = "#fc8d62", size = user_vs_swiss$user_amount * 0.01, alpha = 0.5) +
      geom_text(aes(label = category), vjust = -0.5, size = 3) +
      labs(title = "Compare to the Average Swiss Expenses", x = "% Share of Expenses", y = "Amount") +
      theme_minimal() +
      scale_color_manual(values = c("#66c2a5", "#fc8d62")) +  # Different color for user and Swiss expenses
      theme(legend.position = "none")  # Hide legend

    output$compare_scatter_plot <- renderPlotly({
      ggplotly(p)
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)


