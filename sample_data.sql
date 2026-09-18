#this is test data and all names are invented
# first tables without foreing keys and after the rest
USE perfume_store;


# CUSTOMERS

INSERT INTO customers (first_name, last_name, email, phone_number, registration_date, country)
VALUES
('Lucia','Fernandez','lucia.fernandez@gmail.com','+34612345678','2025-01-14','Spain'),
('Jonas','Becker','jonas.becker@web.de','+4915123456789','2025-02-03','Germany'),
('Camille','Martin','camille.martin@orange.fr','+33612345678','2025-03-21','France'),
('Marco','Rossi','marco.rossi@libero.it','+393471234567','2025-04-09','Italy'),
('Emma','devries','emma.devries@gmail.com',NULL,'2025-05-30','Netherlands'),
('Sofia','Schneider','sofia.schneider@gmx.de','+4917698765432','2025-07-12','Germany'),
('Diego','Ramirez','diego.ramirez@hotmail.com','+51987654321','2025-09-02','Peru'),
('Oliver','Hughes','oliver.hughes@outlook.com','+447700900123','2025-11-18','United Kingdom'),
('Ana','Torres','ana.torres@gmail.com',NULL,'2026-01-25','Spain'),
('Lukas','Weber','lukas.weber@gmail.com','+4916012345678','2026-06-10','Germany');


# BRANDS

INSERT INTO brands (brand_name, country)
VALUES
('Maison Lumiere','France'),
('Velvet & Oak','United Kingdom'),
('Nordic Bloom','Sweden'),
('Casa Azahar','Spain'),
('Terra di Siena','Italy'),
('Desert Pearl','United Arab Emirates');


# PERFUMES - varied in prices, concentration, sizes and stock

INSERT INTO perfumes (perfume_name, concentration, size_ml, price, stock, brand_id)
VALUES
('Lumiere Blanche','EDP', 50, 78.00, 25, 1),
('Lumiere Blanche','EDP', 100, 115.00, 12, 1),
('Nuit de Soie','Parfum', 50, 145.00, 6, 1),
('Oak & Amber','EDP', 100, 98.50, 18, 2),
('Black Velvet','Parfum', 75, 210.00, 3, 2),
('Frost Lily','EDT', 50, 42.00, 40, 3),
('Midnight Pine','EDT', 100, 59.90, 0, 3),
('Azahar del Sur','EDC', 100, 29.95, 55, 4),
('Brisa Mediterranea','EDT', 100, 49.00, 30, 4),
('Rosa Toscana','EDP', 50, 69.00, 4, 5),
('Cipresso Nero','EDP', 100, 105.00, 9, 5),
('Oud Royale','Parfum', 50, 260.00, 2, 6),
('Golden Dune','EDP', 100, 175.00, 7, 6),
('Saffron Mist','EDP', 75,  132.00, 0, 6),
('Citrus Garden','EDC', 200, 35.00, 22, 4);


# ORDERS - from February 2025 to September 2026

INSERT INTO orders (order_date, order_status, customer_id)
VALUES
('2025-02-15', 'DELIVERED', 2),
('2025-03-02', 'DELIVERED', 1),
('2025-04-18', 'DELIVERED', 3),
('2025-05-05', 'DELIVERED', 4),
('2025-06-21', 'DELIVERED', 1),
('2025-08-11', 'DELIVERED', 5),
('2025-09-30', 'DELIVERED', 6),
('2025-11-27', 'DELIVERED', 7),
('2025-12-15', 'DELIVERED', 8),
('2026-01-08', 'CANCELLED', 2), #(never paid)
('2026-02-14', 'DELIVERED', 3),
('2026-04-03', 'DELIVERED', 9),
('2026-06-19', 'SHIPPED', 1),
('2026-08-25', 'SHIPPED', 4),
('2026-09-10', 'PAID', 6),
('2026-09-15', 'PENDING', 8); #(not paid yet)


# ORDER_DETAILS - some orders contain more than one perfume.

INSERT INTO order_details (order_id, perfume_id, quantity, price_each)
VALUES
(1, 4, 1, 98.50),
(1, 6, 2, 42.00),
(2, 8, 1, 27.50),
(3, 3, 1, 145.00),
(3, 1,  1, 78.00),
(4, 11, 1, 105.00),
(5, 9, 2, 49.00),
(5, 15, 1, 35.00),
(6, 12, 1, 260.00),
(7, 2, 1, 115.00),
(7, 10, 1, 69.00),
(8, 13, 1, 175.00),
(8, 8, 2, 29.95),
(9, 5, 1, 210.00),
(9, 4, 1, 98.50),
(10, 7, 1, 59.90),
(11, 10, 2, 69.00),
(12, 6, 1, 42.00),
(12, 9, 1, 49.00),
(12, 15, 1, 35.00),
(13, 14, 1, 132.00),
(14, 3, 1, 145.00),
(14, 11, 1, 105.00),
(15, 1, 2, 78.00),
(16, 13, 1, 175.00);


# PAYMENTS from order 10 and 16 is not paid either is cancelled or pending

INSERT INTO payments (payment_date, payment_method, amount, order_id)
VALUES
('2025-02-15', 'CARD', 182.50, 1),
('2025-03-02', 'PAYPAL', 27.50, 2),
('2025-04-18', 'CARD', 223.00, 3),
('2025-05-06', 'BANK_TRANSFER', 105.00, 4),
('2025-06-21', 'PAYPAL', 133.00, 5),
('2025-08-11', 'CARD', 260.00, 6),
('2025-09-30', 'CARD', 184.00, 7),
('2025-11-28', 'BANK_TRANSFER', 234.90, 8),
('2025-12-15', 'PAYPAL', 308.50, 9),
('2026-02-14', 'CARD', 138.00, 11),
('2026-04-03', 'PAYPAL', 126.00, 12),
('2026-06-19', 'CARD', 132.00, 13),
('2026-08-26', 'BANK_TRANSFER', 250.00, 14),
('2026-09-10', 'CARD', 156.00, 15);

# Quick check of num of rows per table
SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS brands FROM brands;
SELECT COUNT(*) AS perfumes FROM perfumes;
SELECT COUNT(*) AS orders FROM orders;
SELECT COUNT(*) AS order_details FROM order_details;
SELECT COUNT(*) AS payments FROM payments;
