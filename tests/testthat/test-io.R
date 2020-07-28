test_that("reading query", {
  expect_s3_class(load_query("example", "."), "query_template")
})
