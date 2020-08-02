test_that("reading query", {
  expect_s3_class(load_query("example", "."), "query_template")
  expect_s3_class(load_query("example.sql"), "query_template")
})

test_that("query_location works", {
  fs::dir_create("sql")
  expect_equal(queries_location(), "sql")
  fs::dir_delete("sql")

  options(default_queries_location = "abc")
  expect_equal(queries_location(), "abc")
  options(default_queries_location = NULL)
})
