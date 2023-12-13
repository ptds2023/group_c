#' @title Add an Expense to the Data Frame
#' @name add_expense
#' @description This function adds a new expense entry to the given data frame of expenses. It checks for the validity of the category and amount before adding.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param expenses_data A data frame containing existing expenses.
#' @param category The category of the new expense.
#' @param amount The amount of the new expense.
#' @return A data frame with the new expense added.
#' @export
#' @examples
#' expenses <- data.frame(category = character(), amount = numeric())
#' expenses <- add_expense(expenses, "Food", 100)
add_expense <- function(expenses_data, category, amount) {
  # Ensure that the category and amount are valid
  if (is.null(category) || is.na(amount) || amount <= 0) {
    stop("Invalid category or amount")
  }

  # Add the new expense to the data frame
  new_expense <- data.frame(category = category, amount = amount)
  updated_expenses_data <- rbind(expenses_data, new_expense)

  return(updated_expenses_data)
}
