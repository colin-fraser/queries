# Query Templates
# This includes built-in queries that are handy to have

load_template <- function(filename) {
  query_load(system.file("query_templates", filename, package = "queries"))
}

qt_sub <- function(name, ...) {
  args <- list(...)
  query <- load_template(name)
  args[['qry']] <- query
  do.call(query_substitute, args)
}

#' The most basic query pattern
#'
#' @param select_cols vector of columns to select. 
#'   Names will be used as identifiers, if supplied
#' @param table_name table to select from
#' @param where vector of constraints to be joined with 'and'
#' @param group_by vector of columns to group by
#' @param order_by vector of columns to order by
#' @param limit number of rows to return
#'
#' @return a filled query
#' @export
#'
#' @examples
#' qt_basic(
#'    select_cols = c(Date = "saledate", "Country", Sales = "SUM(sales)"), 
#'    table = "all_sales",
#'    where = c("country in ('US', 'CA')", "year = 2020"),
#'    group_by = c("saledate", "country"),
#'    order_by = "Date")
qt_basic <- function(select_cols, table_name, where = NULL, group_by = NULL, 
                     order_by = NULL, limit = NULL) {
  qt_sub("basic.sql", select_cols = select_cols, table_name = table_name,
         where = where, group_by = group_by, order_by = order_by, limit = limit)
}


#' Dimensional rollup query pattern
#' 
#' @description 
#' Produces a query that performs a rollup operation on a cube-like table.
#'
#' @param dimensions dimensions to roll up by
#' @param metrics aggregations that will be performed on each dimension
#' @param table_name table to query
#' @param where constraints
#' @param order_by order by
#'
#' @return a query
#' @export
#'
#' @examples
#' qt_rollup(
#'   c(order_date = "date", "country"), 
#'   c(sales = "sum(sales)"), 
#'   'metrics_table'
#'   )
qt_rollup <- function(dimensions, metrics, table_name, where = NULL,
                      order_by = dimensions) {
  qt_sub("dimensional_rollup.sql", dimensions = dimensions, metrics = metrics,
         table_name = table_name, where = where, order_by = order_by)
}

dimension_names <- function(x, prefix = 'dim_') {
  f <- function(x, y) if (length(x) == 0 || is.null(x) || nchar(x) == 0) y else x
  names <- names(x)
  sapply(1:length(x), function(x) f(names[x], paste0(prefix, x)))
}
