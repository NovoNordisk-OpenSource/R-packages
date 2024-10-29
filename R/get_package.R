# Utility function to retrieve all required information from a package
# hosted on GitHub. Identified by pkg = {organisation}/{repository}.

get_package <- function(pkg) {
  repo <- gh::gh("GET /repos/{pkg}", pkg = pkg)

  desc <- gh::gh("GET /repos/{pkg}/contents/DESCRIPTION", pkg = pkg)

  desc_file <- withr::local_tempfile()

  desc$content |>
    base64enc::base64decode() |>
    rawToChar() |>
    writeLines(desc_file)

  logo <- gh::gh("GET /repos/{pkg}/contents/man/figures", pkg = pkg) |>
    purrr::map_chr("download_url") |>
    stringr::str_subset("logo\\.(svg|png)$") |>
    tail(1)

  repo[c("name", "url", "html_url", "description")] |>
    c(
      title = desc::desc_get_field("Title", file = desc_file),
      version = desc::desc_get_version(desc_file) |>
        paste(collapse = "."),
      logo = logo
    )
}
