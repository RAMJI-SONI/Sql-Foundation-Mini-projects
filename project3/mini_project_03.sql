-- Mini Project 03: Data Cleaning & Transformation

-- ---------- Setup (raw, messy data) ----------
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(100),
    phone       VARCHAR(30),
    city        VARCHAR(50)
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_code VARCHAR(20),
    product_desc VARCHAR(100)
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    product_id  INT,
    order_date  DATE,
    ship_date   DATE,
    status      VARCHAR(20),
    amount      DECIMAL(10,2)
);

INSERT INTO customers VALUES
(1,  ' john ', 'SMITH',  'John.Smith@Gmail.com ',    '(555) 123-4567',  'dallas'),
(2,  'MARY',   ' jones', 'mary.jones@gmail.com',     '555-234-5678',    'Boston '),
(3,  'alice',  'brown',  'ALICE.BROWN@YAHOO.COM',    '555.345.6789',    NULL),
(4,  'Rahul',  'sharma', 'rahul.sharma@outlook.com', '+1 555 456 7890', 'Chicago'),
(5,  'priya',  NULL,     'priya@@gmail.com',         '5555678901',      'chicago'),
(6,  'david',  'LEE',    NULL,                       NULL,              'Boston'),
(7,  ' john ', 'smith',  'john.smith@gmail.com',     '555-123-4567',    'Dallas'),
(8,  'sara',   'khan',   'sara.khan@gmail',          '555 678 9012',    'Austin'),
(9,  NULL,     NULL,     'unknown@mail.com',         '',                'Austin'),
(10, 'Tom',    'Wilson', 'tom.wilson@gmail.com',     '555-789-0123',    'Seattle'),
(11, 'tom',    'wilson', 'TOM.WILSON@GMAIL.COM',     '(555) 789-0123',  'seattle ');

INSERT INTO products VALUES
(1, 'ELE-LAP-001', 'Laptop Pro | Black'),
(2, 'ELE-MOB-002', 'Phone X | Silver'),
(3, 'HOM-CHR-003', 'Office Chair | Grey'),
(4, 'HOM-DSK-004', 'Standing Desk | Walnut'),
(5, 'ACC-MSE-005', 'Wireless Mouse | Black'),
(6, 'ACC-KEY-006', 'Keyboard | White');

INSERT INTO orders VALUES
(101, 1,  1, '2026-01-05', '2026-01-07', 'delivered',  1200.00),
(102, 2,  2, '2026-01-08', '2026-01-09', 'Delivered ',  800.00),
(103, 3,  3, '2026-01-10', NULL,         'pending',     150.00),
(104, 4,  4, '2026-01-12', '2026-01-15', 'SHIPPED',     450.00),
(105, 5,  5, '2026-01-15', NULL,         'Delivered',    25.00),
(106, 6,  6, '2026-01-18', '2026-01-16', 'shipped',      40.00),
(107, 7,  1, '2026-01-20', NULL,         'cancelled',  1200.00),
(108, 8,  2, '2026-01-22', '2026-01-24', 'CANCELED',    800.00),
(109, 10, 3, '2026-02-01', NULL,         'Pending',    -150.00),
(110, 11, 5, '2026-02-03', '2026-02-05', 'Delivered',    25.00),
(111, 2,  6, '2026-02-10', NULL,         'PENDING',      40.00),
(112, 9,  4, '2026-02-12', '2026-02-14', 'shipped',      NULL);

-- Output 1: Raw customers
SELECT * FROM customers;

-- Output 2: Raw orders
SELECT * FROM orders;

-- Output 3: Raw products
SELECT * FROM products;

-- ---------- 1. Missing Values ----------
-- Output 4: Missing values per column (NULL or empty)
SELECT
    SUM(first_name IS NULL OR TRIM(first_name) = '') AS missing_first_name,
    SUM(last_name  IS NULL OR TRIM(last_name)  = '') AS missing_last_name,
    SUM(email      IS NULL OR TRIM(email)      = '') AS missing_email,
    SUM(phone      IS NULL OR TRIM(phone)      = '') AS missing_phone,
    SUM(city       IS NULL OR TRIM(city)       = '') AS missing_city
FROM customers;

UPDATE customers SET phone      = NULL        WHERE TRIM(phone) = '';
UPDATE customers SET first_name = 'Unknown'   WHERE first_name IS NULL;
UPDATE customers SET last_name  = 'Unknown'   WHERE last_name  IS NULL;
UPDATE customers SET city       = 'Unknown'   WHERE city       IS NULL;

-- Output 5: Customers after handling missing values
SELECT * FROM customers;

