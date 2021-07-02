drop database poshiloi_stachkom;

create database poshiloi_stachkom;
use poshiloi_stachkom;


create table masshtab
(
akcii_id int primary key default ((rand()*100) * (rand()*100) + rand()) not null,
nachalo_akcii datetime,
konec_akcii datetime,
kolvo_ludei int,
masshtab_unique char(50) default(concat(cast(akcii_id as char), " ", cast(kolvo_ludei as char)))
);

create table opisanie_akcii
(
akcii_id integer,
opisanie_akcii varchar(50),
chislo_akcii integer,
primary key(akcii_id),
constraint cn3 foreign key(akcii_id) references masshtab(akcii_id)
);

create table gde_sidish
(
nakazanie_id int primary key default ((rand()*10) * (rand()*10) + rand()) not null,
nazvanie_ruvd char(50),
nachalo_otsidki datetime,
konec_otsidki datetime,
gde_sidish_unique char(50) default(concat(cast(nakazanie_id as char), " ", nazvanie_ruvd))
);

create table contract
(
contract_id int primary key default ((rand()*100) * (rand()*100) + rand()) not null,
contract_start_date date,
contract_end_date date,
salary int not null,
contract_unique char(50) default(concat(cast(contract_id as char), " ", cast(salary as char)))
);

create table uchastniki_stachkoma
(
uchastnik_id int,
uchastnik_position varchar(50),
data_prisoedineni9 date,
kod_mes9ca int,
primary key(uchastnik_id),
constraint cn7 foreign key (uchastnik_id) references contract(contract_id)
);

create table akcii
(
akcii_id integer,
uchastnik_id integer,
akcii_name varchar(50),
primary key(akcii_id, uchastnik_id),
constraint cn1 foreign key (akcii_id) references opisanie_akcii(akcii_id),
constraint ogr foreign key (uchastnik_id) references uchastniki_stachkoma(uchastnik_id)
);

create table de9telnost_na_akcii
(
contract_id integer not null,
akcii_id integer not null,
stepen_aktivnosti varchar(50),
primary key(contract_id, akcii_id),
constraint de9 foreign key(contract_id) references contract(contract_id),
constraint de91 foreign key(akcii_id) references masshtab(akcii_id)
);

create table nalichie_rossiyskogo_sleda
(
id_strani integer primary key default(7) not null,
poddershivausha9_kampani9 varchar(50) not null,
nalichie_rossiyskogo_sleda varchar(50) not null,
rosi9_unique char(50) default(concat(cast(id_strani as char), " ", nalichie_rossiyskogo_sleda))
);

create table finansirovanie
(
id_strani integer not null,
akcii_id integer not null,
summa_deneg integer not null,
prioritet_poddershki varchar(50) not null,
primary key(id_strani, akcii_id),
constraint fin foreign key (id_strani) references nalichie_rossiyskogo_sleda(id_strani),
constraint fin1 foreign key (akcii_id) references masshtab(akcii_id)
);

create table nakazanie
(
nakazanie_id int,
bolno varchar(45) not null,
primary key(nakazanie_id),
constraint cn5 foreign key (nakazanie_id) references gde_sidish(nakazanie_id)
);

insert into masshtab
(akcii_id, nachalo_akcii, konec_akcii, kolvo_ludei)
values
(1, "2020-09-12 15:30", "2020-09-12 22:00", 15000),
(2, "2020-09-09 10:15", "2020-09-09 15:00", 7000),
(3, "2020-09-06 20:30", "2020-09-06 22:00", 15000);

select * from masshtab;

insert into opisanie_akcii
()
values
(2, "priiti na ploshad' nezavisimosti", 2),
(3, "nadrugat's9 nad domom pravitelstva", 5),
(1, "pobegat' ot omona", 4);

select * from opisanie_akcii;

insert into gde_sidish
(nakazanie_id, nazvanie_ruvd, nachalo_otsidki, konec_otsidki)
values
(1,"centralnoe", "2020-09-05 15:30", "2020-09-07 12:00"),
(2,"okrestina", "2020-08-09 22:30", "2020-08-12 12:00");

select * from gde_sidish;

insert into contract
(contract_id, contract_start_date, contract_end_date, salary)
values
(1, "2018-05-10", "2023-05-10", 700),
(2, "2017-08-09", "2022-08-09", 1000);

select * from contract;

insert into uchastniki_stachkoma
()
values
(1, "slesar", "2020-09-15", 6),
(2, "sborshik", "2022-10-06", 1);

select * from uchastniki_stachkoma;

insert into akcii
()
values
(1, 2, "beganie"),
(3, 1, "besscennoe");

insert into akcii
()
values
(2, 1, "po_fanchiku");

select * from akcii;

insert into nakazanie
()
values
(2, "soidet"),
(1, "ochen bolno");

select * from nakazanie;

insert into de9telnost_na_akcii
()
values
(2, 3, "bu9nim"),
(1, 2, "spokoino"),
(1, 1, "chillim");

select * from de9telnost_na_akcii;

insert into nalichie_rossiyskogo_sleda
(id_strani, poddershivausha9_kampani9, nalichie_rossiyskogo_sleda)
values
(7, "Gazprom", "Prisutstvuet"),
(420, "OOO Cheshskie_Pendosi", "Otsutstvuet");

select * from nalichie_rossiyskogo_sleda;

insert into finansirovanie
()
values
(420, 3, 1000000000, "Shizneno vashni"),
(7, 1, 100, "Po fanchiku");

insert into finansirovanie
()
values
(7, 3, 500000075, "Shizneno vashni");

select * from finansirovanie;


UPDATE uchastniki_stachkoma
SET data_prisoedineni9= date_add(CURRENT_DATE(), 
interval (if(dayofweek(CURRENT_DATE())>5, 12, 5) - dayofweek(CURRENT_DATE())) day);