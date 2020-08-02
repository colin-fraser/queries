test_that("comma_join works", {
  expect_equal(comma_join("a"), "a")
  expect_equal(comma_join(c("a", "b")), "a, b")
  expect_equal(
    comma_join(c("a", "b"), leading_comma = TRUE, trailing_comma = TRUE, quote = TRUE),
    ", 'a', 'b',"
  )
  expect_equal(comma_join(NULL, TRUE, TRUE, TRUE), "")
})

test_that("blank_if_null works", {
  expect_equal(blank_if_null("a"), "a")
  expect_equal(blank_if_null(NULL), "")
})
