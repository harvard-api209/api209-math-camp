# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) 

class_number <- "API 209"
base_url     <- "https://harvard-api209.github.io/api209-math-camp"
page_suffix  <- ".html"
yaml_vars    <- yaml::read_yaml(here::here("_variables.yml"))

options(
  tidyverse.quiet = TRUE,
  dplyr.summarise.inform = FALSE
)

# Set target options:
tar_option_set(
  packages = c("tibble", "dplyr", "readr", "tidyverse"),
  format = "rds",
  workspace_on_error = TRUE
)

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.qmd).
# There's no way to get a relative path directly out of here::here(), but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}

# Sources
source("R/slide-things.R")
source("R/tar_slides.R")
source("R/tar_calendar.R")

# Replace the target list below with your own:
list(
  ## Build quarto site ----
  tar_quarto(site, path = ".", quiet = FALSE),

  ## Slides ----
  # Render all the slides and make PDFs
  # build_slides,
  
  tar_files(rendered_slides, {
    # Force dependencies
    site
    fl = list.files(
      here_rel("2024/weeks"), 
      pattern = "^slides.*\\.qmd$", 
      full.names = TRUE, 
      recursive = TRUE
    )

    paste0("docs/", stringr::str_replace(fl, "qmd", "html"))
  }),

  tar_target(quarto_pdfs, {
    html_to_pdf(rendered_slides)
  }, pattern = map(rendered_slides), format = "file"),  
  

  ## Class schedule calendar ----
  tar_target(schedule_file, here_rel("data", "schedule.csv"), format = "file"),
  tar_target(schedule_page_data, build_schedule_for_page(schedule_file)),
  tar_target(schedule_ical_data, build_ical(schedule_file, base_url,
                                            page_suffix, class_number)),
  tar_target(
    schedule_ical_file,
      save_ical(
        schedule_ical_data,
        here_rel("files", "schedule.ics"
      )
    ),
    format = "file"
  )
)
