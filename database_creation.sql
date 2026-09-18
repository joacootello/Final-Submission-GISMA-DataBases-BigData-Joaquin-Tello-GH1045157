# For the creation of the database and also for the 6 tables
DROP SCHEMA IF EXISTS perfume_store;
CREATE SCHEMA perfume_store;
USE perfume_store;


# 1. CUSTOMERS

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,   # this is so there are no customers with the same email :).
    phone_number VARCHAR(20),
    registration_date DATE NOT NULL,
    country VARCHAR(50) NOT NULL
);


# 2. BRANDS - perfume companies (stored once, referenced by many perfumes)

CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(50) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL
);


# 3. PERFUMES - all products for sale, also each size is for different products for example (50ml or 100ml)

CREATE TABLE perfumes (
    perfume_id INT AUTO_INCREMENT PRIMARY KEY,
    perfume_name VARCHAR(100) NOT NULL,
    concentration VARCHAR(10) NOT NULL,
    size_ml INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    brand_id INT NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    CHECK (concentration IN ('Parfum', 'EDP', 'EDT', 'EDC')),
    CHECK (size_ml > 0),
    CHECK (price > 0),
    CHECK (stock >= 0)
);


# 4. ORDERS - one row per purchase made by a customer.
# So here is NO total_amount column. The total is calculated from order_details, this so it doesnt contradict oder orders

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CHECK (order_status IN ('PENDING', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED'))
);


# 5. ORDER_DETAILS - junction table that connects orders and perfumes 
# price_each: this is the price paid at the moment (it might change in the future) because perfumes.price could change later

CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    perfume_id INT NOT NULL,
    quantity INT NOT NULL,
    price_each DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (perfume_id) REFERENCES perfumes(perfume_id),
    UNIQUE (order_id, perfume_id),      		 # this basically can be once per order
    CHECK (quantity > 0),
    CHECK (price_each > 0)
);


# 6. PAYMENTS - maximum 1 payment per order no more and unpaid orders have no row here

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    order_id INT NOT NULL UNIQUE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CHECK (payment_method IN ('CARD', 'PAYPAL', 'BANK_TRANSFER')),
    CHECK (amount > 0)
);


# 7. INDEXES
# this for searching by perfume name and date, also PX, UNIQUE and FX already have index automatically

CREATE INDEX idx_perfumes_name ON perfumes(perfume_name);
CREATE INDEX idx_orders_date   ON orders(order_date);


# Result checking :)
SHOW TABLES;
DESCRIBE perfumes;
