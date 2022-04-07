-- name: Dimensional Rollup
-- description: This query is for rolling up on dimensional tables.
-- params:
-- - name: dimensions
--   description: dimensions to include
-- - name: metrics
--   description: aggregate metrics
-- - name: table_name
--   description: table to select from
-- - name: where
--   description: constraints
-- - name: order_by
--   description: columns to order by

SELECT 
{comma_join(dimensions)},
{comma_join(metrics)}
FROM {table_name}
{blank_if_null(where, paste("WHERE", and_join(where)))}
GROUP BY {comma_join(dimensions, names_to_as = FALSE)}
ORDER BY {comma_join(order_by, names_to_as = FALSE)}