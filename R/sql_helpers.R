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
comma_join <- function(s, leading_comma = TRUE, trailing_comma = FALSE, quote = FALSE) {
  if (quote) {
    s <- shQuote(s)
  }
  out <- paste(paste(s, collapse = ", "))
  if (leading_comma) {
    out <- paste(",", out)
  }
  if (trailing_comma) {
    out <- paste(out, ",")
  }
  return(out)
}

#' Join a character vector
#'
#' @param s vector of items to join
#' @param leading_comma should a leading comma be inserted?
#' @param trailing_comma should a trailing comma be inserted?
#' @param quote should elements of the output be quoted?
#'
#' This is useful for specifying e.g. a column list that may or may not
#' be part of a query.
#'
#' @return a character vector
#' @export
#'
#' @examples
#' comma_join_if_not_null(NULL) # returns ""
#' comma_join_if_not_null(1:3, leading_comma = FALSE) # returns "1, 2, 3"
comma_join_if_not_null <- function(s, leading_comma = TRUE, trailing_comma = FALSE, quote = FALSE) {
  if (!is.null(s)) {
    return(comma_join(s, leading_comma = leading_comma, trailing_comma = trailing_comma, quote = quote))
  } else {
    return("")
  }
}

blank_if_null <- function(indicator, otherwise) {
  if (is.null(indicator)) {
    return("")
  } else {
    return(otherwise)
  }
}
