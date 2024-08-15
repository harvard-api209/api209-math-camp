# -------------------------------------------------------------------------
# First Hands-on Session - Data Manipulation
# Date: August 15, 2024
# Author: Rony Rodriguez-Ramirez
# Course: API-209 (Math Camp)
# -------------------------------------------------------------------------

# Load Packages -----------------------------------------------------------
# We will use the tidyverse for data manipulation and janitor for cleaning data.
library(tidyverse)
library(janitor)
library(modelsummary)

# Load the Data -----------------------------------------------------------
# Let's start by loading the migration dataset. This dataset contains information
# about migration trends for different countries.
migration <- read_csv("files/data/external_data/migration.csv")

# Cleaning the Data -------------------------------------------------------
# Before we start analyzing, it's important to clean our data.
# We'll use the clean_names() function from janitor to standardize column names
# by converting them to snake_case, which makes them easier to work with.
migration <- migration |> 
  clean_names()


# Exercise 1: Data Filtering and Summarizing ------------------------------

## Part 1: Filtering the Data
# Let's focus on a subset of countries in Central America. We want to analyze data
# from Nicaragua, El Salvador, Costa Rica, Panama, Guatemala, and Belize, and 
# only consider the years from 1990 to 2020.

migration_filtered <- migration |> 
  filter(
    country %in% c("Nicaragua", "El Salvador", "Costa Rica", "Panama", "Guatemala", "Belize"),
    (year >= 1990 & year <= 2020)
  )

# Explanation: The filter() function is used to subset the data based on specific conditions.
# Here, we're selecting rows where the 'country' is one of the specified countries and 
# the 'year' is between 1990 and 2020.

## Part 2: Summarizing the Data
# Now that we have our filtered dataset, let's summarize the data to calculate 
# the mean number of emigrants by country.

migration_filtered |> 
  group_by(country) |> 
  summarize(
    mean_emigrants = mean(emigrants)
  )

# Exercise: What's the issue with the above code?
# HINT: Think about what happens if there are missing values (NA) in the 'emigrants' column.

# Explanation: The mean() function by default includes NA values, which will return NA
# as the result if any NA values are present. We need to handle missing values properly.

## Correcting the Summary
# Let's correct the summary by ignoring missing values using the na.rm = TRUE option.

migration_filtered |> 
  group_by(country) |> 
  summarize(
    mean_emigrants = mean(emigrants, na.rm = TRUE),
    n_observations = n(),
    min_year = min(year),
    max_year = max(year)
  )

# Exercise: What could be wrong with this approach?
# HINT: Are all the observations being used in the calculation? What about years with missing data?

# Identifying Missing Data ------------------------------------------------
# Let's investigate how many missing values exist for each country in the 'emigrants' variable.
# This will help us understand how missing data might affect our summary statistics.

migration_filtered |> 
  group_by(country) |> 
  summarize(
    n_missing = sum(is.na(emigrants)),
    n_observations = n(),
    missing_rate = n_missing / n_observations
  )

# Explanation: Here, we're counting the number of missing values (n_missing) for each country,
# and calculating the proportion of missing data (missing_rate).

## Re-doing the Summary with Improved Understanding -----------------------
# Now, let's improve our summary by accounting for missing values. 
# We'll calculate the mean only where data is available, and ensure that our count 
# of observations reflects only those used in the mean calculation.

migration_filtered |> 
  group_by(country) |> 
  summarize(
    mean_emigrants = mean(emigrants, na.rm = TRUE),
    n_observations = sum(!is.na(emigrants)),  # Counts only non-missing values
    min_year = min(year[!is.na(emigrants)]),  # Finds the earliest year with data
    max_year = max(year[!is.na(emigrants)])   # Finds the latest year with data
  )

# Explanation: By using sum(!is.na(emigrants)), we ensure that only non-missing observations 
# are counted. Similarly, min() and max() are calculated only for years where data is present.

## Simplifying the Process -------------------------------------------------
# To avoid handling missing data in multiple steps, we can filter out the missing values
# before grouping and summarizing. This ensures our calculations are straightforward and accurate.

