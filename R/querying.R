#' Replace parameters in query
#'
#' @param q a query object or name of a query
#' @param query_location the location of the query
#' @param append_params should the parameter values be appended to the
#' query in a comment?
#' @param ... parameter values
#'
#' @return a formatted query
#' @export
#'

query_substitute <- function(q, ..., query_location = queries_location(), append_params = TRUE) {
  if (class(q) == "character") {
    query <- load_query(query_name = q, query_location)
  } else {
    query <- q
  }
  missing_params <- setdiff(names(query$params), names(list(...)))
  if (length(missing_params) > 0) {
    stop(glue::glue("{query$name} requires params: {paste(missing_params, collapse = ', ')}"))
  }

  out <- glue::glue(query$template, .envir = rlang::env(...))
  if (append_params) {
    param_note <- paste("--", readr::read_lines(yaml::as.yaml(list(...))),
      collapse = "\n"
    )
    out <- paste(out, param_note, sep = "\n\n")
  }

  out
}

f <- function(...) {
  print("hello")
  return(4)
}
