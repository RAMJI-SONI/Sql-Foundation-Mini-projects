# Mini Project 03 – Data Cleaning & Transformation

SQL script: `mini_project_03.sql` | Output screenshots: `screenshots/`

## Issues Identified & How They Were Handled

| Area | Issue | Handling |
|---|---|---|
| Missing values | NULL names/city, empty phone strings | Empty phone → `NULL`; missing name/city → `'Unknown'` |
| Names | Extra spaces, mixed case | `TRIM` + capitalise first letter |
| Email | Mixed case, spaces, invalid format (`@@`, no domain) | `LOWER(TRIM())`; invalid emails set to `NULL` |
| Phone | `()`, `-`, `.`, spaces, `+1` prefix | Nested `REPLACE`; removed leading `1` from 11-digit numbers |
| Duplicates | Same customer entered twice | Found with `GROUP BY ... HAVING`; kept lowest `customer_id`, deleted the rest |
| Orders | Status spelled/cased differently | Analysed with `LOWER(TRIM())`, then standardised |
| Products | Code and description hold several values | Extracted `category_code`, `product_name`, `color` |
| Inconsistency | Shipped before ordered, delivered with no ship date, cancelled but shipped, negative/NULL amount | Identified with `CASE`; not changed without source confirmation |
| Standardisation | `CANCELED` vs `Cancelled`, case differences | Single `UPDATE` with `CASE` |

## SQL Concepts Used

NULL handling, `UPDATE`, `DELETE`, `ALTER TABLE`, `TRIM`, `UPPER`/`LOWER`, `SUBSTR`, `INSTR`, `REPLACE`, `CONCAT`, `LIKE`, `CASE`, `GROUP BY` / `HAVING`, subqueries.
