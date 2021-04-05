test_that("missing defaults causes errors", {
  qry <- query_load("example_with_defaults.sql")
  expect_error(query_substitute(qry))
  expect_error(query_substitute(qry, dimensions = 1))

})

test_that("inserting params works", {
  expected_q <- "-- name: Sales by group
-- description: Computes metrics grouped by dimensions. If the description is
--  really long you can just continue on the next line with a single-space
--  indent.
-- params:
--   - name: dimensions
--     description: dimensions to group by
--     default: country
--   - name: metrics
--     description: metrics to aggregate by dimension

SELECT A, B
FROM Customers
GROUP BY B"
          expect_equal(
            query_substitute("example_with_defaults.sql", metrics = 'A',
                             dimensions = 'B', include_header = TRUE,
                             append_params = FALSE),
            expected_q)
          })

test_that("default params works", {
expected_q <- "-- name: Sales by group
-- description: Computes metrics grouped by dimensions. If the description is
--  really long you can just continue on the next line with a single-space
--  indent.
-- params:
--   - name: dimensions
--     description: dimensions to group by
--     default: country
--   - name: metrics
--     description: metrics to aggregate by dimension

SELECT A, country
FROM Customers
GROUP BY country"
  expect_equal(
    query_substitute("example_with_defaults.sql", metrics = 'A',
                     include_header = TRUE, append_params = FALSE),
    expected_q)
})

test_that("append_params works", {
expected_q <- "-- name: Sales by group
-- description: Computes metrics grouped by dimensions. If the description is
--  really long you can just continue on the next line with a single-space
--  indent.
-- params:
--   - name: dimensions
--     description: dimensions to group by
--     default: country
--   - name: metrics
--     description: metrics to aggregate by dimension

SELECT A, B
FROM Customers
GROUP BY B

-- metrics: A
-- dimensions: B"
  expect_equal(
    query_substitute("example_with_defaults.sql", metrics = 'A',
                     dimensions = 'B', include_header = TRUE,
                     append_params = TRUE), expected_q
    )
})
