IF OBJECT_ID('dbo.urodziny', 'U') is not null
drop table dbo.urodziny
/* drop table if exist dbo.urodziny
go; go te¿ po insert
dla SQL Server >=2016 */
create table urodziny
(
lp int primary key identity,
Data Date not null,
Nazwisko varchar(20) not null
)
insert into urodziny values
('1998-09-01','Kowalski'),
('1991-10-09','Malinowska'),
('2001-02-09','Nowak'),
('2002-03-12','Kowalewski')

IF OBJECT_ID('dbo.miejscowosci', 'U') is not null
drop table dbo.miejscowosci
create table miejscowosci
(
lp int primary key identity,
Nazwisko varchar(20) not null,
Miasto varchar(20) not null
)
insert into miejscowosci values
('Kowalski','Sopot'),
('Nowak','Gdañsk'),
('Malinowska','Gdañsk'),
('Kowalewski','Gdynia')

IF OBJECT_ID('dbo.zarobki', 'U') is not null
drop table dbo.zarobki
create table zarobki
(
lp int primary key identity,
Nazwisko varchar(20) not null,
Brutto Int
)
insert into zarobki values
('Kowalski',8120),
('Malinowska',7891),
('Nowak',9882),
('Kowalewski',6789)

Select * from urodziny
Select * from miejscowosci
Select * from zarobki

Select z.Nazwisko, Round(Brutto/1.23,2) as Netto ,z.Brutto
From dbo.zarobki as z
join dbo.miejscowosci as m on z.Nazwisko = m.Nazwisko
Where (z.Brutto/1.23) > 
	(Select Min(Brutto/1.23) from zarobki join miejscowosci
	on miejscowosci.Nazwisko = zarobki.Nazwisko where miejscowosci.Miasto = 'Gdañsk') 

Select Nazwisko,Round(Brutto/1.23,2) as Netto 
,Brutto
From dbo.zarobki
Where Brutto=(Select max(brutto) from zarobki)

Select m.Miasto, Round(AVG(z.Brutto/1.23),2) as Netto, AVG(z.Brutto) as Brutto
From miejscowosci as m
join zarobki as z on z.Nazwisko=m.Nazwisko
Group by m.Miasto