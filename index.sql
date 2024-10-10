CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE customers(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR (100) NOT NULL UNIQUE,
address VARCHAR(255) NOT NULL
);

CREATE TABLE product(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
price DECIMAL(10,2) NOT NULL,
description TEXT
);


CREATE TABLE orders(
id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
order_date DATE NOT NULL,
total_amount DECIMAL(10,2) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(id)
)

INSERT INTO customers (name, email, address) VALUES 
('SRIRAM', 'sriramofficial.sit@gmail.com', 'Trichy'),
('KATHAR BASHA', 'katharofficial@gmail.com', 'Namakkal'),
('ANIRUTH', 'aniruthofficial@gmail.com', 'Salem'),
('RAM', 'ramofficial.sit@gmail.com', 'Trichy'),
('AJEY', 'ajeyofficial@gmail.com', 'Salem');

INSERT INTO product (name, price, description) VALUES 
('Product A', 30.00, 'Description of Product A'),
('Product B', 150.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C'),
('Product D', 30.00, 'Description of Product D'),
('Product E', 50.00, 'Description of Product E');


INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE(), 80.00),
(2, CURDATE() - INTERVAL 10 DAY, 150.00),
(3, CURDATE() - INTERVAL 10 DAY, 30.00),
(4, CURDATE() - INTERVAL 35 DAY, 40.00),
(5, CURDATE() - INTERVAL 35 DAY, 30.00),
(1, CURDATE() - INTERVAL 35 DAY, 80.00);


SELECT * FROM customers;
SELECT * FROM product;
SELECT * FROM orders;

-- Retrieve all customers who have placed an order in the last 30 days

SELECT *
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date>= CURDATE() - INTERVAL 30 DAY;

-- Get the total amount of all orders placed by each customer

SELECT c.name,SUM(o.total_amount) AS total_amount
FROM customers c 
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;

-- Update the price of Product C to 45.00
SET SQL_SAFE_UPDATES = 0; 
UPDATE product SET price = 45.00 WHERE name='Product C';

-- Add a new column discount to the products table

ALTER TABLE product ADD COLUMN discount DECIMAL(5,2) DEFAULT 0;

-- Retrieve the top 3 products with the highest price

SELECT * FROM product ORDER BY price DESC LIMIT 3;

-- Get the names of customers who have ordered Product A

SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN product p ON p.id IN (SELECT id FROM orders WHERE customer_id = c.id)
WHERE p.name = 'Product A';

-- Join the orders and customers tables to retrieve the customer's name and order date for each order

SELECT c.name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Retrieve the orders with a total amount greater than 150.00
SELECT *
FROM orders
WHERE total_amount >= 150.00;

-- Retrieve the average total of all orders
SELECT AVG(total_amount) AS average_order_total
FROM orders;
