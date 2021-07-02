CREATE DATABASE deti;
drop database deti;
use deti;

create table birth(
id int,
first_name varchar(20),
last_name varchar(20),
children_name varchar(40),
children_birthday varchar(50)
);

insert into birth values
(1001, 'Jane', 'Doe', 'Mary,Sam', '1992-01-01,1994-05-15'),
(1002, 'John', 'Doe', 'Mary,Sam', '1992-01-01,1994-05-15'),
(1003, 'Jane', 'Smith', 'John,Pat,Lee,Mary', '1994-10-05,1990-10-12,1996-06-06,1994-08-21'),
(1004, 'John', 'Smith', 'Michael', '1996-04-07'),
(1005, 'Jane', 'Jones', 'Edward,Martha', '1995-10-21,1989-10-15');
set SQL_SAFE_UPDATES = 0;

select * from birth;


create table poshilie_deti(
	child varchar(50),
    child_birth_1 date,
    child_id int primary key auto_increment
);


insert into poshilie_deti values
('Mary', '1992-01-01', 1),
('John', '1994-05-15', 2),
('Michael', '1996-06-06', 3),
('Edward', '1995-10-21', 4),
('Sam', '1994-05-15', 5),
('Pat', '1990-10-12', 6),
('Martha', '1989-10-15', 7),
('Lee', '1996-06-06', 8),
('Mary', '1994-08-21', 9);

select * from poshilie_deti;


create table parent(
	id int primary key not null,
	first_name varchar(20),
	last_name varchar(20)
);

insert into parent values
(1001, 'Jane', 'Doe'),
(1002, 'John', 'Doe'),
(1003, 'Jane', 'Smith'),
(1004, 'John', 'Smith'),
(1005, 'Jane', 'Jones');

select * from parent;

create table family(
	parent_id int,
    child_id int not null,
    primary key(parent_id, child_id),
    constraint cn1 foreign key (parent_id) references parent(id),
    constraint cn2 foreign key (child_id) references poshilie_deti(child_id)
);

insert into family values
(1001, 1),
(1003, 2),
(1004, 3),
(1005, 4),
(1001, 5),
(1003, 6),
(1005, 7),
(1003, 8),
(1003, 9),
(1002, 1),
(1002, 5);

select * from family;
