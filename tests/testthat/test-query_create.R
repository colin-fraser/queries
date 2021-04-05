test_that("query_create works", {
  # create temp query
  tf <- tempdir()
  query_create("123", "Hello!", param_names = c("A", "B"), path = tf, open = F)
  tq <- fs::path(tf, "123.sql")
  readr::write_file("\n{A} {B}", tq, append = TRUE)

  # file exists
  expect_true(fs::file_exists(tq))

  # query sub works
  expect_equal(query_substitute(query_load(tq), A = "a", B = "b"), "a b")
  fs::dir_delete(tf)
})
