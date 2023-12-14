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

  # Add expense when button is clicked
  observeEvent(input$add_expense, {
    tryCatch({
      updated_expenses_data <- budgetoverview::add_expense(expenses_data(), input$category, input$expense)
      expenses_data(updated_expenses_data)

      # Update the selectInput choices
      updateSelectInput(session, "category", choices = setdiff(categories, expenses_data()$category), selected = NULL)
      updateNumericInput(session, "expense", value = 0)
    }, error = function(e) {
      showModal(modalDialog(
        title = "Error",
        e$message,
        easyClose = TRUE
      ))
    })
  })

  # Generate editable table for editing
  output$expense_table <- renderDT({
    datatable(expenses_data(), editable = TRUE, options = list(dom = 't'))
  })

  # Update bar chart when the table or income is edited
  output$bar_chart <- renderPlotly({
    financials <- budgetoverview::calculate_financials(expenses_data(), input$income)
    data <- data.frame(
      category = c("Income", "Expenses", "Savings"),
      amount = c(input$income, financials$total_expenses, financials$savings)
    )
    createBarChart(data)
  })

  # Update scatter plot when the table is edited
  output$scatter_plot <- renderPlotly({
    budgetoverview::create_scatter_plot(expenses_data())
  })

  # Update scatter plot for comparison
  output$compare_scatter_plot <- renderPlotly({
    comparison_data <- budgetoverview::compare_to_average(expenses_data(), swiss_expenses, expenses_data()$category)
    ggplot(comparison_data, aes(x = UserExpenses, y = AverageExpenses, label = Category)) +
      geom_point() +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
