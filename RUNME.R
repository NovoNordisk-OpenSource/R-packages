# Load utility R functions

list.files(path = "R", full.names = TRUE) |>
  purrr::walk(source)

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

pkg_template <- here::here("packages/template.qmd") |>
  readLines() 

for (pkg in packages) {
  out <- pkg |>
    with(glue::glue("packages/{repo$name}/index.qmd")) |>
    here::here()

  dir.create(dirname(out))

  pkg_template |>
    whisker::whisker.render(data = pkg, strict = FALSE) |>
    writeLines(out)
}
