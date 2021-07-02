DROP DATABASE poshila9_grupa;

CREATE DATABASE poshila9_grupa;
USE poshila9_grupa;


create table students
(
	stCard int primary key,
	firstName varchar(10),
    secondName varchar(20),
    age int,
    avgScore double,
    rating int,
    scolarship double,
    fee double,
    sex enum('male', 'female'),
    favSubject set('DB', 'KM', 'Algebra', 'Calculus', 'Geometry', 'MPaI', 'DE')
);

insert into students values
(1922136, 'Ilya', 'Borovsky', 18, 8.7, 5, 155.64, null, 'male', 'DB,MPaI,Algebra'),
(1922113, 'Katya', 'Belskaya', 18, 9.6, 2, 171.64, null, 'female', 'Calculus'),
(1922117, 'Nastya', 'Savchenko', 18, 8.7, 4, 171.64, null, 'female', 'KM,Geometry'),
(7654321, 'Levi', 'Taborov', 18, 8.3, null, 155.64, null, 'male', 'MPaI'),
(2345678, 'Arina', 'Logvinenko', 18, 7.8, null, 155.64, null, 'female', 'DB,Algebra,Geometry'),
(1234567, 'Edgar', 'Vasilevski', 18, 8.55, 6, 155.64, null, 'male', 'DB,KM,MPaI'),
(1922174, 'Alexey', 'Karlovich', 18, 7.8, null, 155.64, null, 'male', 'DB,KM'),
(1922298, 'Kirill', 'Stankevich', 18, 7, null, 155.64, null, 'male', 'DB,KM'),
(1922220, 'Elena', 'Zrazikova', 18, 7.6, null, 155.64, null, 'female', 'Algebra,Geometry'),
(1922087, 'Katya', 'Labun', 18, 7.2, null, 155.64, null, 'female', 'DE'),
(1922322, 'Matvey', 'Draevich', 18, 7.6, null, null, 3293.0, 'male', 'KM'),
(1922287, 'Egor', 'Buksa', 18, 6.4, null, null, 3293.0, 'male', 'DB');

select * from students;

set SQL_SAFE_UPDATES = 0;

ALTER TABLE students
CHANGE stCard id int4 after favSubject;

ALTER TABLE students
CHANGE fee fee_ double after scolarship;

ALTER TABLE students
change sex sex_ varchar(40) first;

select * from students;

UPDATE students
SET scolarship = scolarship + scolarship * 0.1;

UPDATE students
SET fee_ = fee_ + fee_ * 0.15;

select * from students;

UPDATE students
SET scolarship = scolarship + scolarship * 0.2
WHERE ((length(secondName) - length(replace(secondName,'a',''))) + (length(secondName) - length(replace(secondName,'e',''))) + (length(secondName) - length(replace(secondName,'y',''))) + (length(secondName) - length(replace(secondName,'u',''))) + (length(secondName) - length(replace(secondName,'i',''))) + (length(secondName) - length(replace(secondName,'o','')))) > ((length(secondName) - length(replace(secondName,'q',''))) + (length(secondName) - length(replace(secondName,'z',''))) + (length(secondName) - length(replace(secondName,'w',''))) + (length(secondName) - length(replace(secondName,'s',''))) + (length(secondName) - length(replace(secondName,'x',''))) + (length(secondName) - length(replace(secondName,'d',''))) + (length(secondName) - length(replace(secondName,'c',''))) + (length(secondName) - length(replace(secondName,'r',''))) + (length(secondName) - length(replace(secondName,'f',''))) + (length(secondName) - length(replace(secondName,'v',''))) + (length(secondName) - length(replace(secondName,'t',''))) + (length(secondName) - length(replace(secondName,'g',''))) + (length(secondName) - length(replace(secondName,'b',''))) + (length(secondName) - length(replace(secondName,'h',''))) + (length(secondName) - length(replace(secondName,'n',''))) + (length(secondName) - length(replace(secondName,'j',''))) + (length(secondName) - length(replace(secondName,'m',''))) + (length(secondName) - length(replace(secondName,'k',''))) + (length(secondName) - length(replace(secondName,'l',''))) + (length(secondName) - length(replace(secondName,'p',''))));

select * from students;

UPDATE students
SET scolarship = scolarship + scolarship * 0.2
WHERE ((length(id) - length(replace(id, '3',''))) + 
 (length(id) - length(replace(id, '6',''))) + (length(id) - length(replace(id, '9','')))) >
 (length(id) - length(replace(id, '7', '')));

select * from students;

select * from students;

create table devochki(
	stCard int primary key,
	firstName varchar(10),
    secondName varchar(20),
    age int,
    avgScore double,
    rating int,
    scolarship double,
    fee double,
    sex enum('male', 'female'),
    favSubject set('DB', 'KM', 'Algebra', 'Calculus', 'Geometry', 'MPaI', 'DE')
);

insert into devochki
(stCard, firstName, secondName, age, avgScore, rating, scolarship, fee, sex, favSubject)
SELECT id, firstName, secondName, age, avgScore, rating, scolarship, fee_, sex_, favSubject
FROM students
WHERE sex_ = "female";

create table malchiki(
	stCard int primary key,
	firstName varchar(10),
    secondName varchar(20),
    age int,
    avgScore double,
    rating int,
    scolarship double,
    fee double,
    sex enum('male', 'female'),
    favSubject set('DB', 'KM', 'Algebra', 'Calculus', 'Geometry', 'MPaI', 'DE')
);

insert into malchiki
(stCard, firstName, secondName, age, avgScore, rating, scolarship, fee, sex, favSubject)
SELECT id, firstName, secondName, age, avgScore, rating, scolarship, fee_, sex_, favSubject
FROM students
WHERE sex_ = "male";

select * from devochki;
select * from malchiki;

