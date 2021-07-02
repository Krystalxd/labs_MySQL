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