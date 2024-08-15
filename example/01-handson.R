# -------------------------------------------------------------------------
# First Hands-on Session - Data Manipulation
# Date: August 15, 2024
# Author: Rony Rodriguez-Ramirez
# Course: API-209 (Math Camp)
# -------------------------------------------------------------------------

# Load Packages -----------------------------------------------------------
# Load the necessary packages for data manipulation and cleaning.
library(tidyverse)
library(janitor)
library(modelsummary)

# Load the Data -----------------------------------------------------------
# Load the migration dataset, which contains information about migration trends
# for different countries.
migration <- read_csv("files/data/external_data/migration.csv")

# Cleaning the Data -------------------------------------------------------
# Clean the data by standardizing column names using the clean_names() function
# from the janitor package.
migration <- migration |> 
  clean_names()

# Exercise 1: Data Filtering and Summarizing ------------------------------

## Part 1: Filtering the Data
# Filter the data to focus on a subset of countries in Central America: 
# Nicaragua, El Salvador, Costa Rica, Panama, Guatemala, and Belize. 
# Only consider the years from 1990 to 2020.

# HINT: Use the filter() function to subset the data based on country and year.

## Part 2: Summarizing the Data
# Summarize the filtered data to calculate the mean number of emigrants by country.

# Question: What might be an issue with the above code?
# HINT: Consider how missing values (NA) in the 'emigrants' column might affect the results.

## Correcting the Summary
# Adjust the code to properly handle missing values when calculating the mean.

# Question: Could there be another issue with this approach?
# HINT: Think about whether all observations are being included in the calculation.

# Identifying Missing Data ------------------------------------------------
# Investigate the number of missing values for each country in the 'emigrants' variable.
# This will help you understand the impact of missing data on your summary statistics.

# HINT: Use summarize() to calculate the number of missing values and the proportion
# of missing data for each country.

## Re-doing the Summary with Improved Understanding -----------------------
# Recalculate the summary, ensuring that only valid observations are included in the mean calculation.

# HINT: Ensure that your summary includes only non-missing values and accurately reflects 
# the range of years for which data is available.

## Simplifying the Process -------------------------------------------------
# Simplify the summarization process by filtering out missing data before grouping and summarizing.

# HINT: Consider how pre-filtering missing values can make your code more straightforward.

# Exercise 2 -------------------------------------------------------------

# In this exercise, you'll explore how to summarize multiple variables at once 
# using the `across()` function. Start with a simple example and then expand to more 
# complex summaries, including calculating multiple statistics like mean and standard deviation.

# Part 1: Selecting Relevant Variables -------------------------------------
# Suppose you want to analyze the columns `emigrants` and `international_migrants`.
# Start by selecting these variables.

# HINT: Use the select() function to choose the relevant columns.

# Part 2: Summarizing Multiple Variables -----------------------------------
# Calculate the mean of both `emigrants` and `international_migrants` for each country
# using the `across()` function.

# Question: What issue might arise with the above code?
# HINT: Consider how missing values (`NA`) are handled in the `mean()` function.

# Part 3: Handling Missing Values ------------------------------------------
# Modify the code to remove the missing values before calculating the mean.

# HINT: Use the `na.rm = TRUE` argument within the `mean()` function.

# Part 4: Calculating Multiple Statistics ----------------------------------
# Expand your summary to calculate additional statistics, such as standard deviation, 
# using the `list()` function within `across()`.

# Exercise: Creating a Function --------------------------------------------
# Create a function that automates the summarization process for any set of variables.
# The function should take two arguments: the dataset to analyze and the set of variables 
# to summarize.

# HINT: Structure the function to group by the specified variable(s) and then 
# apply the necessary summary functions using `across()`.

# Exercise: Test the Function ----------------------------------------------
# Test your function with the filtered migration data, summarizing both `emigrants` 
# and `immigrants` (renamed from `international_migrants`).

# HINT: Ensure that your function handles missing data appropriately and produces 
# accurate summary statistics.
