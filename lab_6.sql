drop database gay_club;

create database gay_club;
use gay_club;


create table raspor9dok_raboti
(
gay_club_id int primary key not null,
vrem9_otkriti9 time,
vrem9_zakriti9 time
);

create table opisanie_gay_club
(
gay_club_id integer,
elitnost_gay_club varchar(50),
cane_gay_club int,
current_money int,
primary key(gay_club_id),
constraint cn1 foreign key(gay_club_id) references raspor9dok_raboti(gay_club_id) on delete cascade
);

create table posetitel
(
posetitel_id int primary key not null,
posetitel_name varchar(50),
posetitel_surname varchar(50),
posetitel_money int
);

create table posetitel_info
(
posetitel_id int,
dostupnie_sredstva int,
posetitel_rabota varchar(50),
udovletvorennost int not null,
primary key(posetitel_id),
constraint cn2 foreign key(posetitel_id) references posetitel(posetitel_id) on delete cascade
);

create table employees_contract_info
(
employee_id int primary key not null,
employee_name varchar(50),
employee_surname varchar(50)
);

create table employees
(
employee_id integer,
employee_type varchar(50),
vid_okazivaemix_uslug varchar(50),
ka4estvo_uslug int,
primary key(employee_id),
constraint cn3 foreign key (employee_id) references employees_contract_info(employee_id) on delete cascade
);

create table owner_contract_info
(
owner_id integer primary key not null,
owner_name varchar(50),
owner_surname varchar(50)
);

create table owner_info
(
owner_id integer,
zarplata int not null,
data_vstupleni9_v_dolshnost date,
predidusha9_rabota varchar(50),
deistvuyshi bool,
primary key(owner_id),
constraint cn4 foreign key (owner_id) references owner_contract_info(owner_id) on delete cascade
);


create table gay_clubs
(
gay_club_id int,
posetitel_id int,
employee_id int,
owner_id int,
gay_club_name varchar(50) not null,
constraint cn5 foreign key (gay_club_id) references raspor9dok_raboti(gay_club_id),
constraint cn6 foreign key (posetitel_id) references posetitel(posetitel_id),
constraint cn7 foreign key (employee_id) references employees_contract_info(employee_id),
constraint cn8 foreign key (owner_id) references owner_contract_info(owner_id)
);


insert into raspor9dok_raboti
(gay_club_id, vrem9_otkriti9, vrem9_zakriti9)
values
(1, "18:00", "4:00"),
(2, "19:00", "3:00"),
(3, "12:00", "16:00");

select * from raspor9dok_raboti;


insert into opisanie_gay_club
(gay_club_id, elitnost_gay_club, cane_gay_club, current_money)
values
(1, "Sredn99", 100, 10000),
(2, "Elitni", 300,15000),
(3, "VIP", 500, 7000);

select * from opisanie_gay_club;


insert into posetitel
(posetitel_id, posetitel_name, posetitel_surname, posetitel_money)
values
(1, "Lev", "Shepelin", 1000),
(2, "Sast9", "Navchenko", 200),
(3, "Valeri", "Kursov", 100);

select * from posetitel;


insert into posetitel_info
(posetitel_id, dostupnie_sredstva, posetitel_rabota, udovletvorennost)
values
(1, 1000, "Student", 7),
(2, 1500, "Student", 8),
(3, 750, "Tihar", 10);

select * from posetitel_info;


insert into employees_contract_info
(employee_id, employee_name, employee_surname)
values
(1, "Vas9", "Pupkin"),
(2, "Nikolai", "Alensky"),
(3, "Sergei", "Bos9kov");

select * from employees_contract_info;


insert into employees
(employee_id, employee_type, vid_okazivaemix_uslug, ka4estvo_uslug)
values
(1, "Striptizer", "Klassika", 7),
(2, "Barmen", "Gotovka koktelei", 10),
(3, "Prostituka", "Fisting", 9);

select * from employees;


insert into owner_contract_info
(owner_id, owner_name, owner_surname)
values
(1, "Edgar", "Vasilevski"),
(2, "Alex", "Kush"),
(3, "War", "Gaming");

select * from owner_contract_info;


insert into owner_info
(owner_id, zarplata, data_vstupleni9_v_dolshnost, predidusha9_rabota, deistvuyshi)
values
(1, 10000, "2015-09-26", "Student", 0),
(2, 15000, "2017-10-12", "Programmer", 1),
(3, 20000, "2020-10-10", "IT", 1);

select * from owner_info;


