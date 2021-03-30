#' Returns the default query location
#'
#' @description First checks for a queries_location option.
#' If that's not there, defualts to ~/.queries
#'
#' @return default query location as a character
#' @export
#'
queries_default_location <- function() {
  if (!is.null(getOption("default_queries_location"))) {
    return(getOption("default_queries_location"))
  }

  default_fp <- fs::path(fs::path_home(), ".queries")
  if (fs::dir_exists(default_fp)) {
    return(default_fp)
  } else {
    stop(
      glue::glue("Default path {default_fp} does not exist. "),
      "Create it or choose a different path with\n",
      "options(queries_location='<PATH/TO/QUERIES>')."
    )
  }
}

#' List the available queries
#'
#' @param location the directory to look in
#'
#' @return A tibble of queries
#' @export
#'
queries_list <- function(location = queries_default_location()) {
  filepaths <- fs::dir_ls(location, glob = "*.sql")
  filepaths %>%
    purrr::map(~ list(path = .x, query = query_from_file(.x))) %>%
    purrr::map_df(~ tibble::tibble(
      name = stringr::str_extract(fs::path_file(.x$path), "(-|\\w)+"),
      path = .x$path,
      description = .x$query$description,
      params = list(.x$query$params), template = .x$query$template
    ))
}

#' Build a query object from a length-1 character vector
#'
#' @param s character containing query
#' @param include_header if true, the header will be included in the sql query
#'
#' @return convert string into query object
#' @export
#' @importFrom rlang .data
query_from_string <- function(s, include_header = FALSE) {
  parts <- separate_head_body(s)
  qry <- yaml::yaml.load(parts$head, as.named.list = T)
  if (include_header) {
    qry$template <- s
  } else {
    qry$template <- parts$body
  }
  qry$head <- parts$head
  class(qry) <- "query_template"

  qry
}

separate_head_body <- function(s) {
  query_lines <- readr::read_lines(s)
  header_end <- which(substr(query_lines, 1, 2) != "--")[1]

  head <- gsub("-- ", "", query_lines[1:(header_end - 1)]) %>%
    paste(collapse = "\n")
  body <- trimws(paste(query_lines[header_end:length(query_lines)], collapse = '\n'),
                 whitespace = '\n')

  return(list(head = head, body = body))
}

query_from_file <- function(file, include_header = FALSE) {
  query_from_string(readr::read_file(file), include_header)
}


#' Print query
#'
#' @param x a query of time query_template
#' @param ... ignored
#'
#' @return NULL
#' @export
#'
print.query_template <- function(x, ...) {
  cat(x$template)
}

#' Load a query from file
#'
#' @param query_name name of the query. This can also be a path, in which
#' case query_location is ignored.
#' @param query_location location of the query.
#' @param include_header if true, the header will be included in the sql query
#'
#' @return loaded query
#' @export
#'
query_load <- function(query_name, query_location = queries_default_location(),
                       include_header = FALSE) {
  if (fs::file_exists(query_name)) {
    return(query_from_file(query_name, include_header))
  }
  if (fs::file_exists(fs::path("sql", query_name))) {
    return(query_from_file(fs::path("sql", query_name), include_header))
  }
  if (fs::file_exists(fs::path("sql", query_name, ext = "sql"))) {
    return(query_from_file(fs::path("sql", query_name, ext = "sql"),
                           include_header))
  }


  file <- fs::path(query_location, paste0(query_name, ".sql"))
  query_from_file(file, include_header)
}


#' Print the header of a query
#'
#' @param x a query
#' @param ... ignored
#'
#' @return silently returns the head
#' @export
#' @importFrom utils head
#'
head.query_template <- function(x, ...) {
  h <- x$head
  cat(h)
  invisible(h)
}

#' Sets the default queries location
#'
#' @param path file path to a directory with .sql files
#'
#' @export
#'
query_set_default_location <- function(path) {
  options(default_queries_location = path)
}

