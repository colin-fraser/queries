test_that("query_create works", {
  tf <- fs::file_temp()
  query_create(tf, "Hello!", param_names = c("A", "B"), open = F)
  readr::write_file("\n{A} {B}", tf, append=TRUE) # write something to the new query

  # file exists
  expect_true(fs::file_exists(tf))

  # query sub works
  expect_equal(query_substitute(query_load(tf), A = "a", B = "b"), "a b")
  fs::file_delete(tf)
})

