#' @title Add an Expense to the Data Frame
#' @name add_expense
#' @description This function adds a new expense entry to the given data frame of expenses. It checks for the validity of the category and amount before adding.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param category A string specifying the category of the expense.
#' @param amount A numeric value representing the amount of the expense. Must be non-negative.
#' @param expenses_data A reactive value containing a data frame of expenses.
#' @param selected_categories A reactive value storing the list of already selected categories.
#' @param session The Shiny session object passed to showModal for displaying modals.
#' @return Logical TRUE if the expense is successfully added, FALSE otherwise.
#' @importFrom shiny showModal
#' @importFrom shiny modalDialog
#' @examples
#' \dontrun{
#'   # Simulate the environment of a Shiny app
#'   library(shiny)
#'   expenses_data <- reactiveVal(data.frame(category = character(), amount = numeric()))
#'   selected_categories <- reactiveVal(character())
#'   session <- shiny::getDefaultReactiveDomain()
#'
#'   # Examples of add_expense function
#'   add_expense("Food", 50, expenses_data, selected_categories, session)
#'   add_expense("Transport", -10, expenses_data, selected_categories, session) # Invalid amount
#'   add_expense("Food", 30, expenses_data, selected_categories, session) # Category already exists
#' }
#' @export
add_expense <- function(category, amount, expenses_data, selected_categories, session) {
  if (is.na(amount) || amount < 0) {
    showModal(modalDialog(
      title = "Invalid Amount",
      "Amount must be a non-negative number.",
      easyClose = TRUE,
      footer = NULL
    ), session = session)
    return(FALSE)
  }

  if (!(category %in% selected_categories())) {
    new_data <- rbind(expenses_data(), data.frame(category = category, amount = amount))
    expenses_data(new_data)
    selected_categories(c(selected_categories(), category))
    return(TRUE)
  } else {
    return(FALSE)
  }
}
