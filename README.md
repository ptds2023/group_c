[![R-CMD-check](https://github.com/ptds2023/pkgTest/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/ptds2023/pkgTest/actions/workflows/R-CMD-check.yaml)

# `budgetoverview` package

## Overview

`budgetoverview` is a package for managing personal finances, offering monthly analysis and comparisons with the average Swiss household's finances.

Our Shiny app enables users to input their monthly income and expenses for visualization through interactive scatter plots or pie charts. It offers full interactivity for error correction and includes color-blind-friendly graph options.

## Package - How to install

Use the following command in the console:

``` r
devtools::install_github("ptds2023/group_c")
library(budgetoverview)
```

## Shiny - How to launch

1.  [Website](https://ptnsy6-marc-bourleau.shinyapps.io/shiny/)
2.  Console

``` r
budgetoverview::launchMyApp()
```

## Documentation

Click [here](https://ptds2023.github.io/group_c/articles/function-usage.html)

### Key Features:

-   Expense Logging: Easy categorization and recording of personal expenses.
-   Financial Calculations: Automatic calculation of total expenses and savings.
-   Comparative Analysis: Comparison of personal expenses against the average expenses of a Swiss household.
-   Visual Representations: Creation of insightful bar charts and scatter plots for financial data.

## File Organization

### Folders:

-   **R**: contains functions used in the package.
-   **man**: generated automatically by Roxygen. Documentation of the functions.
-   **raw-data**: web scrapped data.
-   **vignettes**: contains vignettes used in the `pkgdown` [website](https://ptds2023.github.io/group_c/)
-   **tests**: tests are conducted on each function for validation
-   **inst:** used to store some non-R files and static content that should be included in the package, such as the <u>presentation</u> files, as well as the <u>shiny</u> app.
-   **renv**: for managing project-specific dependencies - makes sure the environment is reproducible.

### Files:

-   **DESCRIPTION**: metadata file including information about our package name, version, authors and dependencies of other packages.
- **LICENSE** : information about the license of this package.
- **group_c.Rpoj**: Use this to load the package and set up the R working directory.

## Getting help

There are two main places to get help with `budgetoverview`:

1.  The RStudio community is a friendly place to ask any questions.

2.  Stack Overflow is a great source of answers to common R programming questions. It is also a great place to get help, once you have created a reproducible example that illustrates your problem.
