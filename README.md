[![R-CMD-check](https://github.com/ptds2023/pkgTest/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/ptds2023/pkgTest/actions/workflows/R-CMD-check.yaml)

# Welcome to our project "BudgetOverview" !

## What is this project about? 

**budgetoverview** is a comprehensive tool for managing and analyzing monthly personal finances, as well as comparing his finances to the average Swiss household.

With the help of our R-Shiny app, the user can input his monthly Income and expenses, and can then visualize them using a scatter plot or a pie chart. The Shiny is interactive in every way possible, allowing the user to edit input errors and view color-blind friendly graphs. 

### Key Features:

Here's what the our Shiny app does in more detail: 

- Expense Logging: Easy categorization and recording of personal expenses.
- Financial Calculations: Automatically computes total expenses and savings.
- Comparative Analysis: Enables comparison of personal spending against the average expenses of a Swiss household. 
- Visual Representations: Provides insightful bar charts and scatter plots for financial data.

### Installation: Simple steps to install the package from CRAN or GitHub.

- Quick Start: Guidelines to quickly begin using the app and package functionalities.
- Contributing: Open invitation for feedback and contributions to enhance the package.
- License: Details of the package's licensing agreement.


## How are the files organized in this project? 

There's many different folders & files in our package directory and here's what you can find in each of them. 

### Folders: 

- R: In this directory you can find all the R script files (.R) with functions that the package/Shiny uses (example: graph creation based on the user's data)
- man: In this directory you can find the documentation files. Every function in our package has a description which is found here. These were all automatically generated using ROxygen.
- data: This directory is where all the user's data can be found. This is where they are stored once the user inputs them through the shiny app. 

### Files: 

- DESCRIPTION: This metadata file includes information about our package name, version, author and dependencies on other packages. 

