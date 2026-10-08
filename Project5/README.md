# Mini Project 05 – Advanced SQL: Window Functions

SQL script: `mini_project_05.sql` | Output screenshots: `screenshots/`

## Tables Used

`products`, `orderdetails`, `payments`

## Problems Solved

| Problem | Window Function Used |
|---|---|
| Product ranking within product lines | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` |
| Cumulative payment values | `SUM() OVER (ORDER BY ...)` |
| Running total per customer | `SUM() OVER (PARTITION BY ... ORDER BY ...)` |
| Top 2 products per line | `DENSE_RANK()` inside a CTE, filtered in the outer query |
| Month-over-month comparison | `LAG()` |
| Growth between periods | `LAG()` + percentage change |
| Three-month moving average | `AVG() OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)` |

## SQL Concepts Explained

- **`PARTITION BY`** splits rows into groups (e.g. each product line) and the window function restarts in each group.
- **Window `ORDER BY`** sets the order inside each partition; for `SUM` it makes the total run row by row.
- **`ROW_NUMBER()`** gives every row a unique number, even when values tie.
- **`RANK()`** gives tied rows the same rank and skips the next numbers (1, 2, 2, 4).
- **`DENSE_RANK()`** gives tied rows the same rank without skipping (1, 2, 2, 3).
- **`LAG()`** reads a value from the previous row, used for month-over-month change and growth.
- **Running total** is `SUM()` over rows from the first row up to the current row.
- **Moving average** is `AVG()` over a sliding frame of the current and 2 previous months. The first two months average fewer than three months.
- **CTEs** hold the monthly totals and product revenue first, so the window function can run on them. Window functions cannot be used in `WHERE`, so ranking is done in a CTE and filtered afterwards.

## Observations

1. Ties show the difference between the three ranking functions (e.g. Corvette and Model A Ford, both 69.93).
2. The 1952 Alpine Renault is the top Classic Cars product by revenue.
3. April had the highest monthly payments (107,500), up 88.6% on March, followed by a 51.6% drop in May.
4. The moving average smooths these swings and trends down from 80.8K in April to 41K in August.
