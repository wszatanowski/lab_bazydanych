--lab10
--utworzy i wyswietli ponizsze tabele zgodnie z ponizszym wzorem

DROP TABLE IF EXISTS urodziny
GO
CREATE TABLE urodziny
(
lp INT PRIMARY KEY IDENTITY,
nazwisko VARCHAR(20),
data_ur date
)
INSERT INTO urodziny VALUES
('Kowalski', '1998-09-01'),
('Malinowska', '1995-10-09'),
('Nowak', '1998-02-09'),
('Kowalewski', '1999-03-12'),
('Jankowski', '1999-09-01')
GO

DROP TABLE IF EXISTS miasta
GO
CREATE TABLE miasta
(
nr INT PRIMARY KEY IDENTITY,
nazwisko VARCHAR(20),
miasto VARCHAR(20)
)
INSERT INTO miasta VALUES
('Kowalski', 'Sopot'),
('Nowak', 'Gdansk'),
('Malinowska', 'Gdansk'),
('Kowalewski', 'Gdynia'),
('Jankowski', 'Sopot')
GO

SELECT * FROM urodziny
SELECT * FROM miasta

--obliczy i wyswietli wiek wszystkich osob (wykorzystujac zmienna tabelaryczna) zgodnie z ponizszym wzorem:
DECLARE @tab TABLE(
	nazwisko VARCHAR(20),
	rok_ur INT,
	wiek INT,
	miasto VARCHAR(20)
	)
INSERT INTO @tab (nazwisko, rok_ur, wiek, miasto)
	SELECT
		u.nazwisko,
		YEAR(u.data_ur),
		CASE
			WHEN MONTH(u.data_ur) < MONTH(GETDATE()) THEN DATEDIFF(YEAR, u.data_ur, getdate())
			WHEN MONTH(u.data_ur) = MONTH(GETDATE()) AND DAY(u.data_ur) <= DAY(GETDATE()) THEN DATEDIFF(YEAR, data_ur, getdate())
			ELSE DATEDIFF(YEAR, u.data_ur, getdate())-1
		END,
		m.miasto
	FROM miasta m
	JOIN urodziny u ON u.nazwisko = m.nazwisko
SELECT * FROM @tab

--obliczy i wyswietli wiek wszystkich osob (wykorzystujac typ tabelaryczny i oparta na nim zmienna tabelaryczna) zgodnie z ponizszym wzorem:
DROP TYPE IF EXISTS szablon
GO
CREATE TYPE szablon AS TABLE (
	nazwisko VARCHAR(20),
	rok_ur INT,
	wiek INT,
	miasto VARCHAR(20)
)
GO
DECLARE @tab1 szablon
INSERT INTO @tab1
	SELECT
		u.nazwisko,
		YEAR(u.data_ur),
		CASE
			WHEN MONTH(u.data_ur) < MONTH(GETDATE()) THEN DATEDIFF(YEAR, u.data_ur, getdate())
			WHEN MONTH(u.data_ur) = MONTH(GETDATE()) AND DAY(u.data_ur) <= DAY(GETDATE()) THEN DATEDIFF(YEAR, data_ur, getdate())
			ELSE DATEDIFF(YEAR, u.data_ur, getdate())-1
		END,
		m.miasto
	FROM miasta m
	JOIN urodziny u ON u.nazwisko = m.nazwisko
SELECT * FROM @tab1
GO

--na podstawie samodzielnie przyjetych kryteriow za pomoca zmiennej tabelarycznej zinterpretuje wiek kazdej osoby i wynik przedstawi zgodnie z ponizszym wzorem:
DECLARE @tab2 TABLE(
	nazwisko VARCHAR(20),
	miasto VARCHAR(20),
	wiek INT,
	opis VARCHAR(20)
)
INSERT INTO @tab2 (nazwisko, miasto, wiek, opis)
	SELECT
		nazwisko,
		miasto,
		wiek,
		CASE
			WHEN wiek < 30 THEN 'osoba mloda'
			WHEN wiek > 60 THEN 'osoba starsza'
			ELSE 'osoba dojrzala'
		END
	FROM (
		SELECT
			u.nazwisko,
			m.miasto,
			CASE
				WHEN MONTH(u.data_ur) < MONTH(GETDATE()) THEN DATEDIFF(YEAR, u.data_ur, getdate())
				WHEN MONTH(u.data_ur) = MONTH(GETDATE()) AND DAY(u.data_ur) <= DAY(GETDATE()) THEN DATEDIFF(YEAR, data_ur, getdate())
				ELSE DATEDIFF(YEAR, u.data_ur, getdate())-1
			END AS wiek
		FROM miasta m
		JOIN urodziny u ON u.nazwisko = m.nazwisko
	) helper
