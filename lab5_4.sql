/*3.1*/

set SQL_SAFE_UPDATES = 0;

use poshiloi_stachkom;

create table popolneni9(
oper_name varchar(50),
summa varchar(20),
akcii_id int,
constraint cn20 foreign key(akcii_id) references masshtab(akcii_id) on delete cascade on update cascade
);

CREATE USER kuklovod IDENTIFIED BY '1';
GRANT Select,Insert,Delete ON poshiloi_stachkom.finansirovanie TO kuklovod;

FLUSH PRIVILEGES;


CREATE USER omon IDENTIFIED BY '2';
GRANT Select,Insert,Delete ON poshiloi_stachkom.gde_sidish TO omon;

FLUSH PRIVILEGES;


CREATE USER god IDENTIFIED BY '228';
GRANT all privileges ON poshiloi_stachkom.* TO god;

FLUSH PRIVILEGES;

SHOW GRANTS FOR god;


/*3.2*/

DELIMITER //
create procedure popol(in dengi int, in akcii_id_ int, prioritet_ varchar(50) )
begin
 
start transaction;

update finansirovanie
set summa_deneg=summa_deneg + dengi
where prioritet_poddershki = prioritet_;
if row_count()>0
		then
        insert into popolneni9
        (oper_name,summa,akcii_id)
        values
        ('popolnenie', dengi, (select akcii_id from masshtab where akcii_id=akcii_id_));
        commit;
	else rollback;
end if;

end//
DELIMITER ;

select * from finansirovanie;

call popol(10000, 3, 'Po fanchiku');


DELIMITER //
create procedure snyat(in dengi int, in akcii_id_ int, prioritet_ varchar(50))
begin
 
start transaction;

if ((select summa_deneg from finansirovanie
where prioritet_poddershki=prioritet_)>=0 and dengi<=(select summa_deneg from finansirovanie
where prioritet_poddershki=prioritet_)) 
then
update finansirovanie
set summa_deneg=summa_deneg-dengi
where prioritet_poddershki=prioritet_;
if row_count()>0
		then
        insert into popolneni9
		(oper_name,summa,akcii_id)
        values
        ('Sn9tie', dengi, (select akcii_id from masshtab where akcii_id=akcii_id_));
        commit;
	else rollback;
end if;
end if;

end//
DELIMITER ;

call snyat(10000, 3, 'Po fanchiku');

select * from popolneni9;

/*3.3*/

select*from masshtab;


EXPLAIN SELECT * FROM masshtab WHERE kolvo_ludei = 7000; /*без индекса проходит 3 строчки*/

Create index ludi on masshtab(kolvo_ludei);

EXPLAIN SELECT * FROM masshtab WHERE kolvo_ludei = 7000; /*1 строка*/

select*from finansirovanie;

EXPLAIN SELECT * FROM finansirovanie WHERE summa_deneg = 10100 AND id_strani = 7; /*без индекса проходит 4 строчки*/

Create index fin_ on finansirovanie(summa_deneg, id_strani);

EXPLAIN SELECT * FROM finansirovanie WHERE summa_deneg = 10100 AND id_strani = 7; /*1 строка*/

/*3.4*/

alter table opisanie_akcii drop foreign key cn3;
alter table de9telnost_na_akcii drop foreign key de91;
alter table popolneni9 drop foreign key cn20;
alter table finansirovanie drop foreign key fin1;
alter table akcii drop foreign key cn1;

alter table masshtab modify akcii_id varbinary(50);
alter table opisanie_akcii modify akcii_id varbinary(50);
alter table de9telnost_na_akcii modify akcii_id varbinary(50);
alter table popolneni9 modify akcii_id varbinary(50);
alter table finansirovanie modify akcii_id varbinary(50);
alter table akcii modify akcii_id varbinary(50);

alter table opisanie_akcii
add constraint cn3 foreign key(akcii_id) references masshtab(akcii_id) on delete cascade on update cascade;

alter table de9telnost_na_akcii
add constraint de91 foreign key(akcii_id) references masshtab(akcii_id) on delete cascade on update cascade;

alter table popolneni9
add constraint cn20 foreign key(akcii_id) references masshtab(akcii_id) on delete cascade on update cascade;

alter table finansirovanie
add constraint fin1 foreign key(akcii_id) references masshtab(akcii_id) on delete cascade on update cascade;

alter table akcii
add constraint cn1 foreign key(akcii_id) references opisanie_akcii(akcii_id) on delete cascade on update cascade;


select*from masshtab;

update masshtab set akcii_id=aes_encrypt(akcii_id, 'debil');

select cast(aes_decrypt(akcii_id, 'debil') as char) as akcii_id, nachalo_akcii, konec_akcii, kolvo_ludei from masshtab;


DELIMITER //
create procedure popol_shifr(in dengi int, in akcii_id_ int)
begin
 
start transaction;

update finansirovanie
set summa_deneg=summa_deneg + dengi
where cast(aes_decrypt(akcii_id, 'debil') as char)= akcii_id_;
if row_count()>0
		then
        insert into popolneni9
        (oper_name,summa,akcii_id)
        values
        ('popolnenie', dengi, (select akcii_id from masshtab where cast(aes_decrypt(akcii_id, 'debil') as char)=akcii_id_));
        commit;
	else rollback;
end if;

end//
DELIMITER ;

call popol_shifr(10000, 3);

select*from finansirovanie;

DELIMITER //
create procedure snyat_shifr(in dengi int, in akcii_id_ int)
begin
 
start transaction;

update finansirovanie
set summa_deneg=summa_deneg - dengi
where cast(aes_decrypt(akcii_id, 'debil') as char)= akcii_id_;
if row_count()>0
		then
        insert into popolneni9
        (oper_name,summa,akcii_id)
        values
        ('sn9tie', dengi, (select akcii_id from masshtab where cast(aes_decrypt(akcii_id, 'debil') as char)=akcii_id_));
        commit;
	else rollback;
end if;

end//
DELIMITER ;

call snyat_shifr(10000, 3);

select*from popolneni9;