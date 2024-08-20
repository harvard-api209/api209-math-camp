# -------------------------------------------------------------------------
# Second Hands-on Session - Tidy Data and Visualization
# Date: August 20, 2024
# Author: Rony Rodriguez-Ramirez
# Course: API-209 (Math Camp)
# -------------------------------------------------------------------------

# Overview of Functions to Be Used ----------------------------------------
# ggplot(): Initializes a ggplot object that stores data and the aesthetic mappings.
# aes(): Defines the aesthetic mappings, such as x and y axes, color, size, etc.
# geom_point(): Adds points to the plot, commonly used for scatter plots.
# geom_smooth(): Adds a smoothed conditional mean, often used to visualize trends.
# geom_hline(): Adds a horizontal line across the plot, useful for reference lines.
# geom_text(): Adds text labels to points in the plot.
# scale_x_continuous(), scale_y_continuous(): Adjusts the scales of the axes.
# scale_color_manual(): Manually adjusts the color scale used in the plot.
# coord_cartesian(): Limits the plot display area without changing the data.
# facet_wrap(): Creates separate plots (facets) for subsets of data.
# labs(): Adds labels to the axes, title, and other plot elements.
# theme_minimal(): Applies a minimal theme to the plot for a clean look.

# Variables in the dataset ------------------------------------------------
# year: The year of the presidential election (2016).
# state: The state abbreviation.
# region: The state's Census region.
# division: The state's Census division.
# turnoutho: Voter turnout for the highest office as percent of voting-eligible population (VEP).
# perhsed: The percentage of the state that completed high school.
# percoled: The percentage of the state that completed college.
# gdppercap: An estimate of the state's GDP per capita.
# ss: Is it a “swing state?”.
# trumpw: Did Trump win the state?
# trumpshare: The share of the vote Trump received.
# sunempr: The state-level unemployment rate entering Nov. 2016.
# sunempr12md: The state-level unemployment rate (12-month difference) entering Nov. 2016.
# gdp: An estimate of the state's GDP.

# Load Packages -----------------------------------------------------------
# Load the necessary packages for data manipulation and visualization.
library(tidyverse)
library(hrbrthemes)

# Load the Data -----------------------------------------------------------
# Load the election dataset, which contains information about state-level turnout
# and various economic indicators during the 2016 presidential election.
election <- read_csv("files/data/external_data/election_turnout.csv")

# Inspect the data -------------------------------------------------------
# Use glimpse() to get a quick overview of the dataset, including variable names and types.
election |> 
  glimpse()

# Exercise 1: Basic Scatter Plot ------------------------------------------
# Create a simple scatter plot to visualize the relationship between 
# the share of the vote Trump received (trumpshare) and the percentage of the state 
# that completed college (percoled).

# Example Code:
# ggplot(data = election, aes(x = ..., y = ...)) +
#   geom_point() +
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label") +
#   theme_minimal()

# Exercise 2: Data Transformation -----------------------------------------
# Convert `trumpw` to a factor (categorical variable) and rescale `percoled` 
# by dividing by 100 to represent it as a proportion.
# Then, create a scatter plot using the transformed data.

# Example Code:
# election_transformed <- election |> 
#   mutate(
#   )

# ggplot(data = election_transformed, aes(x = ..., y = ...)) +
#   geom_point() +
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label") +
#   theme_minimal()

# Exercise 3: Filtering Data ----------------------------------------------
# Remove the outlier state "District of Columbia" and create a scatter plot 
# using the filtered data.

# Example Code:
# election_filtered <- election_transformed |> 
#   filter(state != "District of Columbia")

# ggplot(data = election_filtered, aes(x = ..., y = ...)) +
#   geom_point() +
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label") +
#   theme_minimal()

# Exercise 4: Adding a Regression Line ------------------------------------
# Add a linear regression line to the scatter plot to visualize the trend.

# Example Code:
# ggplot(data = election_filtered, aes(x = ..., y = ...)) +
#   geom_point() +
#   geom_smooth(method = ..., color = "black", se = FALSE) +  # Add a linear regression line
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label") +
#   theme_minimal()

# Exercise 5: Adding a Horizontal Reference Line --------------------------
# Add a horizontal dashed line at 50% Trump vote share to indicate a critical threshold.

# Example Code:
# ggplot(data = election_filtered, aes(x = ..., y = ...)) +
#   geom_point() +
#   geom_smooth(method = ..., color = "black", se = FALSE) +
#   geom_hline(yintercept = ...) + # Add horizontal line
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label") +
#   theme_minimal()

# Exercise 6: Adding Text Labels ------------------------------------------
# Add state labels to the points for better identification.

# Example Code:
# ggplot(data = election_filtered, aes(x = ..., y = ...)) +
#   geom_point() +
#   geom_smooth(method = ..., color = "black", se = FALSE) +
#   geom_hline(yintercept = ...) +
#   geom_text(aes(label = ...), vjust = -0.5, size = 3, show.legend = FALSE) + # Add text labels
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label") +
#   theme_minimal()

# Exercise 7: Adjusting Axis Scales ---------------------------------------
# Adjust the x and y scales to display percentages and add a manual color scale.

# Example Code:
# ggplot(data = election_filtered, aes(x = ..., y = ..., color = ...)) +
#   geom_point() +
#   geom_smooth(method = ..., color = "black", se = FALSE) +
#   geom_hline(yintercept = ..., linetype = "dashed", color = "grey") +
#   geom_text(aes(label = ...), vjust = -0.5, size = 3, show.legend = FALSE) +
#   scale_x_continuous(labels = scales::percent) +  # Format x-axis as percentage
#   scale_y_continuous(breaks = seq(0,1,.2), labels = scales::percent) +  # Format y-axis as percentage
#   scale_color_manual(labels = c("No", "Yes"), values = c("blue", "red")) + # Custom color scale
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label", color = "Legend Title") +
#   theme_minimal()

# Exercise 8: Adding Facets -----------------------------------------------
# Add facets to create separate plots for each region.

# Example Code:
# ggplot(data = election_filtered, aes(x = ..., y = ..., color = ...)) +
#   geom_point() +
#   geom_smooth(method = ..., color = "black", se = FALSE) +
#   geom_hline(yintercept = ..., linetype = "dashed", color = "grey") +
#   geom_text(aes(label = ...), vjust = -0.5, size = 3, show.legend = FALSE) +
#   scale_x_continuous(labels = scales::percent) +  
#   scale_y_continuous(breaks = seq(0,1,.2), labels = scales::percent) +
#   scale_color_manual(labels = c("No", "Yes"), values = c("blue", "red")) +
#   coord_cartesian(clip = "off") + # Ensure labels are not clipped
#   facet_wrap(~ ...) +             # Facet by region
#   labs(title = "Title Here", x = "X-axis Label", y = "Y-axis Label", color = "Legend Title") +
#   theme_minimal()

# Recap ------------------------------------------------------------------
# Summarize the steps taken to build a complex ggplot visualization, 
# starting from a basic scatter plot and progressively enhancing it with various layers and transformations.
