#' @title Add an Expense to the Data Frame
#' @name add_expense
#' @description This function adds a new expense entry to the given data frame of expenses. It checks for the validity of the category and amount before adding.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param expenses_data A reactive value containing a data frame of expenses.
#' @param selected_categories A reactive value storing the list of already selected categories.
#' @param amount The amount of the new expense, must be non-negative.
#' @return Logical indicating whether the expense was successfully added (TRUE) or not (FALSE).
#' @export
#' @examples
#' # In a Shiny server function:
#' expenses_data <- reactiveVal(data.frame(category = character(), amount = numeric()))
#' selected_categories <- reactiveVal(character())
#'
#' observeEvent(input$add_expense, {
#'   result <- add_expense(input$category, input$expense, expenses_data, selected_categories)
#'   if (result) {
#'     # Update UI or perform other actions
#'   }
#' })
add_expense <- function(category, amount, expenses_data, selected_categories) {
  if (is.na(amount) || amount < 0) {
    stop("Amount must be a non-negative number")
  }

  if (!(category %in% selected_categories())) {
    new_data <- rbind(expenses_data(), data.frame(category = category, amount = amount))
    expenses_data(new_data)
    selected_categories(c(selected_categories(), category))
    TRUE
  } else {
    FALSE
  }
}
