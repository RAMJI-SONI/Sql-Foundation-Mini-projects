# Bleep – SQL Foundations & Database Operations: Mini Project 2

Analysis of the **ClassicModels** sample database using SELECT-based SQL:
customers, products and payments.

## Dataset used
- **ClassicModels** (MySQL sample database – a fictional retailer of scale models).
- Tables used: `customers`, `employees`, `products`, `productlines`, `payments`.

## Files in this repository
| File | Purpose |
|------|---------|
| `classicmodels_mini_project2.sql` | All 40 queries, numbered Q01–Q40, each runnable on its own |
| `screenshots/` | One output screenshot per query (`Q01_...png` … `Q40_...png`) |
| `README.md` | This file |
| `tools/` | Helper scripts used to generate the sample screenshots (optional) |

## How to run
1. Load ClassicModels into MySQL (run the official `mysqlsampledatabase.sql` script).
2. Open `classicmodels_mini_project2.sql` in MySQL Workbench.
3. Run everything with **Ctrl+Shift+Enter**, or one query at a time with **Ctrl+Enter**.
   The script starts with `USE classicmodels;` and contains only `SELECT` statements,
   so it cannot change your data.

## Questions solved (40)
**Customer analysis (Q01–Q17):** locations, customers per country, countries with 3+ customers,
credit-limit filters/statistics/top-N/pagination, name searches, customers without a state,
customers per sales rep, customers without a rep, above-average credit limits,
customers with and without payments.

**Product analysis (Q18–Q30):** prices and markup, most expensive products, products per line,
lines with more than 2 products, low/high stock, stock value per line, name searches,
scale filter, above-average prices, priciest product per line, multi-column sorting, pagination.

**Payment analysis (Q31–Q40):** latest payments, payments by date range, overall
count/total/average/min/max, payments per year, per-customer count/total/average,
repeat payers, min/max per customer, above-average payments, customers above the average total.

## SQL concepts used
`SELECT` · `WHERE` · `ORDER BY` · `GROUP BY` · `HAVING` · `LIKE` · `IN` / `NOT IN` ·
`BETWEEN` · `IS NULL` · `LIMIT` · `OFFSET` · aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) ·
subqueries (scalar, `IN`, correlated, in `FROM`, in `HAVING`) · calculated columns · `ROUND` · one `JOIN`.

## Key findings
> Fill these in after running the script on the real ClassicModels database
> (use your own screenshots for the numbers).

- Countries with the most customers: _…_ (Q04, Q05)
- Highest credit limit and who holds it: _…_ (Q07, Q08)
- Customers with no sales rep / no payments: _…_ (Q14, Q17)
- Most expensive product and best-markup product: _…_ (Q18, Q19)
- Product line with the largest stock value: _…_ (Q24)
- Total payments, average, min and max: _…_ (Q33)
- Busiest payment year: _…_ (Q34)
- Top paying customer: _…_ (Q35)

## Note on the screenshots
The screenshots in this folder were generated from a **small stand-in dataset with the
ClassicModels table structure** (30 customers, 30 products, 60 payments), because the full
ClassicModels database was not available where the queries were run. The SQL is identical;
the row values differ from the real database. Replace them with Workbench screenshots from
your own run before submitting.
