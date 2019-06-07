DROP TABLE IF EXISTS clients
DROP TABLE IF EXISTS suppliers
DROP TABLE IF EXISTS warehouse
DROP TABLE IF EXISTS categories
DROP TABLE IF EXISTS products
DROP TABLE IF EXISTS orders



GO
CREATE TABLE clients
(
ClientID INT PRIMARY KEY IDENTITY,
PESEL VARCHAR(11),
FirstName VARCHAR(20),
LastName VARCHAR(20)
)
INSERT INTO clients VALUES
('98031911730', 'Jan','Kowalski'),
('98052317540','Aleksandra','Malinowska'),
('91011507527','Anna','Nowak'),
('65121108971','Jerzy','Kowalewski'),
('01241500737','Zbigniew','Jankowski')

CREATE TABLE suppliers
(
SupplierID INT PRIMARY KEY IDENTITY,
SupplierName VARCHAR(20)
)
INSERT INTO suppliers VALUES
('DPD'),
('DHL'),
('Janusz and Grazyna'),
('Blablacar')

CREATE TABLE warehouse
(
ProductID INT,
Stock BIT
)
INSERT INTO warehouse VALUES
(1, 1),
(2, 0),
(3, 1),
(4, 1),
(5, 0)

CREATE TABLE categories
(
CategoryID INT PRIMARY KEY IDENTITY,
CategoryName VARCHAR(20)
)
INSERT INTO categories VALUES
('Warzywa'),
('Owoce'),
('Mieso'),
('Nabial')

CREATE TABLE products
(
ProductID INT PRIMARY KEY IDENTITY,
ProductName VARCHAR(20),
CategoryID INT,
UnitPrice FLOAT
)
INSERT INTO products VALUES
('Kurczak',3, 18),
('Pomidor',2, 4),
('Ziemniak',1, 3),
('Baranina',3, 24),
('Twarog',4, 2.5)

CREATE TABLE orders
(
OrderID INT,
ClientID INT,
ProductID INT,
Quantity INT,
SupplierID INT,
OrderDate DATE,
City VARCHAR(20)
)
INSERT INTO orders VALUES
(2,2,5,3,'2018-05-16', 'Warsaw'),
(2,1,3,1,'2018-05-18', 'Katowice'),
(3,3,1,1,'2018-05-16', 'Gdansk'),
(1,3,2,4,'2018-05-16', 'Szczecin'),
(4,4,6,2,'2018-05-16', 'Krakow')

DROP VIEW IF EXISTS bestclient
GO
CREATE VIEW bestclient AS
SELECT TOP 1
	c.ClientID,
	LastName,
	PESEL,
	SUM(Quantity*UnitPrice) 'suma'
FROM clients C
JOIN orders O ON c.ClientID = O.ClientID
JOIN products P ON P.ProductID = O.ProductID  
GROUP BY C.ClientID, LastName, PESEL
ORDER BY suma DESC
GO

DROP VIEW IF EXISTS fv
GO
CREATE VIEW fv AS
SELECT
	OrderID,
	LastName,
	c.ClientID,
	OrderDate
FROM orders O
JOIN clients C ON c.ClientID = O.ClientID
GO

DROP VIEW IF EXISTS stock
GO
CREATE VIEW stock AS
SELECT
	ProductName,
	O.ProductID,
	SupplierName,
	O.SupplierID,
	CategoryName,
	C.CategoryID,
  W.Stock
FROM Orders O
JOIN suppliers S ON S.SupplierID = O.SupplierID
JOIN products P ON P.ProductID = O.ProductID
JOIN categories C ON C.CategoryID = P.CategoryID
JOIN warehouse W ON W.ProductID = O.ProductID
GO

DROP PROC IF EXISTS new_fv
GO
CREATE PROC new_fv @OrderID INT, @ProductID INT, @Quantity INT AS
IF @OrderID IN (SELECT OrderID FROM orders) AND @ProductID IN (SELECT ProductID FROM products)
	INSERT INTO orders VALUES
	(@OrderID, NULL, @ProductID, @Quantity, NULL, GETDATE(), NULL)
	SELECT * FROM orders
GO
EXEC new_fv 2, 3, 10
GO

DROP FUNCTION IF EXISTS discount
GO
CREATE FUNCTION discount(@ClientID INT)
RETURNS FLOAT
BEGIN
DECLARE @discount FLOAT, @orderssum INT
SET @orderssum =
(
	SELECT
	SUM(Quantity*UnitPrice) 'suma'
	FROM clients C
	JOIN orders O ON c.ClientID = O.ClientID
	JOIN products P ON P.ProductID = O.ProductID
	WHERE C.ClientID = @ClientID
	GROUP BY C.ClientID
)
set @discount =
(
CASE
	WHEN @orderssum >= 10000 THEN 0.1
	WHEN @orderssum >= 3000 THEN 0.07
	WHEN @orderssum >= 1000 THEN 0.05
	ELSE 0
END
)
RETURN @discount
END
GO

---

DROP FUNCTION IF EXISTS fv_disc
GO
CREATE FUNCTION fv_disc(@fv INT)
RETURNS @temp TABLE(fv INT,discount FLOAT,price INT, after_discount FLOAT)
AS
BEGIN
IF (@fv IN(SELECT OrderID from orders))
DECLARE @client INT
SET @client =
(
SELECT C.ClientID
FROM clients C
JOIN orders O ON O.ClientID = C.ClientID
WHERE OrderID = @fv

)
INSERT INTO @temp(fv, discount, price, after_discount)
SELECT
	@fv,
	dbo.discount(@client),
	O.Quantity*P.UnitPrice,
	O.Quantity*P.UnitPrice*dbo.discount(@client)
FROM orders O
JOIN clients C ON O.ClientID = C.ClientID
JOIN products P ON P.ProductID = O.ProductID
WHERE @fv = O.OrderID
RETURN
END
GO
SELECT * FROM fv_disc(3)

---
DROP PROC IF EXISTS newer_fv
GO
CREATE PROC newer_fv @ClientID INT, @OrderID INT AS
IF @OrderID IN (SELECT OrderID FROM orders) AND @ClientID IN (SELECT ClientID FROM clients)
	INSERT INTO orders VALUES
	(@OrderID, @ClientID, NULL, NULL, NULL, GETDATE(), NULL)
	SELECT * FROM orders
GO
EXEC newer_fv 2, 1
GO

SELECT * FROM clients
SELECT * FROM suppliers
SELECT * FROM products
SELECT * FROM categories
SELECT * FROM orders
SELECT * FROM bestclient
SELECT * FROM fv

