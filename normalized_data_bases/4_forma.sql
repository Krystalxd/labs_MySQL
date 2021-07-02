DROP DATABASE poshilii_studenti;

CREATE DATABASE poshilii_studenti;
USE poshilii_studenti;

create table studenti
(
	famili9 varchar(50),
	kurs varchar(50),
    uchebnik varchar(50)
);

insert into studenti values
('A', 'Информатика', 'Информатика'),
('A', 'Сети ЭВМ', 'Информатика'),
('A', 'Информатика', 'Сети ЭВМ'),
('A', 'Сети ЭВМ', 'Сети ЭВМ'),
('В', 'Программирование', 'Программирование'),
('В', 'Программирование', 'Теория алгоритмов');

select * from studenti;


create table studenti_1
(
	famili9 varchar(50),
	kurs varchar(50)
);

insert into studenti_1 values
('A', 'Информатика'),
('А', 'Сети ЭВМ'),
('В', 'Программирование');

select * from studenti_1;


create table studenti_2
(
	famili9 varchar(50),
	uchebnik varchar(50)
);

insert into studenti_2 values
('A', 'Информатика'),
('А', 'Сети ЭВМ'),
('В', 'Программирование'),
('В', 'Теория Алгоритмов');

select * from studenti_2;