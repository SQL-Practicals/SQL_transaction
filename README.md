# 📘 SQL Transactions Exercises

This README provides step-by-step SQL examples for practicing transactions, savepoints, rollbacks, and read-only transactions in MariaDB/MySQL.

```sql
-- 1. Setup: Create Database and Table
CREATE DATABASE IF NOT EXISTS ORDERS;
USE ORDERS;
CREATE TABLE ORDERS (
  ORDER_ID INT PRIMARY KEY,
  CUSTOMER_NAME VARCHAR(50),
  PRODUCT_NAME VARCHAR(50),
  QUANTITY INT,
  PRICE DECIMAL(10,2)
);

-- 2. Task 1: Transactional Batch Insert
SET autocommit = 0;
INSERT INTO ORDERS (ORDER_ID, CUSTOMER_NAME, PRODUCT_NAME, QUANTITY, PRICE)
VALUES
  (101, 'John',  'Mouse',    2,  500.00),
  (102, 'Emily', 'Keyboard', 1, 1500.00),
  (103, 'Raj',   'Monitor',  1, 7500.00),
  (104, 'Ali',   'Laptop',   1,55000.00);
COMMIT;
SELECT * FROM ORDERS;

-- 3. Task 2: Mistaken Deletion and Recovery
BEGIN;
DELETE FROM ORDERS WHERE PRICE > 5000;
SELECT * FROM ORDERS;
ROLLBACK;
SELECT * FROM ORDERS;

-- 4. Task 3: Complex Updates with Savepoints
BEGIN;
SAVEPOINT discount1;
UPDATE ORDERS SET PRICE = PRICE * 0.90;
SAVEPOINT discount2;
UPDATE ORDERS SET PRICE = PRICE * 0.95 WHERE QUANTITY = 1;
ROLLBACK TO discount2;
COMMIT;
SELECT * FROM ORDERS;

-- 5. Task 4: Read-Only Transaction Check
SET TRANSACTION READ ONLY;
START TRANSACTION;
DELETE FROM ORDERS WHERE ORDER_ID = 101;  -- expected error: cannot execute in read-only
ROLLBACK;
