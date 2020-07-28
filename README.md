
# Keep a library of parameterized queries

<!-- badges: start -->
<!-- badges: end -->

I have a number of parameterized SQL queries that I run regularly. The purpose of this package is to keep canonical versions of those queries with standardized parameterization. It uses the `glue` package to replace parameters.

## Usage

The package reads modified sql files that have metadata stored in yaml format in a comment block at the top. Here's a simple example: start with a file like this saved as `/path/to/queries/sales_by_group.sql`.

```
-- name: sales_by_group
-- description: tallies up sales by group
-- params:
--   - group_by

SELECT sum(amount) amount, 
{comma_join(group_by, leading_comma = FALSE, trailing_comma = FALSE)}

FROM sales
GROUP BY {comma_join(group_by, leading_comma = FALSE, trailing_comma = FALSE)}
```

Having set `options(queries_location = '/path/to/queries'), I can run

```
q <- load_query('sales_by_group')
query_substitute(q, group_by = c("Country", "Segment"), append_params = F) %>% cat
# -- name: sales_by_group
# -- description: tallies up sales by group
# -- params:
# --   - group_by
# 
# SELECT sum(amount) amount, 
# 
# -- use R code in braces, referring to params defined in the header;
# Segment, Country
# 
# FROM sales
# GROUP BY Segment, Country
```

## Installation

Install with devtools:

``` r
devtools::install_github("colin-fraser/queries")
```
