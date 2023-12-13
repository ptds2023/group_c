#' @title Calculate Total Expenses and Savings
#' @name calculate_financials
#' @description This function calculates the total expenses and savings based on the provided data frame of expenses and the user's income.
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @param expenses_data A data frame containing expenses.
#' @param income Numeric value of the user's income.
#' @return A list containing the total expenses and savings.
#' @export
#' @examples
#' expenses <- data.frame(category = c("Food", "Rent"), amount = c(100, 500))
#' financials <- calculate_financials(expenses, 2000)
calculate_financials <- function(expenses_data, income) {
  # Check if income is numeric and greater than zero
  if (!is.numeric(income) || is.na(income) || income <= 0) {
    stop("Invalid income")
  }

  total_expenses <- sum(expenses_data$amount)
  savings <- income - total_expenses

  return(list(total_expenses = total_expenses, savings = savings))
}
