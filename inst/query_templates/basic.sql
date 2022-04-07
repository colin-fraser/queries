-- name: Basic query
-- params:
-- - name: select_cols
--   description: columns to select
-- - name: table_name
--   description: table to select from
-- - name: where
--   description: a vector of `where` constraints
--   default: "NULL"
-- - name: group_by
--   description: columns to group by
--   default: NULL
-- - name: order_by
--   description: columns to order by
--   default: NULL
-- - name: limit
--   description: number of rows to return
--   default: NULL

SELECT {comma_join(select_cols)}
FROM {table_name}
{blank_if_null(where, paste("WHERE", and_join(where)))}
{blank_if_null(group_by, paste("GROUP BY", and_join(group_by)))}
{blank_if_null(order_by, paste("ORDER BY", and_join(order_by)))}
{blank_if_null(limit, paste("LIMIT", limit))}
