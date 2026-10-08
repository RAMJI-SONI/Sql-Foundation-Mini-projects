-- Mini Project 04: Relational Analysis with JOINs

-- ---------- Setup ----------
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS offices;

CREATE TABLE offices (
    officeCode INT PRIMARY KEY,
    city       VARCHAR(50),
    country    VARCHAR(50)
);

CREATE TABLE employees (
    employeeNumber INT PRIMARY KEY,
    lastName       VARCHAR(50),
    firstName      VARCHAR(50),
    jobTitle       VARCHAR(50),
    officeCode     INT,
    reportsTo      INT
);

CREATE TABLE customers (
    customerNumber         INT PRIMARY KEY,
    customerName           VARCHAR(80),
    country                VARCHAR(50),
    salesRepEmployeeNumber INT,
    creditLimit            DECIMAL(10,2)
);

CREATE TABLE payments (
    customerNumber INT,
    checkNumber    VARCHAR(20),
    paymentDate    DATE,
    amount         DECIMAL(10,2)
);

CREATE TABLE products (
    productCode VARCHAR(10) PRIMARY KEY,
    productName VARCHAR(60),
    productLine VARCHAR(30),
    buyPrice    DECIMAL(10,2)
);

CREATE TABLE orders (
    orderNumber    INT PRIMARY KEY,
    orderDate      DATE,
    status         VARCHAR(20),
    customerNumber INT
);

CREATE TABLE orderdetails (
    orderNumber     INT,
    productCode     VARCHAR(10),
    quantityOrdered INT,
    priceEach       DECIMAL(10,2)
);

INSERT INTO offices VALUES
(1, 'San Francisco', 'USA'),
(2, 'Boston',        'USA'),
(3, 'Paris',         'France'),
(4, 'Tokyo',         'Japan'),
(5, 'Sydney',        'Australia');

INSERT INTO employees VALUES
(1,  'Murphy',     'Diane',   'President',            1, NULL),
(2,  'Patterson',  'Mary',    'VP Sales',             1, 1),
(3,  'Firrelli',   'Jeff',    'VP Marketing',         1, 1),
(4,  'Bondur',     'Gerard',  'Sales Manager (EMEA)', 3, 2),
(5,  'Bow',        'Anthony', 'Sales Manager (NA)',   2, 2),
(6,  'Jones',      'Barry',   'Sales Rep',            2, 5),
(7,  'Hernandez',  'Gerard',  'Sales Rep',            3, 4),
(8,  'Nishi',      'Mami',    'Sales Rep',            4, 2),
(9,  'Kato',       'Yoshimi', 'Sales Rep',            4, 8),
(10, 'Thompson',   'Leslie',  'Sales Rep',            1, 5);

INSERT INTO customers VALUES
(101, 'Atelier Graphique',         'France',      7,    21000.00),
(102, 'Signal Gift Stores',        'USA',         6,    71800.00),
(103, 'Mini Gifts Distributors',   'USA',         6,   210500.00),
(104, 'Tokyo Collectibles',        'Japan',       8,    85000.00),
(105, 'Euro+ Shopping Channel',    'France',      7,   227600.00),
(106, 'Lone Wolf Models',          'USA',         NULL,     0.00),
(107, 'Down Under Souvenirs',      'Australia',   NULL, 88000.00),
(108, 'Alpine Toys',               'Switzerland', 4,    50000.00);

INSERT INTO payments VALUES
(101, 'CK101A', '2026-01-10', 15000.00),
(101, 'CK101B', '2026-03-15',  9500.00),
(102, 'CK102A', '2026-02-01', 32000.00),
(103, 'CK103A', '2026-01-20', 60000.00),
(103, 'CK103B', '2026-02-18', 45000.00),
(103, 'CK103C', '2026-04-02', 27500.00),
(104, 'CK104A', '2026-03-05', 18000.00),
(105, 'CK105A', '2026-01-25', 80000.00),
(105, 'CK105B', '2026-05-11', 52000.00),
(108, 'CK108A', '2026-02-14', 12000.00);

INSERT INTO products VALUES
('P1', '1969 Harley Davidson',  'Motorcycles', 48.80),
('P2', '1952 Alpine Renault',   'Classic Cars', 98.58),
('P3', '1996 Moto Guzzi',       'Motorcycles', 68.99),
('P4', 'Boeing X-32 Stealth',   'Planes',      49.00),
('P5', 'RMS Titanic Replica',   'Ships',       51.09),
('P6', 'Pont Yacht',            'Ships',       33.30);

INSERT INTO orders VALUES
(10100, '2026-01-05', 'Shipped',   101),
(10101, '2026-01-12', 'Shipped',   102),
(10102, '2026-01-18', 'Shipped',   103),
(10103, '2026-02-10', 'Cancelled', 103),
(10104, '2026-02-20', 'Shipped',   105),
(10105, '2026-03-01', 'Shipped',   104),
(10106, '2026-03-15', 'In Process',108);

INSERT INTO orderdetails VALUES
(10100, 'P1', 20,  95.70),
(10100, 'P2', 10, 160.00),
(10101, 'P2', 15, 150.00),
(10102, 'P1', 30,  90.00),
(10102, 'P3', 25, 120.00),
(10103, 'P3', 10, 118.00),
(10104, 'P2', 40, 155.00),
(10104, 'P4', 12,  85.00),
(10105, 'P1', 18,  92.50),
(10106, 'P4', 20,  88.00);

