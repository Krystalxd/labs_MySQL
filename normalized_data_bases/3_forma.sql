DROP DATABASE poshilii_avtori;

CREATE DATABASE poshilii_avtori;
USE poshilii_avtori;

create table avtori
(
	id int primary key auto_increment not null,
	author_1 varchar(50),
    author_2 varchar(50),
    title varchar(50),
    ISBN int,
    price float,
    cust_name varchar(50),
    cust_adress varchar(50),
    purch_date date
);

insert into avtori values
(1, 'David Sklar', 'Adam Trachtenberg', "PHP Cookbook", 0596101015, 44.99, 'Emma Brown', '1565 Rainbow Road, Los Angeles, CA 90014', '2009-03-03'),
(2, 'Danny Goodman', null, 'Dynamic HTML', 0596527403, 59.99, 'Darren Ryder', '4758 Emily Drive, Richmond, VA 23219', '2008-12-19'),
(3, 'Hugh E. Williams', 'David Lane', 'PHP and MySQL', 0596005436, 44.95, 'Earl B. Thurston', '862 Gregory Lane, Frankfort, KY 40601', '2009-06-22'),
(4, 'David Sklar', 'Ada Trachtenberg', 'PHP Cookbook', 0596101015, 44.99, 'Darren Ryder', '4758 Emily Drive, Richmond VA 23219', '2008-12-19'),
(5, 'Rasmus Lerdorf', 'Kevin Tatroe and Peter MacIntyre', 'Programming PHP', 0596006815, 39.99, 'David Miller', '3647 Cedar Lane, Waltham, MA 02154', '2009-01-16');

select * from avtori;

create table avtori_3_norm_0
(
    title_1 varchar(50),
    ISBN int primary key not null,
    price float
);

insert into avtori_3_norm_0 values
("PHP Cookbook", 0596101015, 44.99),
('Dynamic HTML', 0596527403, 59.99),
('PHP and MySQL', 0596005436, 44.95),
('Programming PHP', 0596006815, 39.99);

select * from avtori_3_norm_0;


create table avtori_3_norm_1
(
	id integer primary key not null,
    authors varchar(50)
);

insert into avtori_3_norm_1 values
(1, 'David Sklar'),
(2, 'Adam Trachtenburg'),
(3, 'Danny Goodman'),
(4, 'Hugh E. Williams'),
(5, 'David Lane'),
(6, 'Rasmus Lerdorf'),
(7, 'Kevin Tatroe');


select * from avtori_3_norm_1;

create table avtori_3_norm_3
(
	id_avtora integer not null,
    isbn integer not null,
    primary key(id_avtora, isbn),
    constraint cn1 foreign key (id_avtora) references avtori_3_norm_1(id),
    constraint cn2 foreign key (isbn) references avtori_3_norm_0(ISBN)
);


insert into avtori_3_norm_3 values
(1, 0596101015),
(2, 0596101015),
(3, 0596527403),
(4, 0596005436),
(5, 0596005436),
(6, 0596006815),
(7, 0596006815);

select * from avtori_3_norm_3;



create table avtori_3_norm_2
(
	id int primary key auto_increment not null,
    cust_name varchar(50),
    cust_street varchar(50),
    cust_city varchar(50),
    cust_state varchar(50),
    purch_date date
);

insert into avtori_3_norm_2 values
(1,'Emma Brown', '1565 Rainbow Road', 'Los Angeles', 'CA 90014','2009-03-03'),
(2,'Darren Ryder', '4758 Emily Drive', 'Richmond', 'VA 23219','2008-12-19'),
(3,'Earl B. Thurston', '862 Gregory Lane', 'Frankfort','KY 40601','2009-06-22'),
(4,'David Miller', '3647 Cedar Lane', 'Waltham', 'MA 02154','2009-01-16');

select * from avtori_3_norm_2;

