# Please just run one at the time not all at once
USE perfume_store;



# 1 - BASIC SELECT

# whole cataloge
SELECT *
FROM perfumes;

# just name and price
SELECT perfume_name, price
FROM perfumes;

# table structure
DESCRIBE orders;


# 2 - FILTERS WITH WHERE


# perfume < 60 euros
SELECT perfume_name, price
FROM perfumes
WHERE price < 60;

# perfume available < 100 euros
SELECT perfume_name, size_ml, price, stock
FROM perfumes
WHERE stock > 0 AND price < 100;

# alert in case there are less than 5 perfumes of a category
SELECT perfume_name, size_ml, stock
FROM perfumes
WHERE stock <= 5;

# customer from spain or germany
SELECT first_name, last_name, country
FROM customers
WHERE country IN ('Spain', 'Germany');

# search perfume by par of name
SELECT perfume_name, size_ml, price
FROM perfumes
WHERE perfume_name LIKE '%Lumiere%';

# customers with gmail
SELECT first_name, last_name, email
FROM customers
WHERE email LIKE '%@gmail.com';

# customer without phone num
SELECT first_name, last_name
FROM customers
WHERE phone_number IS NULL;

# 2025 orders
SELECT *
FROM orders
WHERE order_date >= '2025-01-01' AND order_date <= '2025-12-31';

# orders still needing action
SELECT *
FROM orders
WHERE order_status = 'PENDING' OR order_status = 'PAID' OR order_status = 'SHIPPED';


# 3 - ORDER BY & DISTINCT


# most expensive to cheapest 
SELECT perfume_name, size_ml, price
FROM perfumes
ORDER BY price DESC;

# recent order first
SELECT order_id, order_date, order_status
FROM orders
ORDER BY order_date DESC;

# country with customers
SELECT DISTINCT country
FROM customers;


# 4 - TEXT AND DATE FUNCTIONS


# name and country in capital letter
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
       UPPER(country) AS country
FROM customers;

# month and year of each order
SELECT order_id, order_date, YEAR(order_date) AS order_year, MONTH(order_date) AS order_month
FROM orders;

# num of days that a customer has been registered
SELECT first_name, last_name, registration_date,
       DATEDIFF(CURRENT_DATE, registration_date) AS days_registered
FROM customers;

# last 365 days orders
SELECT *
FROM orders
WHERE DATEDIFF(CURRENT_DATE, order_date) < 365;


# 5 - AGGREGATE FUNCTIONS


# amount of customers
SELECT COUNT(*) AS number_of_customers
FROM customers;

# amount of orders
SELECT COUNT(*) AS number_of_orders
FROM orders;

# perfume price
SELECT AVG(price) AS average_price,
       MIN(price) AS cheapest,
       MAX(price) AS most_expensive
FROM perfumes;

# total recieved and the largest one
SELECT SUM(amount) AS total_revenue,
       MIN(amount) AS smallest_payment,
       MAX(amount) AS largest_payment
FROM payments;

# value in warehouse
SELECT SUM(price * stock) AS stock_value
FROM perfumes;


# 6 - GROUP BY


# customers per country
SELECT country, COUNT(*) AS number_of_customers
FROM customers
GROUP BY country
ORDER BY number_of_customers DESC;

# order per status
SELECT order_status, COUNT(*) AS number_of_orders
FROM orders
GROUP BY order_status;

# order per customer
SELECT customer_id, COUNT(*) AS number_of_orders
FROM orders
GROUP BY customer_id
ORDER BY number_of_orders DESC;

# Q28 total of each order
SELECT order_id, SUM(quantity * price_each) AS order_total
FROM order_details
GROUP BY order_id;

# revenue per payment
SELECT payment_method, COUNT(*) AS payments, SUM(amount) AS revenue
FROM payments
GROUP BY payment_method;

# revenue per year
SELECT YEAR(payment_date) AS pay_year, MONTH(payment_date) AS pay_month, SUM(amount) AS revenue
FROM payments
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY pay_year, pay_month;


# 7 - JOINS


# perfume with name of brand
SELECT perfumes.perfume_name, perfumes.size_ml, perfumes.price, brands.brand_name
FROM perfumes
INNER JOIN brands ON perfumes.brand_id = brands.brand_id;

# orders with name of customer
SELECT orders.order_id, orders.order_date, orders.order_status,
       customers.first_name, customers.last_name
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;

# total perfumes per brand searched my name
SELECT perfumes.perfume_name, perfumes.price, brands.brand_name
FROM perfumes
INNER JOIN brands ON perfumes.brand_id = brands.brand_id
WHERE brands.brand_name = 'Desert Pearl';

# content of order 3
SELECT order_details.order_id, perfumes.perfume_name, order_details.quantity,
       order_details.price_each,
       order_details.quantity * order_details.price_each AS line_total
FROM order_details
INNER JOIN perfumes ON order_details.perfume_id = perfumes.perfume_id
WHERE order_details.order_id = 3;

# Q35 amount spent per customer and amount of paid orders
SELECT customers.customer_id, customers.first_name, customers.last_name,
       COUNT(payments.payment_id) AS paid_orders,
       SUM(payments.amount) AS total_spent
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
INNER JOIN payments ON orders.order_id = payments.order_id
GROUP BY customers.customer_id, customers.first_name, customers.last_name
ORDER BY total_spent DESC;

# best-selling perfumes
SELECT perfumes.perfume_name, perfumes.size_ml, SUM(order_details.quantity) AS units_sold
FROM order_details
INNER JOIN perfumes ON order_details.perfume_id = perfumes.perfume_id
INNER JOIN orders ON order_details.order_id = orders.order_id
WHERE orders.order_status <> 'CANCELLED'
GROUP BY perfumes.perfume_id, perfumes.perfume_name, perfumes.size_ml
ORDER BY units_sold DESC;