insert into gay_clubs
(gay_club_id, posetitel_id, employee_id, owner_id, gay_club_name)
values
(1, 1, 2, 1, "Vishenka"),
(1, 2, 1, 2, "Vishenka"),
(2, 2, 1, 3, "Arbuzik"),
(2, 3, 3, 2, "Arbuzik"),
(3, 1, 2, 3, "Pupsik"),
(3, 1, 3, 3, "Pupsik");



select * from gay_clubs;


/* Привилегии */

use gay_club;

set SQL_SAFE_UPDATES = 0;
set global log_bin_trust_function_creators = 1;


CREATE USER owner IDENTIFIED BY '1';
GRANT all privileges ON gay_club.* TO owner;

FLUSH PRIVILEGES;


CREATE USER posetitel IDENTIFIED BY '2';
GRANT Select ON gay_club.employees TO posetitel;

FLUSH PRIVILEGES;


CREATE USER employee IDENTIFIED BY '228';
GRANT select ON gay_club.employees_contract_info TO employee;

FLUSH PRIVILEGES;


/* Индексы */

Create index gay_club on gay_clubs(gay_club_id);

EXPLAIN SELECT * FROM gay_clubs WHERE gay_club_id = 1; /*2 строки*/


Create index gay_club1 on gay_clubs(gay_club_name);

EXPLAIN SELECT * FROM gay_clubs WHERE gay_club_name = 'Arbuzik'; /*2 строки*/


Create index gay_club2 on owner_info(owner_id);

EXPLAIN SELECT * FROM owner_info WHERE owner_id = 1; /*1 строка*/



/* Представленя */


create or replace view working_bosses
(boss_id, boss_name, boss_surname) as
select owner_id, owner_name, owner_surname
from owner_contract_info,
(
select owner_id as id from owner_info
where deistvuyshi = 1
) as res
where res.id = owner_contract_info.owner_id;



select * from working_bosses;



create or replace view vrem9_raboti
(gay_club_id, vrem9_otkriti9, vrem9_zakriti9) as
select gay_club_id, vrem9_otkriti9, vrem9_zakriti9
from raspor9dok_raboti
where extract(hour from vrem9_otkriti9) = 18 and extract(hour from vrem9_zakriti9) = 4;

select * from vrem9_raboti;



/* Процедуры, функции, транзакции, триггеры */


DELIMITER //
create procedure poseshenie(in posetitel_id int, in gay_club_id int)
begin

declare var int;
declare var1 int;

set var = (select posetitel_money from posetitel
where posetitel.posetitel_id = posetitel_id);

set var1 = (select cane_gay_club from opisanie_gay_club
where opisanie_gay_club.gay_club_id= gay_club_id);


start transaction;

if (var>=0 and var>=var1) 
then
update posetitel
set posetitel_money=posetitel_money - var1
where posetitel.posetitel_id=posetitel_id;
if row_count()>0
	then 
    update opisanie_gay_club
    set current_money=current_money+var1
	where opisanie_gay_club.gay_club_id=gay_club_id;
else rollback;
end if;
end if;

end//
DELIMITER ;

select * from posetitel;
select * from opisanie_gay_club;

call poseshenie(1, 1);


DELIMITER //
create procedure popolnenie(in posetitel_id int, in sum double)
begin
 
start transaction;

update posetitel
set posetitel_money=posetitel_money+sum
where posetitel.posetitel_id=posetitel_id;
end//
DELIMITER ;

call popolnenie(1,300);

select * from posetitel;


delimiter //
create trigger proverka before update on posetitel
for each row
begin
if old.posetitel_money <0 or new.posetitel_money <0 then
	signal sqlstate '45000'
	set message_text = 'U vas nedostatochno deneg :(';
end if;
end//
delimiter ;


DELIMITER //
create trigger poseshenie before insert on gay_clubs
for each row
begin
	if new.gay_club_name not in ("Vishenka", "Arbuzik", "Pupsik") then
		signal sqlstate '45000'
		set message_text = 'Gay club ne naiden';
	end if;
end//
DELIMITER ;



DELIMITER //
create function poseshenie_amount(id int)  /* Вычисляет количество посещений клиента */
returns float deterministic 
begin
	return (
		select count(*) from gay_clubs
		where gay_clubs.posetitel_id = id
	);
end//
DELIMITER ;

select poseshenie_amount(1);


select * from gay_clubs;

DELIMITER //
create function popular_employee(id int)  /* Вычисляет самого популярного работника клиента */
returns int deterministic 
begin
	return (
		select employee_id from gay_clubs
		where posetitel_id = id
		group by employee_id
		order by count(employee_id) desc
		limit 1
	);
end//
DELIMITER ;


select popular_employee(1);