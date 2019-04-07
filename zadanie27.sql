--zadanie 27
drop table if exists dbo.osoby
go
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
go

drop table if exists dbo.zarobki
go
create table zarobki
(
miasto varchar(20) not null,
nazwisko varchar(20) not null,
netto float not null
)
insert into zarobki values
('Gdansk','Kowalski', 2600.90),
('Gdynia','Nowicki',4400.90),
('Gdansk','Malinowski',2800.90),
('Gdansk','Malicka',3900.90)
go

--za pomoc¹ funkcji wyœwietli iloœæ osób mieszkaj¹cych w Gdansku, których pensja netto jest mniejsza ni¿ 3000
drop function if exists dbo.f1
go
create function f1()
returns int
begin
declare @ile int
set @ile=(select count(*) from zarobki where miasto = 'Gdansk' and netto < 3000)
return @ile
end
go
select dbo.f1() as 'Liczba'

--za pomoc¹ funkcji wyœwietli œredni wzrost (w metrach) wszystkich osób z Gdanska
drop function if exists dbo.f2
go
create function f2()
returns float
begin
declare @ile float
set @ile=(
select round(AVG(wzrost/100.00),2) from osoby where nazwisko in (select nazwisko from zarobki where miasto = 'Gdansk')
)
return @ile
end
go
select dbo.f2() as 'sredni wzrost (w metrach)'

--za pomoc¹ funkcji wyœwietli nazwisko osoby zarabiaj¹cej najwiêcej
drop function if exists dbo.f3
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

--za pomoc¹ funkcji wyœwietli iloœæ mieszkañców z poszczególnych miast (group by + where)
drop function if exists dbo.f4
go
create function f4(@miejscowosc varchar(20))
returns table as return (select miasto, count(*) as 'Liczba mieszkancow' from zarobki where miasto = @miejscowosc group by miasto)
go
select * from dbo.f4('Gdansk')

--za pomoc¹ funkcji wyœwietli iloœæ mieszkañców z poszczególnych miast (group by + having)
drop function if exists dbo.f4_2
go
create function f4_2(@miejscowosc varchar(20))
returns table as return (select miasto, count(*) as 'Liczba mieszkancow' from zarobki group by miasto having miasto = @miejscowosc)
go
select * from dbo.f4_2('Gdynia')

--za pomoc¹ funkcji wyœwietli zarobki wszystkich osób, których pensja brutto (VAT=23%) jest wiêksza ni¿ minimalna pensja brutto wszystkich osób, zgodnie z poni¿szym wzorem
drop function if exists dbo.f5
go
create function f5()
returns table as return (
	select nazwisko, netto, round(netto*1.23,2) as 'brutto'
	from zarobki
	where netto > (select min(netto) from zarobki)
)
go
select * from dbo.f5()

--za pomoc¹ funkcji wyœwietli œrednie zarobki brutto (VAT=23%) we wszystkich miastach, zgodnie z poni¿szym wzorem:
drop function if exists dbo.f6
go
create function f6()
returns table as return (
	select miasto, round(avg(netto),2) as 'netto', round(avg(netto*1.23),2) as 'brutto'
	from zarobki
	group by miasto
)
go
select * from dbo.f6()

--wszystkim osobom (update) z Gdanska podwy¿szy pensjê netto o 5%, a nastêpnie za pomoc¹ funkcji wyœwietli zawartoœæ tabeli po zmianach
update zarobki
set netto = round(netto * 1.05,2)
where miasto = 'Gdansk'

drop function if exists dbo.f7
go
create function f7()
returns table as return (select * from zarobki)
go
select * from dbo.f7()

--za pomoc¹ funkcji wyœwietli (dla wszystkich rekordów) wynik w postaci:
drop function if exists dbo.f8
go
create function f8()
returns table as return (
	select o.nazwisko, miasto, wzrost/100.00 as 'wzrost', netto, round(netto*1.23,2) as 'brutto'
	from zarobki as z join osoby as o on z.nazwisko = o.nazwisko
)
go
select * from dbo.f8()