-- Output 1: Row count per table
SELECT 'offices' AS table_name, COUNT(*) AS total_rows FROM offices
UNION ALL SELECT 'employees',    COUNT(*) FROM employees
UNION ALL SELECT 'customers',    COUNT(*) FROM customers
UNION ALL SELECT 'payments',     COUNT(*) FROM payments
UNION ALL SELECT 'products',     COUNT(*) FROM products
UNION ALL SELECT 'orders',       COUNT(*) FROM orders
UNION ALL SELECT 'orderdetails', COUNT(*) FROM orderdetails;

-- ---------- 1. Customer & Payment Analysis ----------
-- Output 2: INNER JOIN - customers with their payments
SELECT c.customerName, p.checkNumber, p.paymentDate, p.amount
FROM customers c
INNER JOIN payments p ON c.customerNumber = p.customerNumber
ORDER BY c.customerName, p.paymentDate;

-- Output 3: Total paid per customer (aggregation with JOIN)
SELECT c.customerName, COUNT(p.checkNumber) AS payments_made, SUM(p.amount) AS total_paid
FROM customers c
INNER JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY total_paid DESC;

-- Output 4: Filtering joined data - payments above 30000 from USA/France customers
SELECT c.customerName, c.country, p.paymentDate, p.amount
FROM customers c
INNER JOIN payments p ON c.customerNumber = p.customerNumber
WHERE c.country IN ('USA', 'France') AND p.amount > 30000
ORDER BY p.amount DESC;

-- Output 5: LEFT JOIN - all customers with total paid (0 if none)
SELECT c.customerName, COALESCE(SUM(p.amount), 0) AS total_paid
FROM customers c
LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY total_paid DESC;

-- ---------- 2. Employee & Office Analysis ----------
-- Output 6: INNER JOIN - employees with their offices
SELECT e.firstName, e.lastName, e.jobTitle, o.city AS office_city, o.country
FROM employees e
INNER JOIN offices o ON e.officeCode = o.officeCode
ORDER BY o.city, e.lastName;

-- Output 7: RIGHT JOIN - offices with no employees
SELECT o.officeCode, o.city, o.country
FROM employees e
RIGHT JOIN offices o ON e.officeCode = o.officeCode
WHERE e.employeeNumber IS NULL;

-- ---------- 3. Order & Product Analysis ----------
-- Output 8: Multi-table JOIN - orders, order details and products
SELECT o.orderNumber, o.orderDate, p.productName, od.quantityOrdered,
       od.quantityOrdered * od.priceEach AS line_total
FROM orders o
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN products p      ON od.productCode = p.productCode
ORDER BY o.orderNumber, p.productName;

-- Output 9: Revenue by product line (excluding cancelled orders)
SELECT p.productLine, SUM(od.quantityOrdered) AS units_sold,
       SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM orders o
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN products p      ON od.productCode = p.productCode
WHERE o.status <> 'Cancelled'
GROUP BY p.productLine
ORDER BY revenue DESC;

-- ---------- 4. Office Analysis ----------
-- Output 10: Employees per office (offices with none included)
SELECT o.city, o.country, COUNT(e.employeeNumber) AS employee_count
FROM offices o
LEFT JOIN employees e ON o.officeCode = e.officeCode
GROUP BY o.officeCode, o.city, o.country
ORDER BY employee_count DESC;

-- ---------- 5. Sales Representative Analysis ----------
-- Output 11: Customers with their assigned sales representative
SELECT c.customerName, c.country,
       COALESCE(e.firstName || ' ' || e.lastName, 'Not assigned') AS sales_rep
FROM customers c
LEFT JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
ORDER BY c.customerName;

-- Output 12: Customers and total credit limit per sales rep
SELECT e.firstName || ' ' || e.lastName AS sales_rep,
       COUNT(c.customerNumber) AS customers,
       COALESCE(SUM(c.creditLimit), 0) AS total_credit_limit
FROM employees e
LEFT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE e.jobTitle LIKE 'Sales%'
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY customers DESC;

-- ---------- 6. Employee Hierarchy (SELF JOIN) ----------
-- Output 13: Employee and manager
SELECT e.firstName || ' ' || e.lastName AS employee, e.jobTitle,
       COALESCE(m.firstName || ' ' || m.lastName, 'No manager') AS manager
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeNumber
ORDER BY e.employeeNumber;

-- Output 14: Number of direct reports per manager
SELECT m.firstName || ' ' || m.lastName AS manager, COUNT(e.employeeNumber) AS direct_reports
FROM employees m
INNER JOIN employees e ON e.reportsTo = m.employeeNumber
GROUP BY m.employeeNumber, m.firstName, m.lastName
ORDER BY direct_reports DESC;

-- ---------- 7. CROSS JOIN ----------
-- Output 15: Every office city paired with every product line
SELECT o.city, pl.productLine
FROM offices o
CROSS JOIN (SELECT DISTINCT productLine FROM products) pl
ORDER BY o.city, pl.productLine;

-- ---------- 8. Missing Relationships ----------
-- Output 16: Customers without orders
SELECT c.customerNumber, c.customerName
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;

-- Output 17: Products that have never been sold
SELECT p.productCode, p.productName, p.productLine
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.orderNumber IS NULL;

-- Output 18: Records without matching relationships (customers with no sales rep)
SELECT c.customerNumber, c.customerName, c.country
FROM customers c
LEFT JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE e.employeeNumber IS NULL;