SELECT * FROM @tab2

--za pomoca zmiennej tabelarycznej wyswietli wszystkie osoby z Gdanska zgodnie z ponizszym wzorem:
DECLARE @tab3 TABLE(
	nazwisko VARCHAR(20),
	miasto VARCHAR(20),
	wiek INT,
	opis VARCHAR(20)
)
INSERT INTO @tab3 (nazwisko, miasto, wiek, opis)
	SELECT
		u.nazwisko,
		m.miasto,
		CASE
			WHEN MONTH(u.data_ur) < MONTH(GETDATE()) THEN DATEDIFF(YEAR, u.data_ur, getdate())
			WHEN MONTH(u.data_ur) = MONTH(GETDATE()) AND DAY(u.data_ur) <= DAY(GETDATE()) THEN DATEDIFF(YEAR, data_ur, getdate())
			ELSE DATEDIFF(YEAR, u.data_ur, getdate())-1
		END,
		'mieszkaniec Gdanska'
	FROM miasta m
	JOIN urodziny u ON u.nazwisko = m.nazwisko
	WHERE m.miasto = 'Gdansk'
SELECT * FROM @tab3

---obliczy ilosc osob mieszkajacych w poszczegolnych miastach (za pomoca procedury+group by+where) urodzonych po 1998 r., a wynik przedstawi zgodnie z ponizszym wzorem:
DECLARE @tab4 TABLE(
	ilosc_mieszkancow INT,
	miasto VARCHAR(20)
)
INSERT INTO @tab4 (ilosc_mieszkancow, miasto)
	SELECT
		COUNT(*),
		m.miasto
	FROM miasta m
	JOIN urodziny u ON u.nazwisko = m.nazwisko
	WHERE YEAR(u.data_ur) > 1998
	GROUP BY m.miasto
SELECT * FROM @tab4

---obliczy ilosc osob mieszkajacych w poszczegolnych miastach (za pomoca procedury+group by+having) urodzonych po 1998 r., a wynik przedstawi zgodnie z ponizszym wzorem:
DECLARE @tab5 TABLE(
	ilosc_mieszkancow INT,
	miasto VARCHAR(20)
)
INSERT INTO @tab5 (ilosc_mieszkancow, miasto)
	SELECT
		COUNT(*),
		m.miasto
	FROM miasta m
	JOIN urodziny u ON u.nazwisko = m.nazwisko
	GROUP BY m.miasto, YEAR(u.data_ur)
	HAVING YEAR(u.data_ur) > 1998
SELECT * FROM @tab5

--wykorzystujac zmienna tabelaryczna wyswietli dane osoby najmlodszej, zgodnie z ponizszym wzorem:
DECLARE @tab6 TABLE(
	nazwisko VARCHAR(20),
	miasto VARCHAR(20),
	wiek INT,
	opis VARCHAR(20)
)
INSERT INTO @tab6 (nazwisko, miasto, wiek, opis)
	SELECT TOP 1 *
	FROM (
		SELECT
			u.nazwisko,
			m.miasto,
			CASE
				WHEN MONTH(u.data_ur) < MONTH(GETDATE()) THEN DATEDIFF(YEAR, u.data_ur, getdate())
				WHEN MONTH(u.data_ur) = MONTH(GETDATE()) AND DAY(u.data_ur) <= DAY(GETDATE()) THEN DATEDIFF(YEAR, data_ur, getdate())
				ELSE DATEDIFF(YEAR, u.data_ur, getdate())-1
			END AS 'wiek',
			'osoba najmlodsza' AS 'opis'
		FROM miasta m
		JOIN urodziny u ON u.nazwisko = m.nazwisko
	) helper
	ORDER BY wiek ASC
SELECT * FROM @tab6

DROP TYPE szablon
DROP TABLE miasta
DROP TABLE urodziny