migration_filtered |> 
  filter(!is.na(emigrants)) |>         # Remove missing data before summarizing
  group_by(country) |> 
  summarize(
    mean_emigrants = mean(emigrants),  # No need for na.rm = TRUE because NAs are filtered out
    n_observations = n(),              # Count all non-missing observations
    min_year = min(year),              # Get the earliest year
    max_year = max(year)               # Get the latest year
  )

# Exercise 2 -------------------------------------------------------------

# In this exercise, we will explore how to summarize multiple variables at once
# using the `across()` function. We will start with a simple example and gradually
# build up to more complex summaries, including calculating multiple statistics 
# (mean, standard deviation, etc.). Finally, we'll create a function to automate 
# this process for any set of variables.

# Part 1: Selecting Relevant Variables -------------------------------------
# Suppose we want to analyze multiple columns: `emigrants`, and `international_migrants`.
# Let's start by selecting these variables.

migration_filtered |> 
  select(year, country, emigrants, international_migrants)

# Part 2: Summarizing Multiple Variables -----------------------------------
# We want to calculate the mean of both `emigrants` and `international_migrants` 
# for each country. Let's use the `across()` function to do this.

migration_filtered |> 
  group_by(country) |> 
  select(year, country, emigrants, international_migrants) |> 
  summarize(
    across(
      c(emigrants, international_migrants), 
      mean,
      .names = "mean_{.col}"
    )
  )

# Question: 
# What issue might arise with the above code?
# HINT: Think about how missing values (`NA`) are handled in the `mean()` function.

# Explanation:
# As in the previous exercise, the mean calculation will return `NA` if there are 
# any missing values. We need to handle these missing values properly.

# Part 3: Handling Missing Values ------------------------------------------
# Let's modify the code to remove the missing values before calculating the mean.

migration_filtered |> 
  group_by(country) |> 
  select(year, country, emigrants, international_migrants) |> 
  summarize(
    across(
      c(emigrants, international_migrants), 
      ~mean(.x, na.rm = TRUE), 
      .names = "mean_{.col}"
    )
  )

# Now the mean values are calculated correctly, ignoring any missing values.

# Part 4: Calculating Multiple Statistics ----------------------------------
# What if we want to calculate additional statistics, such as the standard deviation?
# We can use the `list()` function within `across()` to calculate both the mean 
# and standard deviation.

migration_filtered |> 
  group_by(country) |> 
  select(year, country, emigrants, international_migrants) |> 
  summarize(
    across(
      c(emigrants, international_migrants), 
      list(
        mean = ~mean(.x, na.rm = TRUE), 
        sd = ~sd(.x, na.rm = TRUE)
      ), 
    .names = "{.fn}_{.col}")
  )

# Explanation:
# This code calculates both the mean and standard deviation for each country 
# and variable. The results are stored in separate columns with informative names.

# Exercise: Creating a Function --------------------------------------------
# Let's create a more advanced exercise. What if we want to automate this process 
# so that we can apply it to any set of variables? We'll create a function that 
# takes two arguments: the dataset we want to analyze and the set of variables 
# we want to summarize.

# Here is the function definition:

summarize_migration_data <- function(data, group_var, summary_vars) {
  data |> 
    group_by(across(all_of(group_var))) |> 
    summarize(
      across(
        all_of(summary_vars),
        list(
          n    = ~sum(!is.na(.x)),
          mean = ~mean(.x, na.rm = TRUE), 
          sd   = ~sd(.x, na.rm = TRUE), 
          min  = ~min(.x, na.rm = TRUE),
          max  = ~max(.x, na.rm = TRUE)
        ),
        .names = "{.fn}_{.col}"
      )
    ) |> 
    pivot_longer(cols = -all_of(group_var), names_to = c("stat", "var"), names_sep = "_") |> 
    pivot_wider(names_from = "stat", values_from = "value")
}

# Exercise: Test the Function ----------------------------------------------
# Let's test the function with our filtered migration data, summarizing both 
# `emigrants` and `immigrants` (which we renamed from `international_migrants`).

migration_filtered |>
  rename(immigrants = international_migrants) |> 
  summarize_migration_data(
    group_var = "country",
    summary_vars = c("emigrants", "immigrants")
  )

# Explanation:
# This function call should return a data frame with summary statistics 
# (n, mean, sd, min, max) for both `emigrants` and `immigrants`, grouped by country.

