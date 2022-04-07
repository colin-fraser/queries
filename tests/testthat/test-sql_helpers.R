test_that("comma_join works", {
  expect_equal(comma_join("a"), "a")
  expect_equal(comma_join(c("a", "b")), "a, b")
  expect_equal(
    comma_join(c("a", "b"), leading_comma = TRUE, trailing_comma = TRUE, quote = TRUE),
    ", 'a', 'b',"
  )
  expect_equal(comma_join(NULL, TRUE, TRUE, TRUE), "")
  expect_equal(comma_join(c(avg_sales = 'AVG(sales)', 'country')),
               'AVG(sales) as avg_sales, country')
})

test_that("blank_if_null works", {
  expect_equal(blank_if_null("a"), "a")
  expect_equal(blank_if_null(NULL), "")
})

test_that("named_vec_to_cols works", {
  expect_equal(named_vec_to_cols(c(a = "A")), "A as a")
  expect_equal(named_vec_to_cols(c(a = "A", b = "B")),
                                 "A as a,\nB as b")
})

test_that("names_to_as", {
  expect_equal(names_to_as(c(a = "A")), "A as a")
  expect_equal(names_to_as(c(a = 'A', 'B')), c("A as a", "B"))
})

test_that("and_join works", {
  expect_equal(and_join(NULL), "")
  expect_equal(and_join("A"), "A")
  expect_equal(and_join(c("A", "B")), "A and\nB")
  expect_equal(and_join(c("A", "B"), leading_and = TRUE),
               "and\nA and\nB")
  expect_equal(and_join(c("A", "B"), trailing_and = TRUE),
               "A and\nB and\n")
  expect_equal(and_join(c("A", "B"), leading_and = TRUE, trailing_and = TRUE),
               "and\nA and\nB and\n")
})