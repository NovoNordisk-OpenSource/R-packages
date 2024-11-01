hexgrid <- function(packages) {
  
  hex_start <- '<ul id="hexGrid">'
  hex_end <- '</ul>'
  
  hex_divs <- vector(mode = "list", length(packages))
  
  for (i in seq_along(packages)) {
    
    pkginfo <- packages[[i]]
    
    hex_divs[[i]] <- c(
      '<li class="hex">\n',
      '  <div class="hexIn">\n',
      glue::glue('    <a class="hexLink" href="{pkginfo$repo$homepage}" target="_blank">\n'),
      glue::glue('      <img src="{pkginfo$logo}">\n'),
      glue::glue('      <h5>{pkginfo$desc$Package}</h5>\n'),
      glue::glue('      <p>{pkginfo$desc$Title}</p>\n'),
      '    </a>\n',
      '  </div>\n',
      '</li>\n'
    )
  }
  
  hex_out <- c(hex_start,hex_divs,hex_end) |> 
    unlist()
  
  return(hex_out)
  
}
