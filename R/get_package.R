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

  logo <- tryCatch(
    gh::gh("GET /repos/{pkg}/contents/man/figures", pkg = pkg$name) |>
      purrr::map_chr("download_url") |>
      stringr::str_subset("logo\\.(svg|png)$") |>
      tail(1),
    
    error = \(e) return(NULL) 
  )

  c(
    purrr::keep(.x = repo, .p = \(x) length(x) == 1),
    
    pkg[!names(pkg) == "name"],
    
    title = desc::desc_get_field("Title", file = desc_file),
    version = desc::desc_get_version(desc_file) |>
      paste(collapse = "."),
    logo = logo
  )
}
