-- name: example
-- description: an example query. Try running with group_by set to country
-- params:
--   - group_by

SELECT COUNT(CustomerID) {comma_join_if_not_null(group_by)}
FROM Customers
GROUP BY {comma_join_if_not_null(group_by, leading_comma = FALSE)}
