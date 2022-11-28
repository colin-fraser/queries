local_edition(3)
test_that("qt_basic", {
  expect_error(qt_basic())
  expect_error(qt_basic(select_cols = "A"))
  expect_snapshot(
    qt_basic(
      select_cols = c("date", sales = "avg(sales)"),
      table_name = "all_sales"
    )
  )
  expect_snapshot(
    qt_basic(
      select_cols = c("date", sales = "avg(sales)"),
      table_name = "all_sales",
      where = c("sales >= 20", "date >= '2022-01-01'"),
      group_by = "country", order_by = "country", limit = 200
    )
  )
})

test_that("qt_rollup", {
  expect_snapshot(qt_rollup(
    c(order_date = "date", "country"),
    (sales <- "sum(sales)"), "sales_cube"
  ))
  expect_snapshot(qt_rollup(c(order_date = "date", "country"),
    c(sales = "sum(sales)", avg_sales = "avg(sales)"),
    "sales_cube",
    where = c("date>=2020", "country in ('US', 'CA')")
  ))
})

test_that("dimension_names", {
  expect_equal(dimension_names(c(a=1, b=2)), c('a','b'))
  expect_equal(dimension_names(1:2), c('dim_1', 'dim_2'))
  expect_equal(dimension_names(c(a = 1, 2, b = 3, 4)), c('a', 'dim_2', 'b', 'dim_4'))
  expect_equal(dimension_names(c(a = 1, 2, b = 3, 4), 'col_'), c('a', 'col_2', 'b', 'col_4'))
}
          
          )
