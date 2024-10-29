# Create package pages

here::here("packages") |>
  list.dirs() |>
  setdiff(here::here("packages")) |>
  unlink(recursive = TRUE)

packages <- here::here("_packages.yml") |>
  yaml::read_yaml() |>
  purrr::pluck("packages") |>
  lapply(get_package) |>
  lapply(\(x) purrr::discard(.x = x, .p = is.null))

for (pkg in packages) {
  out <- pkg |>
    with(glue::glue("packages/{name}/index.qmd")) |>
    here::here()

  dir.create(dirname(out))

  here::here("packages/template.qmd") |>
    readLines() |>
    whisker::whisker.render(pkg) |>
    writeLines(out)
}

# Create webpage

quarto::quarto_render()
