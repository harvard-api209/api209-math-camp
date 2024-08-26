suppressPackageStartupMessages(library(tidyverse))
library(kjhslides)

# Using decktape
html_to_pdf <- function(slide_path) {
  outdir_path <- stringr::str_replace(slide_path, "/slides.*\\.html$", "")

  kjhslides::kjh_decktape_one_slide(
    infile = slide_path,
    outdir = outdir_path
  )

  fl = list.files(
    here_rel("2024/weeks"), 
    pattern = "^slides.*\\.qmd$", 
    full.names = TRUE, 
    recursive = TRUE
  )

  paste0("docs/", stringr::str_replace(fl, "qmd", "html"))
  return(paste0(tools::file_path_sans_ext(slide_path), ".pdf"))
}

# Modify slides function to include all the slides.qmd in the 2024 folder
slides <- tibble::tibble(
    path = list.files(here_rel("2024/weeks"), pattern = "slides\\.qmd", full.names = TRUE, recursive = TRUE)
  ) |>
  mutate(
    name = tools::file_path_sans_ext(basename(path)),
    sym = syms(janitor::make_clean_names(paste0("qmd_", name))),
    sym_html = syms(janitor::make_clean_names(paste0("html_", name))),
    sym_pdf = syms(janitor::make_clean_names(paste0("pdf_", name)))
  )

# Build the slides
build_slides <- list(
  tar_eval(
    tar_files_input(target_name, qmd_file),
    values = list(
      target_name = slides$sym,
      qmd_file = slides$path
    )
  ),
  
  tar_eval(
    tar_target(target_name, quarto::quarto_render(qmd_file), format = "file"),
    values = list(
      target_name = slides$sym_html,
      qmd_file = slides$sym
    )
  )  
)

