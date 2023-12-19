if (!require("shiny")) install.packages("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("dplyr")) install.packages("dplyr")
if (!require("plotly")) install.packages("plotly")
if (!require("DT")) install.packages("DT")
if (!require("RColorBrewer")) install.packages("RColorBrewer")

library(budgetoverview)
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(RColorBrewer)
library(tidyr)
# Load data set
swiss_budget <- read.csv(system.file("extdata", "swiss_budget.csv", package = "budgetoverview"))
# Predefined list of categories
categories <- swiss_budget$Grouped_Expenses

# Swiss average expenses (monthly)
swiss_expenses <- swiss_budget$Total_CH
#  Set resource path for CSS
shiny::addResourcePath("styles", system.file("styles", package = "budgetoverview"))
# Define UI
ui <- shinydashboard::dashboardPage(
  dashboardHeader(title = "Expense Tracker"),
  dashboardSidebar(
    # Custom CSS inclusion
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles/styles.css")
    ),
    numericInput("income", "Enter Income:", value = NULL),
    h4(class = "white-label", "Enter Expenses:"),
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
                 box(
                   tags$div(style = "text-align: right; margin-top: 5px; margin-right: 10px; color: red; font-style: italic;",
                            "Double Click on the amount to edit it"),
                   DTOutput("expense_table"),
                   width = 6
                 ),
                 box(plotlyOutput("scatter_plot"), width = 12)
               )
      ),
      tabPanel("Compare to the average",
               box(plotlyOutput("compare_scatter_plot"), width = 12)
      )
    )
  )
)
server <- function(input, output, session) {
  # Initialize reactive values
  expenses_data <- reactiveVal(data.frame(category = character(), amount = numeric()))
  selected_categories <- reactiveVal(character())

  # Add expense when button is clicked
  observeEvent(input$add_expense, {
    expense_value <- as.numeric(input$expense)  # Convert to numeric

    # Check if the expense is zero
    if (expense_value == 0) {
      showNotification("Expense value cannot be zero.", type = "error")
      return()  # Stop further execution
    }

    # Convert negative values to positive
    if (expense_value < 0) {
      expense_value <- abs(expense_value)
      showNotification("Negative expense value converted to positive.", type = "warning")
    }

    if (input$category %in% expenses_data()$category) {
      showModal(modalDialog(
        title = "Category Already Selected",
        "You can only choose each category once. Please select a different category. If you want to modify an existing category, double-click on the amount inside the table.",
        easyClose = TRUE
      ))
    } else {
      new_data <- rbind(expenses_data(), data.frame(category = input$category, amount = expense_value))
      expenses_data(new_data)
      selected_categories(c(selected_categories(), input$category))
      updateNumericInput(session, "expense", value = 0)
    }
  })


  # Generate editable table for editing
  output$expense_table <- renderDT({
    datatable(expenses_data(), editable = TRUE, options = list(dom = 't'))
  })

  # Update graphs when the table is edited
  observeEvent(input$expense_table_cell_edit, {
    info <- input$expense_table_cell_edit
    new_value <- suppressWarnings(as.numeric(info$value))
    if (!is.na(new_value)) {
      modified_data <- expenses_data()
      modified_data[info$row, info$col] <- new_value
      expenses_data(modified_data)
    } else {
      showNotification("Please enter a valid numeric value.", type = "error")
    }
  })

  # Update graphs when the data changes
  observe({
    total_expenses <- sum(expenses_data()$amount)
    savings <- ifelse(is.null(input$income), 0, input$income) - total_expenses
    data <- data.frame(
      category = c("Income", "Expenses", "Savings"),
      amount = c(ifelse(is.null(input$income), 0, input$income), total_expenses, savings)
    )

    output$bar_chart <- renderPlotly({
      budgetoverview::generate_bar_chart(data, input$colorblind_switch)
    })

    expenses_data_summary <- expenses_data() %>%
      dplyr::mutate(percentage = amount / total_expenses * 100)

    output$scatter_plot <- renderPlotly({
      generate_scatter_or_pie(expenses_data_summary, input$scatter_plot_type, input$colorblind_switch)
    })
  })

  # Update scatter plot for comparison
  observe({
    if (length(selected_categories()) > 0 && !any(is.na(match(selected_categories(), categories)))) {
      user_vs_swiss <- data.frame(
        category = selected_categories(),
        user_amount = expenses_data()$amount[match(selected_categories(), expenses_data()$category)],
        swiss_amount = swiss_expenses[match(selected_categories(), categories)]
      )

      # Check if user_vs_swiss is created correctly
      if (ncol(user_vs_swiss) < 3) {
        showNotification("Error in creating user_vs_swiss data frame", type = "error")
        return()
      }

      # Pivoting and transforming user_vs_swiss
      user_vs_swiss <- user_vs_swiss %>%
        tidyr::pivot_longer(cols = c("user_amount", "swiss_amount"), names_to = "type", values_to = "amount") %>%
        dplyr::mutate(type = ifelse(type == "user_amount", "User's Expenses", "Swiss Average Expenses"))

      # Adding hover text
      user_vs_swiss$hover_text <- paste(
        "Category: ", user_vs_swiss$category,
        "<br>Percentage: ", round(user_vs_swiss$amount / sum(user_vs_swiss$amount) * 100, 2), "%",
        "<br>Amount: ", user_vs_swiss$amount,
        sep = ""
      )

      # Creating the scatter plot
      output$compare_scatter_plot <- renderPlotly({
        generate_comparison_plot(user_vs_swiss, input$colorblind_switch)
      })

    }
  })
}
# Run the application
shinyApp(ui = ui, server = server)
