-- Sales Analysis SQL
-- Sample schema and queries for a small retail database.

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(60),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1, 'Aarav Sharma', 'Indore', '2025-01-10'),
(2, 'Meera Patel', 'Bhopal', '2025-02-15'),
(3, 'Rohan Verma', 'Pune', '2025-03-02'),
(4, 'Isha Gupta', 'Indore', '2025-04-20');

INSERT INTO orders VALUES
(101, 1, '2025-05-01', 1250.00, 'COMPLETED'),
(102, 1, '2025-05-12', 800.00, 'COMPLETED'),
(103, 2, '2025-05-15', 2100.00, 'PENDING'),
(104, 3, '2025-06-03', 450.00, 'COMPLETED'),
(105, 4, '2025-06-08', 1750.00, 'CANCELLED');

-- Total completed revenue by customer.
SELECT c.customer_id, c.customer_name,
       SUM(o.order_amount) AS total_revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;

-- Monthly order summary.
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       EXTRACT(MONTH FROM order_date) AS order_month,
       COUNT(*) AS order_count,
       SUM(order_amount) AS gross_amount
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY order_year, order_month;
