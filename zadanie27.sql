--zadanie 27
IF OBJECT_ID('dbo.osoby', 'U') is not null
drop table dbo.osoby
create table osoby
(
nazwisko varchar(20) not null,
wzrost int not null
)
insert into osoby values
('Kowalski', 180),
('Malicka', 185),
('Malinowski', 165),
('Nowicki', 178)

IF OBJECT_ID('dbo.zarobki', 'U') is not null
drop table dbo.zarobki
create table zarobki
(
miasto varchar(20) not null,
nazwisko varchar(20) not null,
netto float not null
)
insert into zarobki values
('Gda�sk','Kowalski', 2600.90),
('Gdynia','Nowicki',4400.90),
('Gda�sk','Malinowski',2800.90),
('Gda�sk','Malicka',3900.90)

select * from osoby
select * from zarobki

--za pomoc� funkcji wy�wietli ilo�� os�b mieszkaj�cych w Gda�sku, kt�rych pensja netto jest mniejsza ni� 3000
IF OBJECT_ID('dbo.f1') is not null
drop function dbo.f1
go
create function f1()
returns int
begin
declare @ile int
set @ile=(select count(*) from zarobki where miasto = 'Gda�sk' and netto < 3000)
return @ile
end
go
select dbo.f1() as 'Liczba'

--za pomoc� funkcji wy�wietli �redni wzrost (w metrach) wszystkich os�b z Gda�ska
IF OBJECT_ID('dbo.f2') is not null
drop function dbo.f2
go
create function f2()
returns float
begin
declare @ile float
set @ile=(
select round(AVG(wzrost/100.00),2) from osoby where nazwisko in (select nazwisko from zarobki where miasto = 'Gda�sk')
)
return @ile
end
go
select dbo.f2() as '�redni wzrost (w metrach)'

--za pomoc� funkcji wy�wietli nazwisko osoby zarabiaj�cej najwi�cej
IF OBJECT_ID('dbo.f3') is not null
drop function dbo.f3
go
create function f3()
returns varchar(20)
begin
declare @bogacz varchar(20)
set @bogacz=(
select nazwisko from zarobki where netto = (select max(netto) from zarobki)
)
return @bogacz
end
go
select dbo.f3() as 'Bogacz'

--za pomoc� funkcji wy�wietli ilo�� mieszka�c�w z poszczeg�lnych miast (group by + where)
IF OBJECT_ID('dbo.f4') is not null
drop function dbo.f4
go
create function f4()
returns table as return (select miasto, count(*) as 'Liczba mieszka�c�w' from zarobki group by miasto)
go
select * from dbo.f4()

--za pomoc� funkcji wy�wietli zarobki wszystkich os�b, kt�rych pensja brutto (VAT=23%) jest wi�ksza ni� minimalna pensja brutto wszystkich os�b, zgodnie z poni�szym wzorem
IF OBJECT_ID('dbo.f5') is not null
drop function dbo.f5
go
create function f5()
returns table as return (
	select nazwisko, netto, round(netto*1.23,2) as 'brutto'
	from zarobki
	where netto > (select avg(netto) from zarobki)
)
go
select * from dbo.f5()

--za pomoc� funkcji wy�wietli �rednie zarobki brutto (VAT=23%) we wszystkich miastach, zgodnie z poni�szym wzorem:
IF OBJECT_ID('dbo.f6') is not null
drop function dbo.f6
go
create function f6()
returns table as return (
	select miasto, round(avg(netto),2) as 'netto', round(avg(netto*1.23),2) as 'brutto'
	from zarobki
	group by miasto
)
go
select * from dbo.f6()

--wszystkim osobom (update) z Gda�ska podwy�szy pensj� netto o 5%, a nast�pnie za pomoc� funkcji wy�wietli zawarto�� tabeli po zmianach
update zarobki
set netto = round(netto * 1.05,2)
where miasto = 'Gda�sk'
IF OBJECT_ID('dbo.f7') is not null
drop function dbo.f7
go
create function f7()
returns table as return (select * from zarobki)
go
select * from dbo.f7()

--za pomoc� funkcji wy�wietli (dla wszystkich rekord�w) wynik w postaci:
IF OBJECT_ID('dbo.f8') is not null
drop function dbo.f8
go
create function f8()
returns table as return (
	select o.nazwisko, miasto, (wzrost/100.00) as 'wzrost', netto, round(netto*1.23,2) as 'brutto'
	from zarobki as z join osoby as o on z.nazwisko = o.nazwisko
)
go
select * from dbo.f8()