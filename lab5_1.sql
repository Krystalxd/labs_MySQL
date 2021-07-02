create database bank;
use bank;

drop database bank;

/*1*/
create table person
(
person_id INT primary key,
person_name varchar(30),
person_surname varchar(30),
person_adress varchar(50),
person_status ENUM('online','offline'),
person_date date
);

create table account
(
acc_type ENUM('1','2'),
acc_balance double,
acc_number varchar(50) primary key,
acc_start_date datetime,
acc_owner int,
constraint ff foreign key (acc_owner) references person(person_id) on delete cascade on update cascade
);

create table operations
(
op_id int primary key,
op_type ENUM('perevod','snyatie','popolnenie')
);

create table appointment
(
app_id int primary key auto_increment,
app_op int,
app_sender varchar(50),
app_recipient varchar(50),
app_time datetime,
app_value double,
app_contr_number double,
constraint ff1 foreign key (app_op) references operations(op_id) on delete cascade on update cascade,
constraint ff2 foreign key (app_sender) references account(acc_number) on delete cascade on update cascade
);

insert into person
values
(1, 'Edgar ', 'Vasilevski', 'Bagrationa-69-88', 'offline', '2020-11-20'),
(2, 'Sasha ', 'Kakasha', 'Pushkina-20-2', 'online', '2020-11-22'),
(3, 'Griga ', 'God', 'Voenaya-10-10', 'online', '2020-11-23'),
(4, 'Sasha', 'SXS', 'Pobediteley-12-12', 'offline', '2020-11-24'),
(5, 'Natasha ', 'Shisha', 'Kamennaya-11-16', 'online', '2020-11-25');

insert into account
values
('1', 1500, '8888 2345 6453 8547', '2014-08-18', 1),
('2', 1600, '7824 1244 3465 6577', '2015-06-22', 2),
('1', 1400, '3525 5456 4557 3424', '2012-05-24', 3),
('1', 1450, '2366 8867 4657 2355', '2015-10-12', 4),
('2', 1800, '8967 4546 3255 3353',  '2014-11-11', 5);

insert into operations
values
(1, 'perevod'),
(2, 'snyatie'),
(3, 'popolnenie');