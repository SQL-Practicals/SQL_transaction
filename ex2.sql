 ------   SQL Transaction ----
 
 CREATE DATABASE CustomersDB;
 
 USE CustomersDB;
 
 1.create table CUSTOMERS
 CREATE TABLE CUSTOMERS(
	ID INT NOT NULL,
	NAME VARCHAR(20) NOT NULL,
	AGE INT NOT NULL,
	ADDRESS CHAR(25),
	SALARY DECIMAL(18,2),
	PRIMARY KEY(ID)
);
Query OK, 0 rows affected (0.022 sec)


INSERT INTO Customers
(ID,NAME,AGE,ADDRESS,SALARY)
VALUES
(1,'Ramesh',32,'Ahmedabad',2000.00), 
(2,'Khilan',25,'Delhi',1500.00), 
(3,'Kaushik',23,'Kota',2000.00), 
(4,'Chaitali',25,'Mumbai',6500.00), 
(5,'Hardik',27,'Bhopal',8500.00), 
(6,'Komal',22,'Hyderabad',4500.00), 
(7,'Mufy',24,'Indore',1000.00);

SET autocommit = 0;

DELETE Customers
FROM Customers
WHERE age = 25;

SELECT * FROM Customers;
+----+---------+-----+-----------+---------+
| ID | NAME    | AGE | ADDRESS   | SALARY  |
+----+---------+-----+-----------+---------+
|  1 | Ramesh  |  32 | Ahmedabad | 2000.00 |
|  3 | Kaushik |  23 | Kota      | 2000.00 |
|  5 | Hardik  |  27 | Bhopal    | 8500.00 |
|  6 | Komal   |  22 | Hyderabad | 4500.00 |
|  7 | Mufy    |  24 | Indore    | 1000.00 |
+----+---------+-----+-----------+---------+
5 rows in set (0.004 sec)

exit;

mysql -u root -p 
(password)

use CustomersDB;

SELECT * FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  1 | Ramesh   |  32 | Ahmedabad | 2000.00 |
|  2 | Khilan   |  25 | Delhi     | 1500.00 |
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+


---using commit 
DELETE 
from Customers
WHERE age =25;
Query OK, 2 rows affected (0.006 sec)

SELECT *
FROM Customers;
+----+---------+-----+-----------+---------+
| ID | NAME    | AGE | ADDRESS   | SALARY  |
+----+---------+-----+-----------+---------+
|  1 | Ramesh  |  32 | Ahmedabad | 2000.00 |
|  3 | Kaushik |  23 | Kota      | 2000.00 |
|  5 | Hardik  |  27 | Bhopal    | 8500.00 |
|  6 | Komal   |  22 | Hyderabad | 4500.00 |
|  7 | Mufy    |  24 | Indore    | 1000.00 |
+----+---------+-----+-----------+---------+
5 rows in set (0.000 sec)

commit;
 5 rows in set (0.000 sec)
 
exit;

mysql -u root -p 
(password)

use CustomersDB;

SELECT *
FROM Customers;
+----+---------+-----+-----------+---------+
| ID | NAME    | AGE | ADDRESS   | SALARY  |
+----+---------+-----+-----------+---------+
|  1 | Ramesh  |  32 | Ahmedabad | 2000.00 |
|  3 | Kaushik |  23 | Kota      | 2000.00 |
|  5 | Hardik  |  27 | Bhopal    | 8500.00 |
|  6 | Komal   |  22 | Hyderabad | 4500.00 |
|  7 | Mufy    |  24 | Indore    | 1000.00 |
+----+---------+-----+-----------+---------+


DROP TABLE Customers;


CREATE TABLE CUSTOMERS(
	ID INT NOT NULL,
	NAME VARCHAR(20) NOT NULL,
	AGE INT NOT NULL,
	ADDRESS CHAR(25),
	SALARY DECIMAL(18,2),
	PRIMARY KEY(ID)
);
Query OK, 0 rows affected (0.022 sec)


INSERT INTO Customers
(ID,NAME,AGE,ADDRESS,SALARY)
VALUES
(1,'Ramesh',32,'Ahmedabad',2000.00), 
(2,'Khilan',25,'Delhi',1500.00), 
(3,'Kaushik',23,'Kota',2000.00), 
(4,'Chaitali',25,'Mumbai',6500.00), 
(5,'Hardik',27,'Bhopal',8500.00), 
(6,'Komal',22,'Hyderabad',4500.00), 
(7,'Mufy',24,'Indore',1000.00);

SELECT *
from Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  1 | Ramesh   |  32 | Ahmedabad | 2000.00 |
|  2 | Khilan   |  25 | Delhi     | 1500.00 |
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+

START TRANSACTION;

DELETE
FROM Customers
WHERE AGE = 25;

SELECT *
FROM Customers;
+----+---------+-----+-----------+---------+
| ID | NAME    | AGE | ADDRESS   | SALARY  |
+----+---------+-----+-----------+---------+
|  1 | Ramesh  |  32 | Ahmedabad | 2000.00 |
|  3 | Kaushik |  23 | Kota      | 2000.00 |
|  5 | Hardik  |  27 | Bhopal    | 8500.00 |
|  6 | Komal   |  22 | Hyderabad | 4500.00 |
|  7 | Mufy    |  24 | Indore    | 1000.00 |
+----+---------+-----+-----------+---------+
5 rows in set (0.000 sec)

ROLLBACK;

SELECT *
FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  1 | Ramesh   |  32 | Ahmedabad | 2000.00 |
|  2 | Khilan   |  25 | Delhi     | 1500.00 |
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+
7 rows in set (0.000 sec)

SAVEPOINT SP1;
Query OK, 0 rows affected (0.000 sec)

DELETE 
FROM Customers
WHERE ID = 1;
Query OK, 1 row affected (0.003 sec)

SELECT *
FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  2 | Khilan   |  25 | Delhi     | 1500.00 |
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+
6 rows in set (0.000 sec)


SAVEPOINT SP2;
DELETE
FROM Customers
WHERE ID =2;

SELECT *
FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+
5 rows in set (0.000 sec)


SAVEPOINT SP3;
DELETE
FROM Customers
WHERE ID = 3;

SELECT *
FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+
4 rows in set (0.000 sec)


ROLLBACK TO SAVEPOINT SP2;

SELECT *
FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  2 | Khilan   |  25 | Delhi     | 1500.00 |
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+
6 rows in set (0.000 sec)

ROLLBACK TO SAVEPOINT SP1;
 
SELECT *
FROM Customers;
+----+----------+-----+-----------+---------+
| ID | NAME     | AGE | ADDRESS   | SALARY  |
+----+----------+-----+-----------+---------+
|  1 | Ramesh   |  32 | Ahmedabad | 2000.00 |
|  2 | Khilan   |  25 | Delhi     | 1500.00 |
|  3 | Kaushik  |  23 | Kota      | 2000.00 |
|  4 | Chaitali |  25 | Mumbai    | 6500.00 |
|  5 | Hardik   |  27 | Bhopal    | 8500.00 |
|  6 | Komal    |  22 | Hyderabad | 4500.00 |
|  7 | Mufy     |  24 | Indore    | 1000.00 |
+----+----------+-----+-----------+---------+
7 rows in set (0.000 sec)




