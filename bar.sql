create database poshiloi_bar;
use poshiloi_bar;

create table products
(
product_id integer primary key auto_increment,
product_name varchar(50),
product_type varchar(30),
product_price float
);

create table products_sells
(
sell_id integer not null,
product_id integer not null,
quantity integer,
primary key(sell_id, product_id),
constraint cn1 foreign key (sell_id) references sells(sell_id),
constraint cn2 foreign key (product_id) references products(product_id)
);

create table sells
(
sell_id integer primary key,
sell_date datetime not null,
barman_id integer not null,
sell_amount float not null,
constraint cn3 foreign key (barman_id) references staff(employee_id) 
);

create table staff
(
employee_id integer primary key,
employee_name varchar(50),
employee_surname varchar(50),
employee_position enum("barman","cook")
);

create table contracts
(
contract_id integer primary key,
contract_start_date date,
contract_end_date date,
salary integer not null,
primary key(contract_id),
constraint cn4 foreign key(contract_id) references staff(employee_id)
);

insert into products
(product_name, product_type, product_price)
values
("Балтика 7", "Пиво", 2),
("Бульбаш", "Водка", 9);

select * from products;

insert into staff
()
values
(1,"Александр","Куш", "barman"),
(2,"Ольга" , "Лаврова", "cook");

select * from staff;

insert into sells
(sell_id, sell_date, barman_id, sell_amount)
values
(1, "2020-09-09 12:30:30", 1, 3),
(2, "2020-09-09 20:45:30", 2, 2);

select * from sells;

insert into products_sells
()
values
(1, 1, 3),
(2, 2, 4);

select * from products_sells;

insert into contracts
()
values
(1, "2018-09-09", "2022-09-09", 1000),
(2, "2016-12-12", "2020-09-09", 1000);

select * from contracts;

show tables;