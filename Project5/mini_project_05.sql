-- Mini Project 05: Advanced SQL - Window Functions

-- ---------- Setup ----------
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    productCode VARCHAR(10) PRIMARY KEY,
    productName VARCHAR(60),
    productLine VARCHAR(30),
    buyPrice    DECIMAL(10,2)
);

CREATE TABLE orderdetails (
    orderNumber     INT,
    productCode     VARCHAR(10),
    quantityOrdered INT,
    priceEach       DECIMAL(10,2)
);

CREATE TABLE payments (
    customerNumber INT,
    checkNumber    VARCHAR(20),
    paymentDate    DATE,
    amount         DECIMAL(10,2)
);

INSERT INTO products VALUES
('P01', '1969 Harley Davidson', 'Motorcycles',  48.80),
('P02', '1996 Moto Guzzi',      'Motorcycles',  68.99),
('P03', '2003 Honda Chopper',   'Motorcycles',  68.99),
('P04', '1936 Indian Scout',    'Motorcycles',  24.23),
('P05', '1952 Alpine Renault',  'Classic Cars', 98.58),
('P06', '1957 Corvette',        'Classic Cars', 69.93),
('P07', '1965 Aston Martin',    'Classic Cars', 65.96),
('P08', '1932 Model A Ford',    'Classic Cars', 69.93),
('P09', 'Boeing X-32',          'Planes',       49.00),
('P10', 'F/A 18 Hornet',        'Planes',       54.40),
('P11', 'P-51 Mustang',         'Planes',       49.00),
('P12', 'Pilatus PC-6',         'Planes',       68.00);

INSERT INTO orderdetails VALUES
(1, 'P01', 20,  95.70),
(1, 'P05', 10, 160.00),
(2, 'P02', 25, 120.00),
(2, 'P06', 15, 130.00),
(3, 'P03', 18, 115.00),
(3, 'P07', 12, 110.00),
(4, 'P04', 30,  50.00),
(4, 'P08', 20, 105.00),
(5, 'P05', 40, 155.00),
(5, 'P09', 12,  85.00),
(6, 'P10', 22,  95.00),
(6, 'P11', 10,  80.00),
(7, 'P12', 14, 120.00),
(7, 'P01', 18,  92.50),
(8, 'P02', 10, 118.00),
(8, 'P10', 15,  98.00);

INSERT INTO payments VALUES
(101, 'CK001', '2026-01-10', 15000.00),
(101, 'CK002', '2026-01-22',  9500.00),
(102, 'CK003', '2026-01-28', 32000.00),
(103, 'CK004', '2026-02-05', 60000.00),
(104, 'CK005', '2026-02-18', 18000.00),
(103, 'CK006', '2026-03-09', 45000.00),
(108, 'CK007', '2026-03-20', 12000.00),
(103, 'CK008', '2026-04-02', 27500.00),
(105, 'CK009', '2026-04-25', 80000.00),
(105, 'CK010', '2026-05-11', 52000.00),
(101, 'CK011', '2026-06-04', 21000.00),
(102, 'CK012', '2026-06-19', 14000.00),
(103, 'CK013', '2026-07-08', 38000.00),
(104, 'CK014', '2026-07-23',  9000.00),
(105, 'CK015', '2026-08-06', 30000.00),
(108, 'CK016', '2026-08-21', 11000.00);

-- ---------- 1. Product Ranking ----------
-- Output 1: ROW_NUMBER, RANK and DENSE_RANK of products within each product line by buy price
SELECT productLine, productName, buyPrice,
       ROW_NUMBER() OVER (PARTITION BY productLine ORDER BY buyPrice DESC) AS row_num,
       RANK()       OVER (PARTITION BY productLine ORDER BY buyPrice DESC) AS rank_pos,
       DENSE_RANK() OVER (PARTITION BY productLine ORDER BY buyPrice DESC) AS dense_rank_pos
FROM products
ORDER BY productLine, buyPrice DESC, productName;

-- Output 2: Product revenue ranked within each product line
WITH product_revenue AS (
    SELECT p.productLine, p.productName,
           SUM(od.quantityOrdered * od.priceEach) AS revenue
    FROM products p
    INNER JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.productCode, p.productLine, p.productName
)
SELECT productLine, productName, revenue,
       RANK() OVER (PARTITION BY productLine ORDER BY revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY productLine, revenue_rank;

-- ---------- 2. Running Totals ----------
-- Output 3: Cumulative payment amount over time
SELECT paymentDate, checkNumber, amount,
       SUM(amount) OVER (ORDER BY paymentDate, checkNumber) AS running_total
FROM payments
ORDER BY paymentDate, checkNumber;

-- Output 4: Cumulative payments per customer
SELECT customerNumber, paymentDate, amount,
       SUM(amount) OVER (PARTITION BY customerNumber ORDER BY paymentDate, checkNumber) AS customer_running_total
FROM payments
ORDER BY customerNumber, paymentDate;

-- ---------- 3. Top Products ----------
-- Output 5: Top 2 products by revenue in each product line
WITH product_revenue AS (
    SELECT p.productLine, p.productName,
           SUM(od.quantityOrdered * od.priceEach) AS revenue
    FROM products p
    INNER JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.productCode, p.productLine, p.productName
),
ranked AS (
    SELECT productLine, productName, revenue,
           DENSE_RANK() OVER (PARTITION BY productLine ORDER BY revenue DESC) AS rnk
    FROM product_revenue
)
SELECT productLine, productName, revenue, rnk
FROM ranked
WHERE rnk <= 2
ORDER BY productLine, rnk;

-- ---------- 4. Month-over-Month Analysis ----------
-- Output 6: Monthly payments compared with previous month
WITH monthly AS (
    SELECT SUBSTR(paymentDate, 1, 7) AS month, SUM(amount) AS total
    FROM payments
    GROUP BY SUBSTR(paymentDate, 1, 7)
)
SELECT month, total,
       LAG(total) OVER (ORDER BY month)         AS previous_month,
       total - LAG(total) OVER (ORDER BY month) AS change
FROM monthly
ORDER BY month;

-- ---------- 5. Growth Analysis ----------
-- Output 7: Month-over-month growth percentage
WITH monthly AS (
    SELECT SUBSTR(paymentDate, 1, 7) AS month, SUM(amount) AS total
    FROM payments
    GROUP BY SUBSTR(paymentDate, 1, 7)
),
with_prev AS (
    SELECT month, total, LAG(total) OVER (ORDER BY month) AS prev_total
    FROM monthly
)
SELECT month, total, prev_total,
       ROUND((total - prev_total) * 100.0 / NULLIF(prev_total, 0), 2) AS growth_pct
FROM with_prev
ORDER BY month;

-- ---------- 6. Moving Average ----------
-- Output 8: Three-month moving average of monthly payments
WITH monthly AS (
    SELECT SUBSTR(paymentDate, 1, 7) AS month, SUM(amount) AS total
    FROM payments
    GROUP BY SUBSTR(paymentDate, 1, 7)
)
SELECT month, total,
       ROUND(AVG(total) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3m,
       COUNT(*)         OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)      AS months_in_window
FROM monthly
ORDER BY month;
