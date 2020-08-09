-- name: Sales by group
-- description: Computes metrics grouped by dimensions. If the description is
--  really long you can just continue on the next line with a single-space
--  indent.
-- params:
--   - name: dimensions
--     description: dimensions to group by
--     default: country
--   - name: metrics
--     description: metrics to aggregate by dimension

SELECT {comma_join(metrics, trailing_comma = TRUE)} {comma_join(dimensions)}
FROM Customers
GROUP BY {comma_join(dimensions)}
