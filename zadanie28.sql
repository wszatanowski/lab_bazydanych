/* Laboratorium 8, zadanie 28
Napisz skrypt (wielokrotnie wykonywalny; bez polskich znakow) w
jezyku T-SQL, który zrealizuje ponizsze czynnosci:

utworzy i wyswietli ponizsze tabele zgodnie z ponizszym wzorem
*/
drop table if exists pacjenci
go
create table pacjenci
(
id_pacjenta varchar(6) not null,
nazwisko varchar(20) not null,
data_ur datetime not null
)
insert into pacjenci values
('A_1234', 'Kowalska', '1989/02/01'),
('A_3456', 'Nowak', '1991/03/03'),
('B_2111', 'Malicki', '1993/05/05')
go

drop table if exists lekarze
go
create table lekarze
(
id_lekarza varchar(4) not null,
id_specjalizacji varchar(2) not null,
nr_gab int not null
)
insert into lekarze values
('P_12', 'p1', 23),
('O_34', 'o1', 31),
('S_90', 'S1', 40)
go

drop table if exists miasta_pacjenci
go
create table miasta_pacjenci
(
nazwisko varchar(20) not null,
miasto varchar(20) not null
)
insert into miasta_pacjenci values
('Nowak', 'Gdansk'),
('Kowalska', 'Gdansk'),
('Malicki', 'Sopot')
go

drop table if exists wizyty
go
create table wizyty
(
id_pacjenta varchar(6) not null,
data_wizyty datetime not null,
id_lekarza varchar(4) not null
)
insert into wizyty values
('A_3456', '2019-04-21 18:00', 'S_90'),
('A_1234', '2019-05-13 14:50', 'O_34'),
('B_2111', '2019-06-03 15:00', 'S_90')
go

select id_pacjenta, nazwisko, CONVERT(varchar(10), data_ur, 111) as 'data_ur' from pacjenci
select * from lekarze
select * from miasta_pacjenci
select id_pacjenta, CONVERT(varchar(16), data_wizyty, 120) as 'data_wizyty', id_lekarza from wizyty

--za pomoca procedury obliczy i wyswietli wiek wszystkich pacjentow oraz wyswietli nazwisko osoby najstarszej, zgodnie z ponizszym wzorem
drop procedure if exists proc1
go
create procedure proc1
as
select nazwisko, CONVERT(varchar(10), data_ur, 120) as 'data_ur', DATEDIFF(year, data_ur, getdate()) as 'wiek' from pacjenci
select nazwisko as 'nazwisko osoby najstarszej' from pacjenci
where (select min(data_ur) from pacjenci) = data_ur 
go
exec proc1

--za pomoca procedury wyswietli wizyty wszystkich osob z Gdanska (procedura bez parametru), zgodnie z ponizszym wzorem:
drop procedure if exists proc2
go
create procedure proc2
as
select mp.miasto, convert(varchar(16), w.data_wizyty, 120) as 'data_wizyty', mp.nazwisko from pacjenci as p
join miasta_pacjenci as mp on mp.nazwisko = p.nazwisko
join wizyty as w on w.id_pacjenta = p.id_pacjenta
where mp.miasto = 'Gdansk'
go
exec proc2

--za pomoca procedury wyswietli wizyty wszystkich osob z Gdanska (procedura z parametrem), zgodnie z ponizszym wzorem:
drop procedure if exists proc3
go
create procedure proc3 @miejscowosc varchar(20)
as
select mp.miasto, convert(varchar(16), w.data_wizyty, 120) as 'data_wizyty', mp.nazwisko, w.id_lekarza, l.id_specjalizacji from pacjenci as p
join miasta_pacjenci as mp on mp.nazwisko = p.nazwisko
join wizyty as w on w.id_pacjenta = p.id_pacjenta
join lekarze as l on l.id_lekarza = w.id_lekarza
where mp.miasto = @miejscowosc
go
exec proc3 Gdansk

--za pomoca procedury wyswietli wizyty wszystkich osob z poza Gdanska (rodzaj procedury dowolny), zgodnie z ponizszym
drop procedure if exists proc4
go
create procedure proc4 @miejscowosc varchar(20)
as
select mp.miasto, convert(varchar(16), w.data_wizyty, 120) as 'data_wizyty', mp.nazwisko, w.id_lekarza, l.id_specjalizacji from pacjenci as p
join miasta_pacjenci as mp on mp.nazwisko = p.nazwisko
join wizyty as w on w.id_pacjenta = p.id_pacjenta
join lekarze as l on l.id_lekarza = w.id_lekarza
where mp.miasto != @miejscowosc
go
exec proc4 Gdansk

--za pomoca procedury wyswietli wizyte wybranej osoby na podstawie nazwiska (procedura z parametrem), zgodnie z ponizszym wzorem:
drop procedure if exists proc5
go
create procedure proc5 @name varchar(20)
as
select mp.nazwisko, convert(varchar(16), w.data_wizyty, 120) as 'data_wizyty', w.id_lekarza, l.id_specjalizacji, l.nr_gab from pacjenci as p
join miasta_pacjenci as mp on mp.nazwisko = p.nazwisko
join wizyty as w on w.id_pacjenta = p.id_pacjenta
join lekarze as l on l.id_lekarza = w.id_lekarza
where mp.nazwisko = @name
go
exec proc5 Kowalska

--za pomoca procedury wyswietli wszystkie wizyty w dniu dzisiejszym (procedura bez parametru), zgodnie z ponizszym wzorem:
drop procedure if exists proc6
go
create procedure proc6
as
select convert(varchar(16), w.data_wizyty, 120) as 'data_wizyty', w.id_lekarza, l.id_specjalizacji, l.nr_gab, mp.nazwisko from pacjenci as p
join miasta_pacjenci as mp on mp.nazwisko = p.nazwisko
join wizyty as w on w.id_pacjenta = p.id_pacjenta
join lekarze as l on l.id_lekarza = w.id_lekarza
where day(w.data_wizyty) = day(GETDATE())
go
exec proc6