# Q37 sales per brand without considering cancelled orders
SELECT brands.brand_name,
       SUM(order_details.quantity) AS units_sold,
       SUM(order_details.quantity * order_details.price_each) AS brand_revenue
FROM order_details
INNER JOIN perfumes ON order_details.perfume_id = perfumes.perfume_id
INNER JOIN brands ON perfumes.brand_id = brands.brand_id
INNER JOIN orders ON order_details.order_id = orders.order_id
WHERE orders.order_status <> 'CANCELLED'
GROUP BY brands.brand_name
ORDER BY brand_revenue DESC;

# Q38 full sale report
SELECT orders.order_id, orders.order_date,
       CONCAT(customers.first_name, ' ', customers.last_name) AS customer,
       brands.brand_name, perfumes.perfume_name,
       order_details.quantity, order_details.price_each
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN perfumes ON order_details.perfume_id = perfumes.perfume_id
INNER JOIN brands ON perfumes.brand_id = brands.brand_id
ORDER BY orders.order_id;

# Q39 control: payment matches total?
SELECT orders.order_id, payments.amount AS amount_paid,
       SUM(order_details.quantity * order_details.price_each) AS order_total
FROM orders
INNER JOIN payments ON orders.order_id = payments.order_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_id, payments.amount;


# 8 - CASE


# price category for each perfume
SELECT perfume_name, size_ml, price,
    CASE
        WHEN price < 60  THEN 'Budget'
        WHEN price < 150 THEN 'Mid-range'
        ELSE 'Premium'
    END AS price_category
FROM perfumes
ORDER BY price;

# stock status for perfume
SELECT perfume_name, size_ml, stock,
    CASE
        WHEN stock = 0  THEN 'OUT OF STOCK'
        WHEN stock <= 5 THEN 'LOW STOCK'
        ELSE 'OK'
    END AS stock_status
FROM perfumes;


# PART 9 - INDEXES


# indexed of perfume table list
SHOW INDEX FROM perfumes;

# Q43 check if the index is used (look at column key)
EXPLAIN SELECT * FROM perfumes WHERE perfume_name = 'Oud Royale';


# 10 - CRUD: changes the data, runs once


# new customer today
INSERT INTO customers (first_name, last_name, email, phone_number, registration_date, country)
VALUES ('Clara', 'Nowak', 'clara.nowak@gmail.com', '+48601234567', CURRENT_DATE, 'Poland');

# new brand and perfume
INSERT INTO brands (brand_name, country)
VALUES ('Atelier Brume', 'Belgium');

INSERT INTO perfumes (perfume_name, concentration, size_ml, price, stock, brand_id)
VALUES ('Brume Grise', 'EDT', 100, 64.00, 15, 7);

# Clara (new customer)
INSERT INTO orders (order_date, customer_id)
VALUES (CURRENT_DATE, 11);

INSERT INTO order_details (order_id, perfume_id, quantity, price_each)
VALUES (17, 16, 1, 64.00),
       (17, 6,  1, 42.00);

# check new order
SELECT *
FROM orders
WHERE order_id = 17;

# fist clara pays then it registers the payment and does changes
INSERT INTO payments (payment_date, payment_method, amount, order_id)
VALUES (CURRENT_DATE, 'CARD', 106.00, 17);

UPDATE orders
SET order_status = 'PAID'
WHERE order_id = 17;

UPDATE perfumes
SET stock = stock - 1
WHERE perfume_id = 16 OR perfume_id = 6;

# customer changes phone number
UPDATE customers
SET phone_number = '+4915199998888'
WHERE customer_id = 2;

# price increase of 5% in a brand
UPDATE perfumes
SET price = price * 1.05
WHERE brand_id = 6;

# check updates
SELECT perfume_id, perfume_name, price, stock
FROM perfumes
WHERE perfume_id IN (6, 12, 13, 14, 16);

# test customer created and deleted
INSERT INTO customers (first_name, last_name, email, registration_date, country)
VALUES ('Test', 'User', 'test.user@example.com', CURRENT_DATE, 'Germany');

DELETE FROM customers
WHERE email = 'test.user@example.com';

SELECT *
FROM customers
WHERE email = 'test.user@example.com';   # returns 0 rows: it was deleted


# PART 11 - CONSTRAINT TESTS
#This are all statements meant to fail

# T1. FOREIGN KEY: cannot delete a customer who has orders (error 1451)
# DELETE FROM customers WHERE customer_id = 1

# T2. UNIQUE: cannot register the same email twice (error 1062)
# INSERT INTO customers (first_name, last_name, email, registration_date, country)
# VALUES ('Lucia', 'Copy', 'lucia.fernandez@gmail.com', CURRENT_DATE, 'Spain')

# T3. FOREIGN KEY: cannot create a perfume for a brand that does not exist (error 1452)
# INSERT INTO perfumes (perfume_name, concentration, size_ml, price, stock, brand_id)
# VALUES ('Ghost Perfume', 'EDP', 50, 80.00, 5, 99)

# T4. CHECK: stock cannot be negative (error 4025)
# UPDATE perfumes SET stock = -3 WHERE perfume_id = 1

# T5. UNIQUE: an order cannot be paid twice (1:1 relationship) (error 1062)
# INSERT INTO payments (payment_date, payment_method, amount, order_id)
# VALUES (CURRENT_DATE, 'CARD', 182.50, 1)

# T6. NOT NULL: a perfume must have a price (error 1364 or 1048)
# INSERT INTO perfumes (perfume_name, concentration, size_ml, stock, brand_id)
# VALUES ('No Price', 'EDT', 50, 10, 1)
