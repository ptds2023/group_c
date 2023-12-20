# Install required packages if not already installed
if (!require("rvest")) install.packages("rvest")
if (!require("kableExtra")) install.packages("kableExtra")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyverse")) install.packages("tidyverse")

library(rvest) # for webscraping
library(kableExtra) # for data presentation
library(dplyr) # for data wrangling
library(tidyverse) # for data wrangling

# https://www.moneyland.ch/robots.txt, no mention of webscraping forbidden.
# The ToS mention this : "The content may be viewed or printed, provided that it is intended exclusively for personal, non-commercial use."
# Webscraping seems to be authorized.

# Web scrape the moneyland website
url <- "https://www.moneyland.ch/en/money-budget-household-savings-switzerland"
budget_table <- url %>%
  read_html() %>%
  html_table() %>%
  .[[1]]

# Print the table using kableExtra
kableExtra::kable(budget_table, format = "html")

# Perform some data wrangling to get the final categories
# 1. Rename colnames
colnames(budget_table) <- c("expenses", "per_month_average", "portion_of_budget")
# 2. Convert data
budget_table$per_month_average <- as.numeric(gsub("[^0-9.]", "", budget_table$per_month_average))
budget_table$portion_of_budget <- as.numeric(gsub(",", ".", gsub("[^0-9.]", "", budget_table$portion_of_budget)))
# 3. Group expense types
budget_table <- budget_table %>%
  mutate(grouped_expenses = case_when(
    expenses %in% c("Mandatory contributions (OASI, etc.)", "Various fees", "Other insurances", "Life insurance") ~ "Insurances & AVS",
    expenses %in% c("Housing and utilities (primary residence)", "Homemaking", "Housing and utilities (secondary residence)") ~ "Rent",
    expenses %in% c("Groceries", "Soft drinks") ~ "Food & Beverage",
    expenses == "Entertainment, recreation, and cultural activities" ~ "Leisure",
    expenses %in% c("Vehicle purchases and maintenance", "Other transportation costs") ~ "Transport",
    expenses == "Healthcare" ~ "Healthcare",
    expenses == "Travel accommodations" ~ "Travel",
    expenses %in% c( "Donations, gifts, hosting", "Alimony and child support")  ~ "Donations and child support",
    expenses == "Communications" ~ "Communications",
    expenses == "Alcoholic drinks and tobacco" ~ "Alcoholic drinks and tobacco",
    expenses %in% c("Home administration", "Other goods and services") ~ "Current household expenses",
    expenses == "Clothing and shoes" ~ "Clothing and shoes",
    expenses == "School and education" ~ "School and education",
    TRUE ~ as.character(expenses)
  ))
# 4. Aggregate data
swiss_budget <- budget_table %>%
  group_by(grouped_expenses) %>%
  summarise(total_CH = sum(as.numeric(gsub("CH ", "", per_month_average))),
            total_percentage = sum(as.numeric(gsub("%", "", portion_of_budget))))

# Create the CSV document
write.csv(swiss_budget, "swiss_budget.csv", row.names = FALSE)
