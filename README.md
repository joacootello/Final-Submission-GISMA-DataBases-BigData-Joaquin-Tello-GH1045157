# Perfume Store Database Management System

B103 Databases & Big Data – GISMA University of Applied Sciences
Joaquin Tello Alvarado
GH1045157

## About the project:
This project is a relational database for an online perfume shop. I decided to go with this since I have encountered difficulties while buying perfume at perfume stores since they dont have any way to check if they still have stock but looking in the physical inventory. Thats why I think this program is really helpfull for shops like this.

The database saves customer data, orders, also brands and perfumes which includes perfume stock. Now it is all made with MariaDB.

- Report is in canvas

## Files

'database_creation.sql' - This creates the database with the 6 tables, aswell as the keys, restrictions and 2 indexees
'sample_data.sql' - This has invented test data (for example all customer names are fuctional)
'queries.sql' 43 queriers, with the most important marked (for example Q28), also includes CRUD and constraint tests and 6 restriction tests (T1 - T6)

## How to run

1. First open DBeaver and connect to a MariaDB server
2. Then open 'database_creation.sql' and run the whole script by clicking (alt + x)
3. After open 'sample_data.sql' and run it with the same command (alt + x)
4. Last open 'queries.sql' and run the queries one by one ( with the command Ctrl + Enter). Parts 10–11 change data, so run them last. To reset the data, run steps 2–3 again
