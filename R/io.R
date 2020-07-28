#' Returns the default query location
#'
#' @description First checks for a queries_location option.
#' If that's not there, defualts to ~/.queries
#'
#' @return default query location as a character
#' @export
#'
queries_location <- function() {
  if (!is.null(getOption("queries_location"))) {
    return(getOption("queries_location"))
  }

  default_fp <- fs::path(fs::path_home(), ".queries")
  if (fs::dir_exists(default_fp)) {
    return(default_fp)
  } else {
    stop(glue::glue("Default path {default_fp} does not exist. "),
    "Create it or choose a different path with\n",
    "options(queries_location='<PATH/TO/QUERIES>').")

  }
}

#' List the available queries
#'
#' @param location the directory to look in
#'
#' @return A tibble of queries
#' @export
#'
list_queries <- function(location = queries_location()) {
  fs::dir_ls(location, glob = "*.sql") %>%
    purrr::map(query_from_file) %>%
    purrr::map_df(~ tibble::tibble(
      name = .x$name, description = .x$description,
      params = list(.x$params), template = .x$template
    ))
}

#' Build a query object from a length-1 character vector
#'
#' @param s character containing query
#'
#' @return convert string into query object
#' @export
#' @importFrom rlang .data
query_from_string <- function(s) {
  query_lines <- readr::read_lines(s)
  first_blank <- which(query_lines == "")[1]
  q <- gsub("-- *", "", query_lines[1:(first_blank - 1)]) %>%
    paste(collapse = "\n") %>%
    yaml::yaml.load()
  q$template <- paste(query_lines, collapse = "\n")

  class(q) <- "query_template"

  q
}

query_from_file <- function(file) {
  query_from_string(readr::read_file(file))
}


print.query_template <- function(qt) {
  cat(qt$template)
}

#' Load a query from file
#'
#' @param query_name name of the query
#' @param location location of the query
#'
#' @return loaded query
#' @export
#'
load_query <- function(query_name, location = queries_location()) {
  file <- fs::path(location, paste0(query_name, ".sql"))
  query_from_file(file)
}

#' Opens a query file in the editor
#'
#' @param query_name the name of the query
#' @param location the query directory
#'
#' @importFrom rstudioapi navigateToFile
#'
open_query <- function(query_name, location = queries_location()) {
  file <- fs::path(location, paste0(query_name, ".sql"))
  rstudioapi::navigateToFile(file)
}

#' Create a query file
#'
#' @param name name of the query
#' @param description description
#' @param params parameters for the query
#' @param body the select statement
#' @param location where to save?
#'
#' @return NULL
#'
new_query <- function(name, description = NULL, params = NULL,
                      body = NULL, location = queries_location()) {
  header <- paste("--", readr::read_lines(yaml::as.yaml(list(
    name = name, description = description,
    params = params
  ))), collapse = '\n')

  if (is.null(body)) {
    body <- '-- Body:'
  }

  out <- paste(header, body, sep = '\n\n')
  save_to <- fs::path(location, paste0(name, '.sql'))
  readr::write_file(out, path = save_to)

  if (interactive()) {
    rstudioapi::navigateToFile(save_to)
  }
}
