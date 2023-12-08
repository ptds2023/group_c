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
library(budgetoverview)

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
    tryCatch({
      # Use add_expense function to add new expense
      expenses_data(add_expense(expenses_data(), input$category, input$expense))

      # Add selected category to the list
      selected_categories(c(selected_categories(), input$category))

      # Remove selected category from the dropdown list
      categories <- setdiff(categories, input$category)
      updateSelectInput(session, "category", choices = categories, selected = NULL)

      # Clear input fields
      updateNumericInput(session, "expense", value = 0)
    }, error = function(e) {
      # Handle error
      showNotification("Error: Invalid input!", type = "error")
    })
  })

  # Generate editable table for editing
  output$expense_table <- renderDT({
    datatable(expenses_data(), editable = TRUE, options = list(dom = 't'))
  })

  # Update bar chart when data changes
  output$bar_chart <- renderPlotly({
    data <- calculate_financials(expenses_data(), input$income)
    p <- create_bar_chart(data)
    ggplotly(p)
  })

  # Update scatter plot when data changes
  output$scatter_plot <- renderPlotly({

      create_scatter_plot(expenses_data())
    })


  # Update scatter plot for comparison
  observe({
    user_vs_swiss <- compare_to_average(expenses_data(), swiss_expenses, selected_categories())
    output$compare_scatter_plot <- renderPlotly({
      ggplotly(user_vs_swiss)
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)