#' Replace parameters in query
#'
#' @param qry a query object or name of a query
#' @param query_location the location of the query
#' @param append_params should the parameter values be appended to the
#' query in a comment?
#' @param ... parameter values
#' @param include_header if true, the header will be included in the sql query
#'
#' @return a formatted query
#' @export
#'
query_substitute <- function(qry, ..., query_location = queries_default_location(),
                             include_header = FALSE, append_params = FALSE) {
  if (class(qry) == "character") {
    query <- query_load(qry, query_location, include_header)
  } else if (class(qry) == "query_template") {
    query <- qry
  }
  else {
    stop("qry must be either a character indicating a saved query template or an object if type query_template")
  }

  glue_env <- env_from_params(query$params, ...)

  out <- glue::glue(query$template, .envir = rlang::env(glue_env))
  if (append_params) {
    param_note <- paste("--", readr::read_lines(yaml::as.yaml(as.list(glue_env))),
                        collapse = "\n"
    )
    out <- paste(out, param_note, sep = "\n\n")
  }

  out
}

query_view <- function(location = queries_default_location(),
                       starts_with = NULL) {
  location %>%
    fs::dir_ls() %>%
    purrr::map(function(x) {
      filename <- x
      query <- stringr::str_wrap(head(query_from_file(x)), indent = 2, exdent = 2)
      paste(filename, query, sep = "\n")
    })
}



env_from_params <- function(params, ...) {
  param_list <- list(...)

  missing_with_no_default <- params %>%
    purrr::discard(~ !is.null(.x$default)) %>%
    purrr::discard(~ .x$name %in% names(param_list)) %>%
    purrr::map_chr("name")

  if (length(missing_with_no_default) > 0) {
    stop(paste0(
      "Missing params with no default:\n",
      paste0("- ", missing_with_no_default, collapse = "\n")
    ))
  }

  user_specified <- params %>%
    purrr::map_if(~ .x$name %in% names(param_list), ~ list(param_list[[.x$name]]) %>% rlang::set_names(.x$name)) %>%
    purrr::map_if(~ !is.null(.x$default), ~ list(.x$default) %>% rlang::set_names(.x$name)) %>%
    purrr::flatten() %>%
    rlang::as_environment(parent = rlang::env_parent())

  return(user_specified)
}


#' Turn a parameterized query into a function
#'
#' @param x a query loaded with query_load
#' @param include_header include the header in the query output
#' @param append_params append parameter values in the query
#'
#' @return a function whose arguments are the query parameters
#' @export
#'
query_as_function <- function(x, include_header = FALSE, append_params = FALSE) {
  fpar <- as.pairlist(x$params %>% purrr::map(~ list(.x$default) %>% rlang::set_names(.x$name)) %>% purrr::flatten())
  f <- function() {
    args <- as.list(environment())
    null_args <- args %>%
      purrr::keep(is.null) %>%
      names
    if (length(null_args) > 0) {
      stop("Missing params with no default:\n",
           paste0("- ", null_args, collapse = '\n'))
    }
    do.call(query_substitute, c(list(qry = x), args,
                                list(include_header = include_header,
                                     append_params = append_params)))
  }
  formals(f) <- fpar
  f
}

#' Create a parameterized query
#'
#' @param filename what do you want the query to be called
#' @param query_name the name at the top of the query description
#' @param param_names names of query parameters
#' @param path where to save the query
#' @param open if true, the saved file opens in rstudio
#'
#' @return invisibly
#' @export
#'
query_create <- function(filename, query_name = "",
                         param_names = NULL,
                         path = queries_default_location(),
                         open = TRUE) {

  q <- glue::glue(
    "-- name: {query_name}\n-- params:\n{paste('-- - name:', param_names, collapse = '\n')}"
  )
  outpath <- fs::path_ext_set(fs::path(path, filename), 'sql')
  f <- readr::write_file(q, outpath)
  if (rstudioapi::isAvailable() & open) {
    rstudioapi::navigateToFile(outpath)
  }
  invisible(f)
}
