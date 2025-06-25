  -- SQL Transactions --
  
CREATE DATABASE ORDERS;
 USE ORDERS;
-- Task 1: Transactional Batch Operation  --
--Create a table called ORDERS with the following structure: --
CREATE TABLE ORDERS(
	ORDER_ID INT PRIMARY KEY,
	CUSTOMER_NAME VARCHAR(50),
	PRODUCT_NAME VARCHAR(50),
	QUANTITY INT,
	PRICE DECIMAL(10,2)
);
Query OK, 0 rows affected (0.028 sec)


-- Insert the following records within a transaction: --
INSERT INTO ORDERS
(ORDER_ID,CUSTOMER_NAME,PRODUCT_NAME,QUANTITY,PRICE)
VALUES
(101, 'John', 'Mouse', 2, 500.00),
(102, 'Emily', 'Keyboard', 1, 1500.00), 
(103, 'Raj', 'Monitor', 1, 7500.00), 
(104, 'Ali', 'Laptop', 1, 55000.00);
Query OK, 4 rows affected (0.056 sec)
Records: 4  Duplicates: 0  Warnings: 0


--- After insertion, use COMMIT to save the transaction.--
SET autocommit = 0;
Query OK, 0 rows affected (0.005 sec)

-- Verify with: SELECT * FROM ORDERS; --
SELECT *
FROM ORDERS;
+----------+---------------+--------------+----------+----------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE    |
+----------+---------------+--------------+----------+----------+
|      101 | John          | Mouse        |        2 |   500.00 |
|      102 | Emily         | Keyboard     |        1 |  1500.00 |
|      103 | Raj           | Monitor      |        1 |  7500.00 |
|      104 | Ali           | Laptop       |        1 | 55000.00 |
+----------+---------------+--------------+----------+----------+
4 rows in set (0.007 sec)



-- Task 2: Mistaken Deletion and Recovery  
--Start a transaction and delete orders where PRICE > 5000. However, suppose this was a mistake. Use ROLLBACK to undo the deletion.--
-- Display the table again and verify the records are intact. --
BEGIN;
Query OK, 2 rows affected (0.004 sec)

DELETE 
FROM ORDERS
WHERE PRICE > 5000;
Query OK, 2 rows affected (0.004 sec)

SELECT * FROM ORDERS;
+----------+---------------+--------------+----------+---------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE   |
+----------+---------------+--------------+----------+---------+
|      101 | John          | Mouse        |        2 |  500.00 |
|      102 | Emily         | Keyboard     |        1 | 1500.00 |
+----------+---------------+--------------+----------+---------+
2 rows in set (0.000 sec)


ROLLBACK;
Query OK, 0 rows affected (0.006 sec)

SELECT * FROM ORDERS;
+----------+---------------+--------------+----------+----------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE    |
+----------+---------------+--------------+----------+----------+
|      101 | John          | Mouse        |        2 |   500.00 |
|      102 | Emily         | Keyboard     |        1 |  1500.00 |
|      103 | Raj           | Monitor      |        1 |  7500.00 |
|      104 | Ali           | Laptop       |        1 | 55000.00 |
+----------+---------------+--------------+----------+----------+
4 rows in set (0.000 sec)




--Task 3: Using Savepoints in Complex Updates  
--You are asked to reduce the price of all products as part of a --clearance sale: 
--1. Start a transaction.
BEGIN;
Query OK, 0 rows affected (0.000 sec)

--2. Create a SAVEPOINT before each update: - Reduce price of all -items by 10%. 
SAVEPOINT discount1;
Query OK, 0 rows affected (0.001 sec)

UPDATE ORDERS
SET PRICE = PRICE * 0.90;
Query OK, 4 rows affected (0.006 sec)
Rows matched: 4  Changed: 4  Warnings: 0

SELECT * FROM ORDERS;
+----------+---------------+--------------+----------+----------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE    |
+----------+---------------+--------------+----------+----------+
|      101 | John          | Mouse        |        2 |   450.00 |
|      102 | Emily         | Keyboard     |        1 |  1350.00 |
|      103 | Raj           | Monitor      |        1 |  6750.00 |
|      104 | Ali           | Laptop       |        1 | 49500.00 |
+----------+---------------+--------------+----------+----------+
4 rows in set (0.000 sec)

--Further reduce price of products with QUANTITY = 1 by an --additional 5%.
SAVEPOINT discount2;
Query OK, 0 rows affected (0.000 sec)

UPDATE ORDERS
SET PRICE = PRICE * 0.95
WHERE QUANTITY = 1;

SELECT * FROM ORDERS;
+----------+---------------+--------------+----------+----------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE    |
+----------+---------------+--------------+----------+----------+
|      101 | John          | Mouse        |        2 |   450.00 |
|      102 | Emily         | Keyboard     |        1 |  1282.50 |
|      103 | Raj           | Monitor      |        1 |  6412.50 |
|      104 | Ali           | Laptop       |        1 | 47025.00 |
+----------+---------------+--------------+----------+----------+
4 rows in set (0.000 sec)


--3. After executing all updates, realize the second reduction was --too much. 
--4. Use ROLLBACK TO SAVEPOINT to undo only the second change. 
ROLLBACK to discount2;
Query OK, 0 rows affected (0.000 sec)
+----------+---------------+--------------+----------+----------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE    |
+----------+---------------+--------------+----------+----------+
|      101 | John          | Mouse        |        2 |   450.00 |
|      102 | Emily         | Keyboard     |        1 |  1350.00 |
|      103 | Raj           | Monitor      |        1 |  6750.00 |
|      104 | Ali           | Laptop       |        1 | 49500.00 |
+----------+---------------+--------------+----------+----------+
4 rows in set (0.000 sec)

--5. Use COMMIT to finalize the first update. 
COMMIT;
Query OK, 0 rows affected (0.006 sec)

--Show the final result of the ORDERS table.
SELECT * FROM ORDERS;
+----------+---------------+--------------+----------+----------+
| ORDER_ID | CUSTOMER_NAME | PRODUCT_NAME | QUANTITY | PRICE    |
+----------+---------------+--------------+----------+----------+
|      101 | John          | Mouse        |        2 |   450.00 |
|      102 | Emily         | Keyboard     |        1 |  1350.00 |
|      103 | Raj           | Monitor      |        1 |  6750.00 |
|      104 | Ali           | Laptop       |        1 | 49500.00 |
+----------+---------------+--------------+----------+----------+
4 rows in set (0.001 set (0.001 sec)



 
 --Task 4: Read-Only Transaction Check  
---Try the following using SET TRANSACTION READ ONLY: 
--1. Start a read-only transaction. 
SET TRANSACTION READ ONLY;
Query OK, 0 rows affected (0.000 sec)

START TRANSACTION;
Query OK, 0 rows affected (0.000 sec)

--2. Attempt to DELETE or UPDATE a record from ORDERS. 
DELETE 
FROM ORDERS 
WHERE ORDER_ID = 101;
ERROR 1792 (25006): Cannot execute statement in a READ ONLY transaction

--3. Observe and explain the result. 
ERROR 1792 (25006): Cannot execute statement in a READ ONLY transaction

--4. End the transaction.
ROLLBACK;
Query OK, 0 rows affected (0.000 sec)