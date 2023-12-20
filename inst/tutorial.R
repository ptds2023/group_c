#### TUTORIAL ####

######## INSTALLATION #########


devtools::install_github("ptds2023/group_c")


####### CHECK ###########
devtools::check()

######## EXAMPLE #########

data <- data.frame(
   category = c("Income", "Expenses", "Savings"),
   amount = c(1000, 750, 250))

plot <- budgetoverview::generate_bar_chart(data, TRUE)
plot

####### DEPLOY SHINY ########
# 1: using the function
budgetoverview::launchMyApp()
# 2: shinyapp.io -->
