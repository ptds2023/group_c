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
colnames(budget_table) <- c("Expenses", "Per_month_average", "Portion_of_budget")
# 2. Convert data
budget_table$Per_month_average <- as.numeric(gsub("[^0-9.]", "", budget_table$Per_month_average))
budget_table$Portion_of_budget <- as.numeric(gsub(",", ".", gsub("[^0-9.]", "", budget_table$Portion_of_budget)))
# 3. Group expense types
budget_table <- budget_table %>%
  mutate(Grouped_Expenses = case_when(
    Expenses %in% c("Mandatory contributions (OASI, etc.)", "Various fees", "Other insurances", "Life insurance") ~ "Insurances & AVS",
    Expenses %in% c("Housing and utilities (primary residence)", "Homemaking", "Housing and utilities (secondary residence)") ~ "Rent",
    Expenses %in% c("Groceries", "Soft drinks") ~ "Food & Beverage",
    Expenses %in% c("Entertainment, recreation, and cultural activities", "Travel accommodations", "Donations, gifts, hosting") ~ "Leisure",
    Expenses %in% c("Vehicle purchases and maintenance", "Other transportation costs") ~ "Transport",
    Expenses == "Healthcare" ~ "Healthcare",
    Expenses == "Communications" ~ "Communications",
    Expenses == "Alimony and child support" ~ "Alimony and child support",
    Expenses == "Alcoholic drinks and tobacco" ~ "Alcoholic drinks and tobacco",
    Expenses %in% c("Home administration", "Other goods and services", "Clothing and shoes") ~ "Current household expenses",
    Expenses == "School and education" ~ "School",
    TRUE ~ as.character(Expenses)
  ))
# 4. Aggregate data
swiss_budget <- budget_table %>%
  group_by(Grouped_Expenses) %>%
  summarise(Total_CH = sum(as.numeric(gsub("CH ", "", Per_month_average))),
            Total_Percentage = sum(as.numeric(gsub("%", "", Portion_of_budget))))

# Create the CSV document
write.csv(swiss_budget, "swiss_budget.csv", row.names = FALSE)
