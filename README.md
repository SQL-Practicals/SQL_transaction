# 📘 Stocks & Orders Database Exercises

This `README.md` consolidates two sets of SQL exercises:
1. **ORDERS** database: practicing transactions, savepoints, rollbacks, and read-only transactions.
2. **Stocks** database: schema creation, data insertion, queries, and triggers on tables for Laptops, Products, Printers, and Personal Computers.

---

## Ex 1: ORDERS Database Transactions

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
-- Verify
SELECT * FROM ORDERS;

-- 3. Task 2: Mistaken Deletion and Recovery
BEGIN;
DELETE FROM ORDERS WHERE PRICE > 5000;
SELECT * FROM ORDERS;
ROLLBACK;
-- Verify revert
SELECT * FROM ORDERS;

-- 4. Task 3: Complex Updates with Savepoints
BEGIN;
SAVEPOINT discount1;
UPDATE ORDERS SET PRICE = PRICE * 0.90;
SAVEPOINT discount2;
UPDATE ORDERS SET PRICE = PRICE * 0.95 WHERE QUANTITY = 1;
-- Undo only second discount
ROLLBACK TO discount2;
-- Finalize first discount
COMMIT;
-- Verify
SELECT * FROM ORDERS;

-- 5. Task 4: Read-Only Transaction Check
SET TRANSACTION READ ONLY;
START TRANSACTION;
-- This DELETE will error under READ ONLY
DELETE FROM ORDERS WHERE ORDER_ID = 101;
ROLLBACK;
```

---

## Ex 2: Stocks Database Schema, Data, Queries & Triggers

```sql
-- 1. Create Stocks Database
CREATE DATABASE IF NOT EXISTS Stockes;
USE Stockes;

-- 2. Table Definitions
CREATE TABLE Products(
  Maker VARCHAR(10),
  Model INT PRIMARY KEY,
  Type VARCHAR(20)
);

CREATE TABLE Personal_Computers(
  PC_Model INT PRIMARY KEY,
  PC_Speed INT,
  PC_RAM INT,
  PC_HD INT,
  CD_ROM VARCHAR(10),
  PC_Price DECIMAL(10,2),
  FOREIGN KEY(PC_Model) REFERENCES Products(Model)
);

CREATE TABLE Laptops(
  LT_Model INT PRIMARY KEY,
  LT_Speed INT,
  LT_RAM INT,
  LT_HD INT,
  Screen DECIMAL(4,1),
  LT_Price DECIMAL(10,2),
  FOREIGN KEY(LT_Model) REFERENCES Products(Model)
);

CREATE TABLE Printers(
  PR_Model INT PRIMARY KEY,
  Colour BOOLEAN,
  PR_Type VARCHAR(20),
  PR_Price DECIMAL(10,2),
  FOREIGN KEY (PR_Model) REFERENCES Products(Model)
);

-- 3. Data Insertion
INSERT INTO Personal_Computers (PC_Model, PC_Speed, PC_RAM, PC_HD, CD_ROM, PC_Price) VALUES
  (1001,700,64,10,'48XCD',799.00),
  (1002,1500,128,60,'12XCD',2499.00),
  (1003,866,128,20,'8XCD',1999.00),
  (1004,866,64,10,'12XCD',999.00),
  (1005,1000,128,20,'12XCD',1499.00),
  (1006,1300,256,40,'16XCD',2119.00),
  (1007,1400,128,80,'12XCD',2299.00),
  (1008,700,64,30,'24XCD',999.00),
  (1009,1200,128,80,'16XCD',1699.00),
  (1010,750,64,30,'40XCD',699.00),
  (1011,1100,128,60,'16XCD',1299.00),
  (1012,350,64,7,'48XCD',799.00),
  (1013,733,256,60,'12XCD',2499.00);

INSERT INTO Laptops (LT_Model, LT_Speed, LT_RAM, LT_HD, Screen, LT_Price) VALUES
  (2001,700,64,5,12.1,1448.00),
  (2002,800,96,10,15.1,2584.00),
  (2003,850,64,10,15.1,2738.00),
  (2004,550,32,5,12.1,999.00),
  (2005,600,64,6,12.1,2399.00),
  (2006,800,96,20,15.7,2999.00),
  (2007,850,128,20,15.0,3099.00),
  (2008,650,64,10,12.1,1249.00),
  (2009,750,256,20,15.1,2599.00),
  (2010,366,64,10,12.1,1499.00);

