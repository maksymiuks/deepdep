# TODO: document this functions

DB <- function(api, head = 1e6, tail = head) {
  
  ret <- paste0("http://crandb.r-pkg.org", "/", api)
  ret <- httr::GET(ret)
  ret <- httr::content(ret, as = "text", encoding = "UTF-8")
  ret <- jsonlite::prettify(ret)
  ret <- skip_lines(ret, head = head, tail = tail)
  
  ret
}

skip_lines <- function(text, head = 1e6, tail = 1e6) {
  
  text <- strsplit(text, "\n")[[1]]
  
  tail <- min(tail, max(0, length(text) - head))
  
  skip_text <- if (length(text) > head + tail) {
    paste("\n... not showing", length(text) - head - tail, "lines ...\n")
  } else {
    character()
  }
  
  ret <- c(head(text, head), skip_text, tail(text, tail))
  ret <- paste(ret, collapse = "\n")
  ret
}

check_package_name <- function(package, bioc, local) {
  if (local) {
    if (!is_available(package, local = TRUE)) stop(paste0(package, " is not installed"))
  }
  else if (!is_available(package, bioc)) {
    if (bioc) stop(paste0(package, " is not available neither on CRAN nor on Bioconductor"))
    else stop(paste0(package, " is not available on CRAN"))
  }
}