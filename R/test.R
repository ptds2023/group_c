library(budgetoverview)
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
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

    # Use custom function if category hasn't been selected before
    if (!(category %in% selected_categories())) {
      tryCatch({
        updated_expenses_data <- budgetoverview::add_expense(expenses_data(), category, amount)
        expenses_data(updated_expenses_data)
        selected_categories(c(selected_categories(), category))
      }, error = function(e) {
        showModal(modalDialog(title = "Error", e$message, easyClose = TRUE))
      })
    } else {
      # Category already selected, show a message
      showModal(modalDialog(
        title = "Category Already Selected",
        "You can only choose each category once. Please select a different category.",
        easyClose = TRUE
      ))
    }

    # Update UI components
    updateSelectInput(session, "category", choices = setdiff(categories, selected_categories()), selected = NULL)
    updateNumericInput(session, "expense", value = 0)
  })

  # Generate editable table for editing
  output$expense_table <- renderDT({
    datatable(expenses_data(), editable = TRUE, options = list(dom = 't'))
  })

  # Update bar chart and scatter plots
  observe({
    total_expenses <- sum(expenses_data()$amount)
    savings <- ifelse(is.null(input$income), 0, input$income) - total_expenses

    # Update bar chart with custom function
    output$bar_chart <- renderPlotly({
      financials <- budgetoverview::calculate_financials(expenses_data(), input$income)
      budgetoverview::createBarChart(financials)
    })

    # Determine which scatter plot to display
    output$scatter_plot <- renderPlotly({
      if (input$scatter_plot_type == "Scatter Plot") {
        budgetoverview::create_scatter_plot(expenses_data(), input$colorblind_switch)
      } else {
        # Assuming there's a function for pie chart in budgetoverview
        budgetoverview::create_pie_chart(expenses_data(), input$colorblind_switch)
      }
    })

    # Update comparison plot
    output$compare_scatter_plot <- renderPlotly({
      comparison_data <- budgetoverview::compare_to_average(expenses_data(), swiss_expenses)
      budgetoverview::create_comparison_scatter_plot(comparison_data, input$colorblind_switch)
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
