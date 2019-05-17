IF OBJECT_ID('FK_kierunek') IS NOT NULL
BEGIN
	ALTER TABLE kierunek
	DROP CONSTRAINT FK_kierunek
END

IF OBJECT_ID('FK_wydzial') IS NOT NULL
BEGIN
	ALTER TABLE kierunek
	DROP CONSTRAINT FK_wydzial
END

IF OBJECT_ID('FK_kampus') IS NOT NULL
BEGIN
	ALTER TABLE wydzial
	DROP CONSTRAINT FK_kampus
END

IF OBJECT_ID('FK_urodziny') IS NOT NULL
BEGIN
	ALTER TABLE urodziny
	DROP CONSTRAINT FK_urodziny
END

IF OBJECT_ID('FK_imiona_rodzicow') IS NOT NULL
BEGIN
	ALTER TABLE imiona_rodzicow
	DROP CONSTRAINT FK_imiona_rodzicow
END

IF OBJECT_ID('FK_wykladowcy') IS NOT NULL
BEGIN
	ALTER TABLE wykladowcy_nawydziale
	DROP CONSTRAINT FK_wykladowcy
END

IF OBJECT_ID('FK_wykladowcy_nawydziale') IS NOT NULL
BEGIN
	ALTER TABLE kierunek
	DROP CONSTRAINT FK_wykladowcy_nawydziale
END

IF OBJECT_ID('FK_socjal') IS NOT NULL
BEGIN
	ALTER TABLE socjal
	DROP CONSTRAINT FK_socjal
END

IF OBJECT_ID('FK_zarobki_wykladowcy') IS NOT NULL
BEGIN
	ALTER TABLE zarobki_wykladowcy
	DROP CONSTRAINT FK_zarobki_wykladowcy
END

DROP TABLE IF EXISTS studenci
GO
CREATE TABLE studenci
(
	indeks INT PRIMARY KEY IDENTITY,
	nazwisko VARCHAR(30),
	imie VARCHAR(30)
)
GO

DROP TABLE IF EXISTS kierunek
GO
CREATE TABLE kierunek
(
	indeks INT PRIMARY KEY IDENTITY,
	kierunek VARCHAR(30)
)
GO

DROP TABLE IF EXISTS wydzial
GO
CREATE TABLE wydzial
(
	kierunek VARCHAR(30) PRIMARY KEY,
	wydzial VARCHAR(30)
)
GO

DROP TABLE IF EXISTS kampus
GO
CREATE TABLE kampus
(
	wydzial VARCHAR(30) PRIMARY KEY,
	kampus VARCHAR(30)
)
GO

DROP TABLE IF EXISTS urodziny
GO
CREATE TABLE urodziny
(
	indeks INT PRIMARY KEY IDENTITY,
	data_ur DATE
)
GO

DROP TABLE IF EXISTS imiona_rodzicow
GO
CREATE TABLE imiona_rodzicow
(
	indeks INT PRIMARY KEY IDENTITY,
	imie_matki VARCHAR(30),
	imie_ojca VARCHAR(30)
)
GO

DROP TABLE IF EXISTS wykladowcy
GO
CREATE TABLE wykladowcy
(
	id_wykladowcy INT PRIMARY KEY IDENTITY,
	nazwisko VARCHAR(30),
	imie VARCHAR(30)
)
GO

DROP TABLE IF EXISTS wykladowcy_nawydziale
GO
CREATE TABLE wykladowcy_nawydziale
(
	kierunek VARCHAR(30) PRIMARY KEY,
	id_wykladowcy INT
)
GO

DROP TABLE IF EXISTS socjal
GO
CREATE TABLE socjal
(
	indeks INT PRIMARY KEY,
	akademik BIT,
	stypendium BIT
)
GO

DROP TABLE IF EXISTS zarobki_wykladowcy
GO
CREATE TABLE zarobki_wykladowcy
(
	id_wykladowcy INT PRIMARY KEY,
	zarobki_netto FLOAT,
	zarobki_brutto FLOAT,
	dodatek_stazowy FLOAT
)
GO


ALTER TABLE kierunek
ADD CONSTRAINT FK_kierunek FOREIGN KEY (indeks)
REFERENCES studenci(indeks)

ALTER TABLE kierunek
ADD CONSTRAINT FK_wydzial FOREIGN KEY (kierunek)
REFERENCES wydzial(kierunek)

ALTER TABLE wydzial
ADD CONSTRAINT FK_kampus FOREIGN KEY (wydzial)
REFERENCES kampus(wydzial)

ALTER TABLE urodziny
ADD CONSTRAINT FK_urodziny FOREIGN KEY (indeks)
REFERENCES studenci(indeks)

ALTER TABLE imiona_rodzicow
ADD CONSTRAINT FK_imiona_rodzicow FOREIGN KEY (indeks)
REFERENCES studenci(indeks)

ALTER TABLE wykladowcy_nawydziale
ADD CONSTRAINT FK_wykladowcy FOREIGN KEY (id_wykladowcy)
REFERENCES wykladowcy(id_wykladowcy)

ALTER TABLE kierunek
ADD CONSTRAINT FK_wykladowcy_nawydziale FOREIGN KEY (kierunek)
REFERENCES wykladowcy_nawydziale(kierunek)

ALTER TABLE socjal
ADD CONSTRAINT FK_socjal FOREIGN KEY (indeks)
REFERENCES studenci(indeks)

ALTER TABLE zarobki_wykladowcy
ADD CONSTRAINT FK_zarobki_wykladowcy FOREIGN KEY (id_wykladowcy)
REFERENCES wykladowcy(id_wykladowcy)