test_that("missing defaults causes errors", {
  qry <- query_load("example_with_defaults.sql")
  expect_error(query_substitute(qry))
  expect_error(query_substitute(qry, dimensions = 1))

})

test_that("inserting params works", {
          expect_equal(
            query_substitute("example_with_defaults.sql", metrics = 'A',
                             dimensions = 'B', include_header = TRUE,
                             append_params = FALSE),
            "-- name: Sales by group\n-- description: Computes metrics grouped by dimensions. If the description is\n--  really long you can just continue on the next line with a single-space\n--  indent.\n-- params:\n--   - name: dimensions\n--     description: dimensions to group by\n--     default: country\n--   - name: metrics\n--     description: metrics to aggregate by dimension\n\nSELECT A, B\nFROM Customers\nGROUP BY B")
          })

test_that("default params works", {
  expect_equal(
    query_substitute("example_with_defaults.sql", metrics = 'A',
                     include_header = TRUE, append_params = FALSE),
    "-- name: Sales by group\n-- description: Computes metrics grouped by dimensions. If the description is\n--  really long you can just continue on the next line with a single-space\n--  indent.\n-- params:\n--   - name: dimensions\n--     description: dimensions to group by\n--     default: country\n--   - name: metrics\n--     description: metrics to aggregate by dimension\n\nSELECT A, country\nFROM Customers\nGROUP BY country")
})

test_that("append_params works", {

  expect_equal(
    query_substitute("example_with_defaults.sql", metrics = 'A',
                     dimensions = 'B', include_header = TRUE,
                     append_params = TRUE),
    "-- name: Sales by group\n-- description: Computes metrics grouped by dimensions. If the description is\n--  really long you can just continue on the next line with a single-space\n--  indent.\n-- params:\n--   - name: dimensions\n--     description: dimensions to group by\n--     default: country\n--   - name: metrics\n--     description: metrics to aggregate by dimension\n\nSELECT A, B\nFROM Customers\nGROUP BY B\n\n-- metrics: A\n-- dimensions: B")
})
