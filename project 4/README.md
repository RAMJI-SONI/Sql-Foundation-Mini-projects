# Mini Project 04 – Relational Analysis with JOINs

SQL script: `mini_project_04.sql` | Output screenshots: `screenshots/`

## Tables Used

`offices`, `employees`, `customers`, `payments`, `products`, `orders`, `orderdetails`

## Analysis Covered

| Area | JOIN Used |
|---|---|
| Customer & payment | `INNER JOIN`, `LEFT JOIN` + `SUM` / `GROUP BY` |
| Employee & office | `INNER JOIN`, `RIGHT JOIN` |
| Order & product | Multi-table `INNER JOIN` + aggregation |
| Office analysis | `LEFT JOIN` + `COUNT` |
| Sales representatives | `LEFT JOIN` |
| Employee hierarchy | `SELF JOIN` |
| Combinations | `CROSS JOIN` |
| Missing relationships | `LEFT JOIN ... IS NULL` |

## Observations

1. Mini Gifts Distributors and Euro+ Shopping Channel each paid about 132K, far more than any other customer.
2. Lone Wolf Models and Down Under Souvenirs have no orders, no payments and no sales representative.
3. The Sydney office has no employees.
4. Two products (RMS Titanic Replica, Pont Yacht) have never been sold; both are in the Ships line.
5. Classic Cars earn the most revenue, and three sales employees (Bow, Kato, Thompson) have no customers.

## SQL Concepts Used

`INNER` / `LEFT` / `RIGHT` / `CROSS` / `SELF JOIN`, multi-table joins, `GROUP BY`, `SUM`, `COUNT`, `COALESCE`, `WHERE` on joined data, `UNION ALL`.
