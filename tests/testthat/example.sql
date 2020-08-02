-- name: Sales by group
-- description: an example query. Compute metrics grouped by dimensions. If
--  the description is really long you can just continue on the next line with a
--  single-space indent.
-- params:
--   - dimensions: character vector of columns to group by
--   - metrics: character vector of columns to compute

SELECT {comma_join(metrics, trailing_comma = TRUE)} {comma_join(dimensions)}
FROM Customers
GROUP BY {comma_join(dimensions)}
