ALTER TABLE products
DROP CONSTRAINT IF EXISTS FK_Categorynumber
ALTER TABLE orders
DROP CONSTRAINT IF EXISTS FK_Suppliernumber
ALTER TABLE orders
DROP CONSTRAINT IF EXISTS FK_Clientnumber

DROP TABLE IF EXISTS clients
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
GO

DROP TABLE IF EXISTS warehouse
GO
CREATE TABLE warehouse
(
SupplierID INT PRIMARY KEY IDENTITY,
SupplierName VARCHAR(20)
)
INSERT INTO suppliers VALUES
('DPD'),
('DHL'),
('Janusz and Grazyna'),
('Blablacar')
GO


DROP TABLE IF EXISTS categories
GO
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
GO

DROP TABLE IF EXISTS products
GO
CREATE TABLE products
(
ProductID INT IDENTITY,
ProductName VARCHAR(20),
CategoryID INT,
UnitPrice FLOAT,
PRIMARY KEY (ProductID),
CONSTRAINT FK_Categorynumber FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
)
INSERT INTO products VALUES
('Kurczak',3, 18),
('Pomidor',2, 4),
('Ziemniak',1, 3),
('Baranina',3, 24),
('Twarog',4, 2.5)
GO

DROP TABLE IF EXISTS orders
GO
CREATE TABLE orders
(
OrderID INT IDENTITY,
ClientID INT,
ProductID INT,
Quantity INT,
SupplierID INT,
OrderDate DATE,
City VARCHAR(20),
PRIMARY KEY (OrderID),
CONSTRAINT FK_Suppliernumber FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID),
CONSTRAINT FK_Clientnumber FOREIGN KEY (ClientID) REFERENCES clients(ClientID)
)
INSERT INTO orders VALUES
(2,2,5,3,'2018-05-16', 'Warsaw'),
(2,1,3,1,'2018-05-18', 'Katowice'),
(3,3,1,1,'2018-05-16', 'Gdansk'),
(1,3,2,4,'2018-05-16', 'Szczecin'),
(4,4,6,2,'2018-05-16', 'Krakow')
GO

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

SELECT * FROM clients
SELECT * FROM suppliers
SELECT * FROM products
SELECT * FROM categories
SELECT * FROM orders
SELECT * FROM bestclient
SELECT * FROM fv