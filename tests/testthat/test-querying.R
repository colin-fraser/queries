test_that("params work", {
  q <- load_query("example", location = ".")
  expect_error(query_substitute(q))
  expect_error(query_substitute(q, hello = 1))
  expect_type(query_substitute(q, group_by = "Country"), "character")
})
