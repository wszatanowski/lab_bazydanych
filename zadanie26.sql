--zadanie 26

drop table if exists dbo.ludzie
go
create table ludzie
(
imiê varchar(20) not null,
nazwisko varchar(20) not null
)
insert into ludzie values
('Jan','Kowalski'),
('Tomasz','Nowicki'),
('Krzysztof','Malinowski'),
('Irena','Malicka')
go

drop table if exists dbo.rozmiar
go
create table rozmiar
(
nazwisko varchar(20) not null,
wzrost int not null
)
insert into rozmiar values
('Kowalski',190),
('Malicka',195),
('Malinowski',185),
('Nowicki',188)
go

drop table if exists dbo.zarobki
go
create table zarobki
(
miasto varchar(20) not null,
nazwisko varchar(20) not null,
zarobki float not null
)
insert into zarobki values
('Gdañsk','Kowalski',2500.9),
('Gdynia','Nowicki',4300.90),
('Gdañsk','Malinowski',2700.90),
('Gdynia','Malicka',3600.90)
go

Select * from ludzie
Select * from rozmiar
Select * from zarobki

alter table ludzie add data varchar(10)
go
update ludzie set data = '1991.01.01' where nazwisko = 'Kowalski'
update ludzie set data = '1994.01.10' where nazwisko = 'Nowicki'
update ludzie set data = '1991.01.21' where nazwisko = 'Malinowski'
update ludzie set data = '1986.09.21' where nazwisko = 'Malicka'
go
Select * from ludzie



Select year(l.data) as 'rok urodzenia', DATEDIFF(year, l.data, getdate()) as wiek, z.miasto, l.nazwisko, r.wzrost/100.00 as 'wzrost'
from ludzie as l
join zarobki as z on z.nazwisko = l.Nazwisko
join rozmiar as r on r.nazwisko = z.nazwisko
where z.miasto = 'Gdañsk' and 
r.wzrost > (select AVG(r.wzrost)
from rozmiar as r)

Select AVG(r.wzrost)/100.00 as 'œredni wzrost'
from rozmiar as r
join zarobki as z on r.nazwisko = z.nazwisko
where z.miasto = 'Gdañsk'

Select COUNT(*) as 'liczba osób', z.miasto
From zarobki as z
join ludzie as l on l.nazwisko = z.nazwisko
join rozmiar as r on r.nazwisko = z.nazwisko
where YEAR(l.data)>1990 and 
r.wzrost > (
	select AVG(wzrost) 
	from rozmiar as r
	join zarobki as z on z.nazwisko = r.nazwisko
	where z.miasto='Gdañsk')
group by miasto
