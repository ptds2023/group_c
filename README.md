[![R-CMD-check](https://github.com/ptds2023/pkgTest/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/ptds2023/pkgTest/actions/workflows/R-CMD-check.yaml)

# Welcome to our project "BudgetOverview" !

## About:  

**budgetoverview** is a comprehensive tool for managing and analyzing monthly personal finances, as well as comparing his finances to the average Swiss household.

With the help of our R-Shiny app, the user can input his monthly Income and expenses, and can then visualize them using a scatter plot or a pie chart. The Shiny is interactive in every way possible, allowing the user to edit input errors and view color-blind friendly graphs. 

## Installation 

Use the following command in the console: 

```r
devtools::install_github("ptds/group_c")
library(budgetoverview)

```

## Shiny - How to launch

1. Website 

https://ptnsy6-marc-bourleau.shinyapps.io/shiny/


2. Console 

```r
budgetoverview::launchMyApp()

```

## Documentation

Click here for viewing our documentation: 


### Key Features:

Here's what the our Shiny app does in more detail: 

- Expense Logging: Easy categorization and recording of personal expenses.
- Financial Calculations: Automatically computes total expenses and savings.
- Comparative Analysis: Enables comparison of personal spending against the average expenses of a Swiss household. 
- Visual Representations: Provides insightful bar charts and scatter plots for financial data.

## Getting help

**FIX THIS**

There are two main places to get help with ggplot2:

1. The RStudio community is a friendly place to ask any questions about ggplot2.

2. Stack Overflow is a great source of answers to common ggplot2 questions. It is also a great place to get help, once you have created a reproducible example that illustrates your problem.

## File Organization

There's many different folders & files in our package directory and here's what you can find in each of them. 

### Folders: 

- **R**: Contains R script files (.R) with functions that the package/Shiny uses (example: graph creation based on the user's data)
- **man**: Contains documentation files. Every function in our package has a description which is found here. These were all automatically generated using ROxygen.
- **data**: This directory is where all the user's data can be found. This is where they are stored once the user inputs them through the shiny app.
- **raw-data**: Web scrapped data.
- **vignettes**: Here you can find the vignettes we built for explaining the functions of our package and displaying their usage with some examples
- **tests**: Here there are tests for each function that are performed whenever the package is used, to ensure everything is working correctly before the functions are called in the shiny app.
- **presentation files**: In here you can see our presentation code and HTML file. 

### Files: 

- **DESCRIPTION**: This metadata file includes information about our package name, version, author and dependencies on other packages. 

