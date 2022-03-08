#' Join a character vector together with commas
#'
#' @param s a character vector to be joined
#' @param leading_comma should a leading comma be inserted?
#' @param trailing_comma should a trailing comma be inserted?
#' @param quote should the output be quoted?
#'
#' @return a length-1 character vector
#' @export
#' 
#' @examples 
#' 
#'
comma_join <- function(s, leading_comma = FALSE, trailing_comma = FALSE,
                       quote = FALSE) {
  if (is.null(s)) {
    return("")
  }
  if (quote) {
    s <- paste0("'", s, "'")
  }
  out <- paste(paste(s, collapse = ", "))
  if (leading_comma) {
    out <- paste(",", out)
  }
  if (trailing_comma) {
    out <- paste0(out, ",")
  }
  return(out)
}

#' Insert blank character if a variable is null
#'
#' @param s String to insert, or blank if null
#'
#' This is useful for specifying e.g. a column list that may or may not
#' be part of a query.
#'
#' @return a character vector
#' @export
#'
blank_if_null <- function(s) {
  if (is.null(s)) {
    return("")
  } else {
    return(s)
  }
}

