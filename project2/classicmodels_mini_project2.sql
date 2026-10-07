-- =====================================================================
-- Bleep | SQL Foundations & Database Operations | Mini Project 2
-- Database : classicmodels  (MySQL 8.x, run in MySQL Workbench)
-- Tables   : customers, employees, productlines, products, payments
-- How to run: open this file in Workbench and press the lightning
--             bolt (Ctrl+Shift+Enter), or run one query at a time with
--             Ctrl+Enter. Every query is read-only (SELECT only).
-- Format   : every query starts with "-- Qn: ..." so each can be run
--            and screenshotted independently.
-- =====================================================================

USE classicmodels;

-- #####################################################################
-- PART 1 : CUSTOMER ANALYSIS
-- #####################################################################

-- Q01: First 10 customers with their location (SELECT, LIMIT)
SELECT customerNumber, customerName, city, state, country
FROM customers
LIMIT 10;

-- Q02: Customers located in the USA (WHERE)
SELECT customerNumber, customerName, city, state
FROM customers
WHERE country = 'USA';

-- Q03: Customers in France, Germany or Spain, sorted by country then city (IN, ORDER BY)
SELECT customerName, city, country
FROM customers
WHERE country IN ('France', 'Germany', 'Spain')
ORDER BY country, city;

-- Q04: Number of customers per country (GROUP BY, COUNT, ORDER BY)
SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC, country;

-- Q05: Countries that have at least 3 customers (GROUP BY, HAVING)
SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
HAVING COUNT(*) >= 3
ORDER BY total_customers DESC;

-- Q06: Customers with a credit limit above 100,000, highest first (WHERE, ORDER BY)
SELECT customerName, country, creditLimit
FROM customers
WHERE creditLimit > 100000
ORDER BY creditLimit DESC;

-- Q07: Credit limit statistics (aggregate functions)
SELECT COUNT(*)                   AS customers,
       MIN(creditLimit)           AS lowest_limit,
       MAX(creditLimit)           AS highest_limit,
       ROUND(AVG(creditLimit), 2) AS average_limit,
       SUM(creditLimit)           AS total_limit
FROM customers;

-- Q08: Top 5 credit limits (ORDER BY, LIMIT)
SELECT customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 5;

-- Q09: Next 5 credit limits - ranks 6 to 10 (LIMIT, OFFSET)
SELECT customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 5 OFFSET 5;

-- Q10: Customer search - names starting with 'A' (LIKE)
SELECT customerNumber, customerName, country
FROM customers
WHERE customerName LIKE 'A%'
ORDER BY customerName;

-- Q11: Customer search - names containing 'Co' (LIKE with wildcards)
SELECT customerNumber, customerName, country
FROM customers
WHERE customerName LIKE '%Co%'
ORDER BY customerName;

-- Q12: Customers with no state recorded (filtering NULL)
SELECT customerName, city, country
FROM customers
WHERE state IS NULL
ORDER BY country, city;

-- Q13: Customers per sales representative, with rep name (GROUP BY, subquery in SELECT)
SELECT c.salesRepEmployeeNumber AS rep_id,
       (SELECT CONCAT(e.firstName, ' ', e.lastName)
          FROM employees e
         WHERE e.employeeNumber = c.salesRepEmployeeNumber) AS sales_rep,
       COUNT(*) AS customers_handled
FROM customers c
WHERE c.salesRepEmployeeNumber IS NOT NULL
GROUP BY c.salesRepEmployeeNumber
ORDER BY customers_handled DESC;

-- Q14: Customers who have no sales representative assigned (IS NULL)
SELECT customerNumber, customerName, country
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- Q15: Customers whose credit limit is above the overall average (subquery)
SELECT customerName, country, creditLimit
FROM customers
WHERE creditLimit > (SELECT AVG(creditLimit) FROM customers)
ORDER BY creditLimit DESC;

-- Q16: Customers who have made at least one payment (IN + subquery)
SELECT customerNumber, customerName
FROM customers
WHERE customerNumber IN (SELECT customerNumber FROM payments)
ORDER BY customerName;

-- Q17: Customers who have never made a payment (NOT IN + subquery)
SELECT customerNumber, customerName, country
FROM customers
WHERE customerNumber NOT IN (SELECT customerNumber FROM payments)
ORDER BY customerName;

-- #####################################################################
-- PART 2 : PRODUCT ANALYSIS
-- #####################################################################

-- Q18: Product prices with markup (SELECT with calculated column)
SELECT productCode, productName, buyPrice, MSRP,
       ROUND(MSRP - buyPrice, 2) AS markup
FROM products
ORDER BY markup DESC
LIMIT 10;

-- Q19: Top 5 most expensive products by MSRP (ORDER BY, LIMIT)
SELECT productName, productLine, MSRP
FROM products
ORDER BY MSRP DESC
LIMIT 5;

-- Q20: Products per product line with average buy price (GROUP BY, COUNT, AVG)
SELECT productLine,
       COUNT(*)                  AS total_products,
       ROUND(AVG(buyPrice), 2)   AS avg_buy_price,
       ROUND(AVG(MSRP), 2)       AS avg_msrp
FROM products
GROUP BY productLine
ORDER BY total_products DESC;

-- Q21: Product lines having more than 2 products (HAVING)
SELECT productLine, COUNT(*) AS total_products
FROM products
GROUP BY productLine
HAVING COUNT(*) > 2
ORDER BY total_products DESC;

