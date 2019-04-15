CREATE TABLE miasta
(
nr INT PRIMARY KEY IDENTITY,
nazwisko VARCHAR(20),
miasto VARCHAR(20)
)
INSERT INTO miasta VALUES
('Kowalski', 'Gdansk'),
('Nowicki', 'Sopot'),
('Malinowska', 'Sopot')

CREATE TABLE urodziny
(
lp INT PRIMARY KEY IDENTITY,
nazwisko VARCHAR(20),
data_ur date
)
INSERT INTO urodziny VALUES
('Malinowska', '1980-01-01'),
('Nowicki', '1990-01-01'),
('Kowalski', '2000-01-01')

CREATE TABLE wymiary
(
lp INT PRIMARY KEY IDENTITY,
nazwisko VARCHAR(20),
wzrost FLOAT(2),
waga INT
)
INSERT INTO wymiary VALUES
('Malinowska', 1.60, 70),
('Nowicki', 1.93, 95),
('Kowalski', 1.85, 110)

SELECT * FROM miasta
SELECT * FROM urodziny
SELECT * FROM wymiary

SELECT 
	m.nazwisko,
	m.miasto,
	CASE
		WHEN MONTH(u.data_ur) < MONTH(GETDATE()) THEN DATEDIFF(YEAR, u.data_ur, getdate())
		WHEN MONTH(u.data_ur) = MONTH(GETDATE()) AND DAY(u.data_ur) <= DAY(GETDATE()) THEN DATEDIFF(YEAR, data_ur, getdate())
		ELSE DATEDIFF(YEAR, u.data_ur, getdate())-1
	END as 'wiek',
	w.wzrost,
	w.waga,
	CASE
		WHEN w.waga/(wzrost*wzrost) < 18.5 THEN 'niedowaga'
		WHEN w.waga/(wzrost*wzrost) >= 25 THEN 'nadwaga'
		ELSE 'waga prawidlowa'
	END as 'BMI'
FROM miasta m
JOIN urodziny u ON u.Nazwisko = m.nazwisko
JOIN wymiary w ON w.nazwisko = m.nazwisko

SELECT
	m.nazwisko,
	m.miasto,
	w.wzrost,
	CASE
		WHEN w.wzrost < 1.6 THEN 'osoba niska'
		WHEN w.wzrost > 1.8 THEN 'osoba wysoka'
		ELSE 'osoba sredniego wzrostu'
	END as 'ocena wzrostu'
FROM miasta m
JOIN wymiary w ON w.nazwisko = m.nazwisko

ALTER TABLE miasta ADD pensja_netto INT
UPDATE miasta SET pensja_netto = 3200 WHERE nr = 1
UPDATE miasta SET pensja_netto = 4500 WHERE nr = 2
UPDATE miasta SET pensja_netto = 8800 WHERE nr = 3

SELECT
	nazwisko,
	miasto,
	pensja_netto,
	CASE
		WHEN pensja_netto < 2500 THEN 'niskie zarobki'
		WHEN pensja_netto > 6000 THEN 'wysokie zarobki'
		ELSE 'srednie zarobki'
	END as 'ocena zarobkow'
FROM miasta

UPDATE miasta
SET pensja_netto = pensja_netto * 1.05
WHERE pensja_netto > 4000

SELECT
	nazwisko,
	pensja_netto,
	CASE
		WHEN pensja_netto / 1.05 >= 4000 THEN 'podwyzka przyznana'
		ELSE 'brak podwyzki'
	END as 'podwyzka'
FROM miasta

DROP TABLE miasta
DROP TABLE urodziny
DROP TABLE wymiary