INSERT INTO Printers (PR_Model, Colour, PR_Type, PR_Price) VALUES
  (3001,TRUE,'ink-jet',231.00),
  (3002,TRUE,'ink-jet',267.00),
  (3003,FALSE,'laser',390.00),
  (3004,TRUE,'ink-jet',439.00),
  (3005,TRUE,'bubble',200.00),
  (3006,TRUE,'laser',1999.00),
  (3007,FALSE,'laser',350.00);

INSERT INTO Products (Maker, Model, Type) VALUES
  ('A',1001,'pc'),('A',1002,'pc'),('A',1003,'pc'),
  ('A',2004,'laptop'),('A',2005,'laptop'),('A',2006,'laptop'),
  ('B',1004,'pc'),('B',1005,'pc'),('B',1006,'pc'),
  ('B',2001,'laptop'),('B',2002,'laptop'),('B',2003,'laptop'),
  ('C',1007,'pc'),('C',1008,'pc'),('C',2008,'laptop'),
  ('C',2009,'laptop'),('C',3002,'printer'),('C',3003,'printer'),('C',3006,'printer'),
  ('D',1009,'pc'),('D',1010,'pc'),('D',1011,'pc'),('D',2007,'laptop'),
  ('E',1012,'pc'),('E',1013,'pc'),('E',2010,'laptop'),
  ('F',3001,'printer'),('F',3004,'printer'),('G',3005,'printer'),('H',3007,'printer');

-- 4. Sample Queries
SELECT * FROM Laptops WHERE LT_Speed > 800;
SELECT * FROM Laptops WHERE LT_RAM = 64;
/* ... additional queries as in previous sections ... */

-- 5. Triggers
-- 5.1 Validate PC RAM on Insert
DELIMITER //
CREATE TRIGGER chk_pc_ram
BEFORE INSERT ON Personal_Computers
FOR EACH ROW
BEGIN
  IF NEW.PC_RAM NOT IN (64,128,256) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RAM must be 64,128, or 256';
  END IF;
END;//
DELIMITER ;

-- 5.2 Backup & Double Printer Prices
CREATE TABLE Printer_Backup(
  PR_Model INT,
  Old_Price DECIMAL(10,2)
);
DELIMITER //
CREATE TRIGGER backup_and_double
BEFORE UPDATE ON Printers
FOR EACH ROW
BEGIN
  INSERT INTO Printer_Backup VALUES(OLD.PR_Model, OLD.PR_Price);
  SET NEW.PR_Price = OLD.PR_Price*2;
END;//
DELIMITER ;

-- 5.3 Archive Deleted Printer Products
CREATE TABLE Deleted_Printers(
  Maker CHAR(1),
  Model INT,
  Type VARCHAR(20)
);
DELIMITER //
CREATE TRIGGER archive_printer_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
  IF OLD.Type='printer' THEN
    INSERT INTO Deleted_Printers VALUES(OLD.Maker,OLD.Model,OLD.Type);
  END IF;
END;//
DELIMITER ;
-- Demonstrations for Triggers

-- Q1 True case (valid RAM)
INSERT INTO Personal_Computers (PC_Model, PC_Speed, PC_RAM, PC_HD, CD_ROM, PC_Price)
VALUES (1014,  800, 128, 20, '12XCD', 1500.00);

-- Q1 False case (invalid RAM)
INSERT INTO Personal_Computers (PC_Model, PC_Speed, PC_RAM, PC_HD, CD_ROM, PC_Price)
VALUES (1015,  800, 512, 20, '12XCD', 1500.00);
-- Expected error: RAM must be 64,128, or 256

-- Q2 Update a printer to trigger backup and doubling
UPDATE Printers
SET PR_Price = PR_Price
WHERE PR_Model = 3001;
SELECT * FROM Printer_Backup WHERE PR_Model = 3001;
SELECT * FROM Printers WHERE PR_Model = 3001;

-- Q3 Delete a printer-product to trigger archiving
DELETE FROM Products WHERE Model = 3002 AND Type = 'printer';
SELECT * FROM Deleted_Printers;
```
