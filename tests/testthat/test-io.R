test_that("reading query", {
  expect_s3_class(query_load("example_with_defaults", "."), "query_template")
  expect_s3_class(query_load("example_with_defaults.sql"), "query_template")
  fs::dir_create("sql")
  fs::file_copy("example_with_defaults.sql", "sql/example_with_defaults_copy.sql")
  expect_s3_class(query_load("example_with_defaults_copy.sql"), "query_template")
  fs::dir_delete("sql")
})

test_that("query_location works", {
  options(default_queries_location = "abc")
  expect_equal(queries_default_location(), "abc")
  options(default_queries_location = NULL)
})
