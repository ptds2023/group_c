#' @title Launch My Shiny App
#' @name launchMyApp
#' @author Group C composed of Marc Bourleau, Eleonore Gillain, Khrystyna Khmilovska and Konstantinos Kourlimpinis.
#' @description This function starts the Shiny application contained in the package.
#' @export
launchMyApp <- function() {
  appDir <- system.file("shiny", package = "budgetoverview")
  if (appDir == "") {
    stop("Shiny app not found in the package")
  }
  shiny::runApp(appDir)
}

