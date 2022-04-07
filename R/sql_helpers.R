#' Join a character vector together with commas
#'
#' @param s a character vector to be joined
#' @param leading_comma should a leading comma be inserted?
#' @param trailing_comma should a trailing comma be inserted?
#' @param quote should the output be quoted? Default false.
#' @param names_to_as if this is true and s is named, the names will
#'   be used as column identifiers. See examples. Defaults to true.
#'
#' @return a length-1 character vector
#' @export
#' 
#' @examples 
#' comma_join(letters)
#' comma_join(letters, leading_comma = TRUE)
#' comma_join(letters, quote = TRUE)
#' 
#' # named input
#' comma_join(c(avg_sales = "avg(sales)", "country"), names_to_as = TRUE)
#'
comma_join <- function(s, leading_comma = FALSE, trailing_comma = FALSE,
                       quote = FALSE, names_to_as = TRUE) {
  if (is.null(s)) {
    return("")
  }
  if (names_to_as & !is.null(names(s))) {
    if (quote) {
      warning("Both quote and names_to_as are TRUE. You probably don't want this.")
    }
    s <- names_to_as(s)
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

names_to_as <- function(s) {
  names <- names(s)
  ifelse(names != "", paste(s, 'as', names), s)
}

#' Insert blank character if a variable is null
#'
#' @param s String to insert, or blank if null
#' @param output What to print if s is not null
#'
#' This is useful for specifying e.g. a column list that may or may not
#' be part of a query.
#'
#' @return a character vector
#' @export
#'
blank_if_null <- function(s, output = s) {
  if (is.null(s)) {
    return("")
  }
  
  output
}


#' Join a vector with 'AND'
#'
#' @param s a character vector
#' @param leading_and logical indicating whether 'and' should be pre-pended
#' @param trailing_and logical indicating whether 'and' should be post-pended
#'
#' @return a string with the elements of s joined by 'AND'
#' @export
#'
#' @examples
#' and_join("")
#' and_join("country = 'US'")
#' and_join(c("country = 'US'", "type = 1"))
and_join <- function(s, leading_and = FALSE, trailing_and = FALSE) {
  if (is.null(s)) {
    return("")
  }
  prefix <- {if (leading_and) 'and\n' else ''}
  suffix <- {if (trailing_and) ' and\n' else ''}
  paste0(prefix, paste0(s, collapse = ' and\n'), suffix)
}

