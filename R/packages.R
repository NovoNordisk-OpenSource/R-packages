
get_package <- function(pkg){
  
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

read_packages <- function(yaml = here::here("_packages.yml")) {
  yaml |> 
    yaml::read_yaml() |> 
    purrr::pluck("packages") |>
    lapply(get_package) |> 
    lapply(\(x) purrr::discard(.x = x, .p = is.null)) |> 
    lapply(data.frame) |> 
    dplyr::bind_rows() |> 
    tibble::as_tibble()
}

write_packages <- function(x) {
  
}