-- Q22: Low stock products - fewer than 1,500 units (WHERE, ORDER BY)
SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock < 1500
ORDER BY quantityInStock;

-- Q23: Well-stocked products - more than 8,000 units (WHERE, ORDER BY)
SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock > 8000
ORDER BY quantityInStock DESC;

-- Q24: Total stock and stock value per product line (SUM, GROUP BY)
SELECT productLine,
       SUM(quantityInStock)                    AS units_in_stock,
       ROUND(SUM(quantityInStock * buyPrice), 2) AS stock_value
FROM products
GROUP BY productLine
ORDER BY stock_value DESC;

-- Q25: Product search - names containing 'Ford' or 'Harley' (LIKE, OR)
SELECT productCode, productName, productLine, MSRP
FROM products
WHERE productName LIKE '%Ford%' OR productName LIKE '%Harley%'
ORDER BY productName;

-- Q26: Products in scale 1:10 or 1:18 (IN)
SELECT productName, productScale, buyPrice
FROM products
WHERE productScale IN ('1:10', '1:18')
ORDER BY productScale, productName;

-- Q27: Products priced above the average MSRP (subquery)
SELECT productName, productLine, MSRP
FROM products
WHERE MSRP > (SELECT AVG(MSRP) FROM products)
ORDER BY MSRP DESC;

-- Q28: Most expensive product in each product line (correlated subquery)
SELECT p.productLine, p.productName, p.MSRP
FROM products p
WHERE p.MSRP = (SELECT MAX(p2.MSRP)
                  FROM products p2
                 WHERE p2.productLine = p.productLine)
ORDER BY p.productLine;

-- Q29: Products sorted by line (A-Z) then buy price (high to low) (multi-column ORDER BY)
SELECT productLine, productName, buyPrice
FROM products
ORDER BY productLine ASC, buyPrice DESC
LIMIT 15;

-- Q30: Pagination - page 2 of products, 8 per page (LIMIT, OFFSET)
SELECT productCode, productName, buyPrice
FROM products
ORDER BY productCode
LIMIT 8 OFFSET 8;

-- #####################################################################
-- PART 3 : PAYMENT ANALYSIS
-- #####################################################################

-- Q31: Ten most recent payments (ORDER BY, LIMIT)
SELECT customerNumber, checkNumber, paymentDate, amount
FROM payments
ORDER BY paymentDate DESC
LIMIT 10;

-- Q32: Payments made during 2004 (WHERE, BETWEEN)
SELECT customerNumber, paymentDate, amount
FROM payments
WHERE paymentDate BETWEEN '2004-01-01' AND '2004-12-31'
ORDER BY paymentDate;

-- Q33: Overall payment summary (COUNT, SUM, AVG, MIN, MAX)
SELECT COUNT(*)                AS total_payments,
       ROUND(SUM(amount), 2)   AS total_amount,
       ROUND(AVG(amount), 2)   AS average_payment,
       MIN(amount)             AS minimum_payment,
       MAX(amount)             AS maximum_payment
FROM payments;

-- Q34: Payments per year (SUBSTR + GROUP BY)
SELECT SUBSTR(paymentDate, 1, 4) AS payment_year,
       COUNT(*)                  AS payments,
       ROUND(SUM(amount), 2)     AS total_amount
FROM payments
GROUP BY SUBSTR(paymentDate, 1, 4)
ORDER BY payment_year;

-- Q35: Customer payment activity - top 10 by total paid (GROUP BY, SUM, COUNT, AVG)
SELECT customerNumber,
       COUNT(*)                AS payments_made,
       ROUND(SUM(amount), 2)   AS total_paid,
       ROUND(AVG(amount), 2)   AS avg_payment
FROM payments
GROUP BY customerNumber
ORDER BY total_paid DESC
LIMIT 10;

-- Q36: Customers who paid 2 or more times (GROUP BY, HAVING)
SELECT customerNumber, COUNT(*) AS payments_made, ROUND(SUM(amount), 2) AS total_paid
FROM payments
GROUP BY customerNumber
HAVING COUNT(*) >= 2
ORDER BY payments_made DESC, total_paid DESC;

-- Q37: Minimum and maximum payment per customer (MIN, MAX, GROUP BY)
SELECT customerNumber,
       MIN(amount) AS smallest_payment,
       MAX(amount) AS largest_payment
FROM payments
GROUP BY customerNumber
ORDER BY largest_payment DESC
LIMIT 10;

-- Q38: The single smallest and largest payments with customer name (subquery)
SELECT c.customerName, p.paymentDate, p.amount
FROM payments p
JOIN customers c ON c.customerNumber = p.customerNumber
WHERE p.amount = (SELECT MIN(amount) FROM payments)
   OR p.amount = (SELECT MAX(amount) FROM payments);

-- Q39: Payments above the average payment amount (subquery)
SELECT customerNumber, paymentDate, amount
FROM payments
WHERE amount > (SELECT AVG(amount) FROM payments)
ORDER BY amount DESC
LIMIT 10;

-- Q40: Customers whose total payments exceed the average customer total (HAVING + subquery)
SELECT customerNumber, ROUND(SUM(amount), 2) AS total_paid
FROM payments
GROUP BY customerNumber
HAVING SUM(amount) > (SELECT AVG(customer_total)
                        FROM (SELECT SUM(amount) AS customer_total
                                FROM payments
                               GROUP BY customerNumber) AS t)
ORDER BY total_paid DESC;
