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
# Let's start with a simple scatter plot to visualize the relationship between 
# the share of the vote Trump received (trumpshare) and the percentage of the state 
# that completed college (percoled).

election |> 
  ggplot(
    aes(
      x = percoled,    # percoled on the x-axis
      y = trumpshare   # trumpshare on the y-axis
    )
  ) +
  geom_point() +          # Add points to represent each state
  labs(
    title = "Relationship between Trump Vote Share and College Education",
    x = "Percentage with College Education",
    y = "Trump Vote Share"
  ) +
  theme_minimal()

# Exercise 2: Data Transformation -----------------------------------------
# Before we enhance our plot, let's transform some variables. We'll convert `trumpw`
# to a factor (categorical variable) and rescale `percoled` by dividing by 100 to represent it as a proportion.

election_transformed <- election |> 
  mutate(
    trumpw = as_factor(trumpw),  # Convert trumpw to a factor
    percoled = percoled / 100    # Rescale percoled to be a proportion
  )

# Now let's plot using the transformed data.

election_transformed |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare
    )
  ) +
  geom_point() +
  labs(
    title = "Trump Vote Share vs. College Education (Transformed Data)",
    x = "Percentage with College Education",
    y = "Trump Vote Share"
  ) +
  theme_minimal()

# Exercise 3: Filtering Data ----------------------------------------------
# Let's remove the outlier state "District of Columbia" to get a clearer view of the data.

election_filtered <- election_transformed |> 
  filter(state != "District of Columbia")

# Now plot the filtered data.

election_filtered |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare
    )
  ) +
  geom_point() +
  labs(
    title = "Trump Vote Share vs. College Education (Filtered Data)",
    x = "Percentage with College Education",
    y = "Trump Vote Share"
  ) +
  theme_minimal()

# Exercise 4: Adding a Regression Line ------------------------------------
# Next, we'll add a linear regression line to the scatter plot to visualize the trend.

election_filtered |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +       # Add a linear regression line
  labs(
    title = "Trump Vote Share vs. College Education with Regression Line",
    x = "Percentage with College Education",
    y = "Trump Vote Share"
  ) +
  theme_minimal()

# Exercise 5: Adding a Horizontal Reference Line --------------------------
# We'll add a horizontal dashed line at 50% Trump vote share to indicate a critical threshold.

election_filtered |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey") + # Add horizontal line at 50%
  labs(
    title = "Trump Vote Share vs. College Education with Reference Line",
    x = "Percentage with College Education",
    y = "Trump Vote Share"
  ) +
  theme_minimal()

# Exercise 6: Adding Text Labels ------------------------------------------
# Now, let's add state labels to the points for better identification.

election_filtered |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey") +
  geom_text(aes(label = state), vjust = -0.5, size = 3, show.legend = FALSE) + # Add text labels
  labs(
    title = "Trump Vote Share vs. College Education with State Labels",
    x = "Percentage with College Education",
    y = "Trump Vote Share"
  ) +
  theme_minimal()

# Exercise 7: Adjusting Axis Scales ---------------------------------------
# Next, let's adjust the x and y scales to display percentages and add a manual color scale.

election_filtered |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare,
      color = trumpw    # Color points by whether Trump won the state
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey") +
  geom_text(aes(label = state), vjust = -0.5, size = 3, show.legend = FALSE) +
  scale_x_continuous(labels = scales::percent) +  # Format x-axis as percentage
  scale_y_continuous(breaks = seq(0,1,.2), labels = scales::percent) +  # Format y-axis as percentage
  scale_color_manual(labels = c("No", "Yes"), values = c("blue", "red")) + # Custom color scale
  labs(
    title = "Trump Vote Share vs. College Education with Adjusted Scales",
    x = "Percentage with College Education",
    y = "Trump Vote Share",
    color = "Did Trump win the State?"
  ) +
  theme_minimal()

# Exercise 8: Adding Facets -----------------------------------------------
# Finally, let's add facets to create separate plots for each region.

election_filtered |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare,
      color = trumpw
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey") +
  geom_text(aes(label = state), vjust = -0.5, size = 3, show.legend = FALSE) +
  scale_x_continuous(labels = scales::percent) +  
  scale_y_continuous(breaks = seq(0,1,.2), labels = scales::percent) +
  scale_color_manual(labels = c("No", "Yes"), values = c("blue", "red")) +
  coord_cartesian(clip = "off") + # Ensure labels are not clipped
  facet_wrap(~ region) +          # Facet by region
  labs(
    title = "Trump Vote Share vs. College Education by Region",
    x = "Percentage with College Education",
    y = "Trump Vote Share",
    color = "Did Trump win the State?"
  ) +
  theme_minimal()

# Recap ------------------------------------------------------------------
# Throughout this session, we've progressively built a complex ggplot visualization by 
# starting with a basic scatter plot and then adding various layers and transformations.
# The final plot includes data transformation, filtering, regression lines, custom scales,
# and facets by region, providing a comprehensive view of the relationship between 
# Trump's vote share and college education across different states.

election |> 
  mutate(
    trumpw  = as_factor(trumpw),
    percoled = percoled / 100
  ) |> 
  filter(
    state != "District of Columbia"
  ) |> 
  ggplot(
    aes(
      x = percoled,
      y = trumpshare,
      color = trumpw
    )
  ) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +       # Add a linear regression line    
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey") + 
  geom_text(aes(label = state), vjust = -0.5, size = 3, show.legend = FALSE) +        # Add text labels  
  scale_x_continuous(labels = scales::percent) +  
  scale_y_continuous(breaks = seq(0,1,.2), labels = scales::percent) +
  scale_color_manual(labels = c("No", "Yes"), values = c("blue", "red")) + 
  coord_cartesian(clip = "off") + 
  facet_wrap(~ region) + 
  labs(
    title = "Trump Vote Share vs. College Education",
    x = "Percentage with College Education",    
    y = "Trump Vote Share",
    color = "Did Trump win the State?",
    caption = "Notes: Some notes here | Source: Source here | Plot by @"
  ) +
  theme_ipsum_es(base_family = "Econ Sans Cnd") +
  theme(    
    # Grid lines
    panel.grid.major.x = element_line(color = "lightgray", size = 0.5),
    panel.grid.major.y = element_line(color = "lightgray", size = 0.5),
    panel.grid.minor = element_blank(),
    
    # Axis text
    axis.text.y = element_text(size = 12, color = "gray30", hjust = 0),    
    axis.text = element_text(size = 12, color = "gray30"),
    
    # Axis titles
    axis.title = element_text(size = 14, color = "gray30"),
    
    # No legend title
    legend.position = "top",
    legend.location = "plot", 
    legend.direction = "horizontal",
    legend.justification = "left", 
    legend.margin = margin(0,0,0,0),
    legend.text = element_text(size = 12, color = "black"),

    # Caption text
    plot.caption = element_text(size = 12, hjust = 0, family = "Econ Sans Cnd"),
    plot.caption.position =  "plot",
    plot.title.position = "plot",
    plot.title = element_text(family = "Econ Sans Cnd"),
    plot.subtitle = element_text(family = "Econ Sans Cnd")
  )   

## Saving your plot
ggsave(
  "example/figs/data-viz.png", 
  dpi = 320, height = 12, width = 18, units = "in", bg = "white", scale = 0.8
)
  