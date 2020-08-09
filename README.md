
# Keep a library of parameterized queries

<!-- badges: start -->
<!-- badges: end -->

I have a number of parameterized SQL queries that I run regularly. The purpose of this package is to keep canonical versions of those queries with standardized parameterization. It uses the `glue` package to replace parameters.

## Usage

The package reads modified sql files that have metadata stored in yaml format in a comment block at the top. Here's a simple example: start with a file like this saved as `/path/to/queries/sales_by_group.sql`.

```
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

```

Having set `options(default_queries_location = '/path/to/queries')`, I can run `

```
query_substitute("sales_by_group", metrics = c('sum(sales)', 'avg(sales)'), dimensions = 'country')
# SELECT sum(sales), avg(sales), country
# FROM Customers
# GROUP BY country
```

## Big picture usage

### Query Library

I use this in two ways. First, I have a library of queries stored in a repository—say `~/projects/path/to/queries`. These are canonical versions of parameterized queries that my team uses. In my .Rprofile, I have a line that sets the default query location to that path

`options(default_queries_location='~/projects/path/to/queries')`

Which contains files

- `sales_by_group.sql`
- `customer_list.sql`
- etc...

Whenever I need to run one of these queries, I build the query with

`q <- load_query('sales_by_group')`

If I don't remember all the parameters, I can view the header with `head`:

```
head(q)
# name: Sales by group
# description: Computes metrics grouped by dimensions. If the description is
#  really long you can just continue on the next line with a single-space
#  indent.
# params:
#   - name: dimensions
#     description: dimensions to group by
#     default: country
#   - name: metrics
#     description: metrics to aggregate by dimension
```

### R Projects
The other way that I use this is to store bespoke queries in a `/sql` directory in an R project. `load_query` will look for a `/sql` directory first, then check whether the `default_query_location` option is set up.

## Installation

Install with devtools:

``` r
devtools::install_github("colin-fraser/queries")
```