-- ---------- 2. Name Cleaning ----------
UPDATE customers
SET first_name = CONCAT(UPPER(SUBSTR(TRIM(first_name), 1, 1)), LOWER(SUBSTR(TRIM(first_name), 2))),
    last_name  = CONCAT(UPPER(SUBSTR(TRIM(last_name), 1, 1)),  LOWER(SUBSTR(TRIM(last_name), 2))),
    city       = CONCAT(UPPER(SUBSTR(TRIM(city), 1, 1)),       LOWER(SUBSTR(TRIM(city), 2)));

-- Output 6: Standardised names and cities
SELECT customer_id, first_name, last_name, city FROM customers;

-- ---------- 3. Email Cleaning ----------
UPDATE customers SET email = LOWER(TRIM(email));

-- Output 7: Invalid emails identified
SELECT customer_id, email
FROM customers
WHERE email NOT LIKE '%_@_%._%' OR email LIKE '%@%@%';

UPDATE customers
SET email = NULL
WHERE email NOT LIKE '%_@_%._%' OR email LIKE '%@%@%';

-- Output 8: Customers after email cleaning
SELECT customer_id, email FROM customers;

-- ---------- 4. Phone Number Cleaning ----------
UPDATE customers
SET phone = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), '.', ''), ' ', ''), '+', '');

UPDATE customers
SET phone = SUBSTR(phone, 2)
WHERE LENGTH(phone) = 11 AND phone LIKE '1%';

-- Output 9: Cleaned phone numbers
SELECT customer_id, phone FROM customers;

-- ---------- 5. Duplicate Detection ----------
-- Output 10: Duplicate customers
SELECT first_name, last_name, phone, COUNT(*) AS occurrences, MIN(customer_id) AS keep_id
FROM customers
GROUP BY first_name, last_name, phone
HAVING COUNT(*) > 1;

DELETE FROM customers
WHERE customer_id NOT IN (
    SELECT keep_id FROM (
        SELECT MIN(customer_id) AS keep_id
        FROM customers
        GROUP BY first_name, last_name, phone
    ) AS t
);

-- Output 11: Customers after removing duplicates
SELECT * FROM customers;

-- ---------- 6. Order Analysis ----------
-- Output 12: Order count by status (case/space differences ignored)
SELECT LOWER(TRIM(status)) AS status_clean, COUNT(*) AS total_orders, SUM(amount) AS total_amount
FROM orders
GROUP BY LOWER(TRIM(status))
ORDER BY total_orders DESC;

-- Output 13: Distinct raw status values
SELECT DISTINCT status FROM orders ORDER BY status;

-- ---------- 7. Product Transformation ----------
ALTER TABLE products ADD COLUMN category_code VARCHAR(10);
ALTER TABLE products ADD COLUMN product_name  VARCHAR(50);
ALTER TABLE products ADD COLUMN color         VARCHAR(20);

UPDATE products
SET category_code = SUBSTR(product_code, 1, INSTR(product_code, '-') - 1),
    product_name  = TRIM(SUBSTR(product_desc, 1, INSTR(product_desc, '|') - 1)),
    color         = TRIM(SUBSTR(product_desc, INSTR(product_desc, '|') + 1));

-- Output 14: Products with extracted fields
SELECT product_id, product_code, category_code, product_name, color FROM products;

-- ---------- 8. Data Inconsistency ----------
-- Output 15: Orders with illogical data
SELECT order_id, status, order_date, ship_date, amount,
    CASE
        WHEN ship_date < order_date                                             THEN 'Shipped before ordered'
        WHEN LOWER(TRIM(status)) IN ('shipped','delivered') AND ship_date IS NULL THEN 'No ship date'
        WHEN LOWER(TRIM(status)) IN ('cancelled','canceled') AND ship_date IS NOT NULL THEN 'Cancelled but shipped'
        WHEN amount IS NULL OR amount <= 0                                      THEN 'Invalid amount'
    END AS issue
FROM orders
WHERE ship_date < order_date
   OR (LOWER(TRIM(status)) IN ('shipped','delivered') AND ship_date IS NULL)
   OR (LOWER(TRIM(status)) IN ('cancelled','canceled') AND ship_date IS NOT NULL)
   OR amount IS NULL OR amount <= 0;

-- ---------- 9. Standardisation ----------
UPDATE orders
SET status = CASE
    WHEN LOWER(TRIM(status)) IN ('cancelled','canceled') THEN 'Cancelled'
    ELSE CONCAT(UPPER(SUBSTR(TRIM(status), 1, 1)), LOWER(SUBSTR(TRIM(status), 2)))
END;

-- Output 16: Standardised status values
SELECT status, COUNT(*) AS total_orders FROM orders GROUP BY status ORDER BY total_orders DESC;

-- Output 17: Final orders
SELECT * FROM orders;
