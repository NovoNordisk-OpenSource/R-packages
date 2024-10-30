# Utility function to retrieve all required information from a package
# hosted on GitHub. Identified by pkg = {organisation}/{repository}.

get_package <- function(pkg) {
  repo <- gh::gh("GET /repos/{pkg}", pkg = pkg$name)

  desc <- gh::gh("GET /repos/{pkg}/contents/DESCRIPTION", pkg = pkg$name)

  desc_file <- withr::local_tempfile()

  desc$content |>
    base64enc::base64decode() |>
    rawToChar() |>
    writeLines(desc_file)

  desc_fields <- desc_file |>
    desc::desc_fields() |>
    rlang::set_names() |>
    purrr::map(desc::desc_get_field, file = desc_file)


  logo <- tryCatch(
    gh::gh("GET /repos/{pkg}/contents/man/figures", pkg = pkg$name) |>
      purrr::map_chr("download_url") |>
      stringr::str_subset("logo\\.(svg|png)$") |>
      tail(1),
    error = \(e) return(NULL)
  )

  list(
    pkg = pkg,
    repo = purrr::keep(.x = repo, .p = \(x) length(x) == 1),
    desc = desc_fields,
    logo = logo
  )
}
