# qt_basic

    Code
      qt_basic(select_cols = c("date", sales = "avg(sales)"), table_name = "all_sales")
    Output
      SELECT date, avg(sales) as sales
      FROM all_sales

---

    Code
      qt_basic(select_cols = c("date", sales = "avg(sales)"), table_name = "all_sales",
      where = c("sales >= 20", "date >= '2022-01-01'"), group_by = "country",
      order_by = "country", limit = 200)
    Output
      SELECT date, avg(sales) as sales
      FROM all_sales
      WHERE sales >= 20 and
      date >= '2022-01-01'
      GROUP BY country
      ORDER BY country
      LIMIT 200

# qt_rollup

    Code
      qt_rollup(c(order_date = "date", "country"), (sales <- "sum(sales)"),
      "sales_cube")
    Output
      SELECT 
      date as order_date, country,
      sum(sales)
      FROM sales_cube
      
      GROUP BY date, country
      ORDER BY date, country

---

    Code
      qt_rollup(c(order_date = "date", "country"), c(sales = "sum(sales)", avg_sales = "avg(sales)"),
      "sales_cube", where = c("date>=2020", "country in ('US', 'CA')"))
    Output
      SELECT 
      date as order_date, country,
      sum(sales) as sales, avg(sales) as avg_sales
      FROM sales_cube
      WHERE date>=2020 and
      country in ('US', 'CA')
      GROUP BY date, country
      ORDER BY date, country

