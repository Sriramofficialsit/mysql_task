-- Creating databse with name ecommerce
CREATE DATABASE ecommerce;

-- Currently Using ecommerce Database
USE ecommerce;

-- Creating Table With Name customers
CREATE TABLE customers (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
address VARCHAR(100) NOT NULL
);

-- Creating Table With Name orders
CREATE TABLE orders(
id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
order_date DATE NOT NULL,
total_amount DECIMAL(10,2) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(id)
)

-- Creating Table With Name product
CREATE TABLE product(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
price DECIMAL(10,2) NOT NULL,
description TEXT
);

-- Inserting Sample Datas To customers Table
INSERT INTO customers (name, email, address) VALUES 
('SRIRAM', 'sriramofficial.sit@gmail.com', 'Trichy'),
('KATHAR BASHA', 'katharofficial@gmail.com', 'Namakkal'),
('ANIRUTH', 'aniruthofficial@gmail.com', 'Salem'),
('RAM', 'ramofficial.sit@gmail.com', 'Trichy'),
('AJEY', 'ajeyofficial@gmail.com', 'Salem');

-- Inserting Sample Datas To product Table
INSERT INTO product (name, price, description) VALUES 
('Product A', 30.00, 'Description of Product A'),
('Product B', 150.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C'),
('Product D', 30.00, 'Description of Product D'),
('Product E', 50.00, 'Description of Product E');

-- Inserting Sample Datas To orders Table
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE(), 80.00),
(2, CURDATE() - INTERVAL 10 DAY, 150.00),
(3, CURDATE() - INTERVAL 10 DAY, 30.00),
(4, CURDATE() - INTERVAL 35 DAY, 40.00),
(5, CURDATE() - INTERVAL 35 DAY, 30.00),
(1, CURDATE() - INTERVAL 35 DAY, 80.00);

-- Viewing Above Created Tables
SELECT * FROM customers;
SELECT * FROM product;
SELECT * FROM orders;

--  Retrieve all customers who have placed an order in the last 30 days

SELECT * FROM customers c
JOIN orders o ON c.id = o.customer_id 
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

--  Get the total amount of all orders placed by each customer.
SELECT c.name,SUM(o.total_amount) AS total_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id

-- Update the price of Product C to 45.00.

SET SQL_SAFE_UPDATES = 0; 
UPDATE product SET price = 45.00 WHERE name="Product C";

--  Add a new column discount to the products table
ALTER TABLE product ADD COLUMN discount DECIMAL(5,2) DEFAULT 0;

--  Retrieve the top 3 products with the highest price.

SELECT * FROM product ORDER BY price DESC LIMIT 3;

-- Join the orders and customers tables to retrieve the customer's name and order date for each order.

SELECT c.name,o.order_date FROM customers c 
JOIN orders o ON o.id = c.id 

-- Retrieve the orders with a total amount greater than 150.00.
SELECT * FROM orders WHERE total_amount >=150;

--  Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,     
    order_id INT,                          
    product_id INT,                     
    quantity INT,                          
    price DECIMAL(10, 2),                  
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

SELECT * FROM order_items

--  Insert sample data into the order_items table
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 30.00),    -- Order 1 has 2 units of Product A at 30.00 each
(1, 2, 1, 150.00),   -- Order 1 also has 1 unit of Product B at 150.00
(2, 3, 3, 40.00),    -- Order 2 has 3 units of Product C at 40.00 each
(3, 1, 1, 30.00),    -- Order 3 has 1 unit of Product 	A at 30.00
(3, 5, 2, 50.00);    -- Order 3 also has 2 units of Product E at 50.00 each

-- Retrieve customers who have ordered Product A
SELECT  c.name 
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN product p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- Retrieve the average total of all orders
SELECT AVG(total_amount) AS average_order_total
FROM orders;
