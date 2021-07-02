drop database mmf2020;
create database mmf2020;

use mmf2020;


create table _groups(
	gr_id int primary key auto_increment,
    gr_course int not null,
    gr_spec enum('km', 'web', 'econom')
);



create table studs(
	st_id int primary key auto_increment,
	st_name varchar(30), 
	st_surname varchar(30), 
	ref_gr_id int not null,
	st_form enum('budget', 'paid'), 
	st_scolar float,
    st_birth date,
	constraint cn1 foreign key (ref_gr_id) references _groups(gr_id) on delete cascade
);


create table teachers
(
	teach_id int primary key auto_increment,
    teach_name varchar(30),
    teach_surname varchar(30)
);



create table subjects(
	sub_id int primary key auto_increment, 
	sub_name varchar(50), 
	ref_teach_id int not null, 
	sub_hours int not null,
	constraint cn2 foreign key (ref_teach_id) references teachers(teach_id) on delete cascade
);


create table exams(
exam_id int primary key auto_increment,
ref_sub_id int not null, 
ref_gr_id int not null,
exam_date datetime, 
constraint cn3 foreign key (ref_sub_id) references subjects(sub_id) on delete cascade,
constraint cn4 foreign key (ref_gr_id) references _groups(gr_id) on delete cascade
);



create table credits(
	credit_id int primary key auto_increment,
	ref_sub_id int not null,
    ref_gr_id int not null,
    credit_date datetime,
    constraint cn5 foreign key (ref_sub_id) references subjects(sub_id) on delete cascade,
    constraint cn6 foreign key (ref_gr_id) references _groups(gr_id) on delete cascade
);




create table exams_students(
	ref_st_id int not null,
	ref_exam_id int not null,
	mark int,
    primary key(ref_st_id, ref_exam_id),
    constraint cn7 foreign key (ref_st_id) references studs(st_id) on delete cascade,
	constraint cn8 foreign key (ref_exam_id) references exams(exam_id) on delete cascade
);


create table credits_students(
	ref_st_id int not null,
	ref_credit_id int not null,
	state bool,
    primary key(ref_st_id, ref_credit_id),
    constraint cn9 foreign key (ref_st_id) references studs(st_id) on delete cascade,
	constraint cn10 foreign key (ref_credit_id) references credits(credit_id) on delete cascade
);


create table lessons(
	lesson_id int primary key auto_increment,
    ref_sub_id int not null,
    ref_gr_id int not null,
    lesson_date datetime,
    constraint cn11 foreign key (ref_sub_id) references subjects(sub_id) on delete cascade,
	constraint cn12 foreign key (ref_gr_id) references _groups(gr_id) on delete cascade
);


create table lessons_students(
	ref_st_id int not null,
    ref_lesson_id int not null,
    attended bool,
    mark int,
	primary key(ref_st_id, ref_lesson_id),
    constraint cn13 foreign key (ref_st_id) references studs(st_id) on delete cascade,
    constraint cn14 foreign key (ref_lesson_id) references lessons(lesson_id) on delete cascade
);





# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Tables inserting
insert into _groups
(gr_course, gr_spec)
values
(1, 'km'),
(2, 'km'),
(4, 'km'),
(2, 'web'),
(2, 'econom');


insert into studs
(st_name, st_surname, ref_gr_id, st_form, st_scolar, st_birth)
values
('Dima', 'Bichun', 1, 'budget', 78, '2003/12/10'), 
('Sho', 'Vei', 1, 'budget', 100, '2002/10/02'), 
('Liza', 'Lipen', 1, 'budget', 120, '2003/03/15'),
('Kiryl', 'Stankevich', 2, 'paid', 0, '2002/01/24'),
('Edgar', 'Vasilevski', 2, 'budget', 140, '2003/10/12'),
('Pavel', 'Dydyshko', 3, 'budget', 120, '2000/07/13'),
('Vlad', 'Rabec', 4, 'paid', 0, '2001/07/19'),
('Fiodor', 'Krasin',4 , 'budget', 100, '2001/08/17'),
('Zakhar', 'Usenko', 5, 'budget', 100, '2002/02/11'),
('Polina', 'Miduk', 5, 'budget', 120, '2002/03/20');

select * from studs;

insert into teachers
(teach_surname, teach_name)
values
('Kushnerov', 'Alex'),
('Vasilevich', 'Mihail'),
('Amelkin', 'Vladimir'),
('Nagorny', 'Yriu'),
('Atrohkau', 'Kiryll');

insert into subjects
(sub_name, ref_teach_id, sub_hours)
values
('db', 1, 1000000), 
('km', 2, 70),
('diffury', 3, 100),
('proga', 4, 120),
('psa', 5, 100);

insert into exams
(ref_sub_id, ref_gr_id, exam_date)
values
(1, 2, '2021/01/02'),
(1, 5, '2021/01/03'),
(2, 1, '2021/01/02'),
(2, 2, '2021/01/05'),
(3, 2, '2021/01/08'),
(3, 4, '2021/01/02'),
(4, 1, '2021/01/05'),
(4, 2, '2021/01/11'),
(5, 3, '2021/01/01');

insert into credits
(ref_sub_id, ref_gr_id, credit_date)
values
(1, 2, '2020/12/21'),
(1, 5, '2020/12/22'),
(2, 1, '2020/12/21'),
(2, 2, '2020/12/24'),
(3, 2, '2020/12/29'),
(3, 4, '2020/12/21'),
(4, 1, '2020/12/24'),
(4, 2, '2020/12/28'),
(5, 3, '2020/12/20');

insert into lessons
(ref_sub_id, ref_gr_id, lesson_date)
values
(1, 2, '2020/12/11'),
(1, 5, '2020/12/09'),
(2, 1, '2020/12/11'),
(2, 2, '2020/12/14'),
(3, 2, '2020/12/09'),
(3, 4, '2020/12/11'),
(4, 1, '2020/12/14'),
(4, 2, '2020/12/09'),
(5, 3, '2020/12/10');

insert into exams_students
(ref_st_id, ref_exam_id, mark)
values
(1, 2, 3),
(1, 5, 7),
(2, 1, 4),
(2, 2, 10),
(3, 2, 8),
(3, 4, 8),
(4, 1, 6),
(4, 2, 7),
(5, 3, 10);



select * from exams_students;

insert into lessons_students
(ref_st_id, ref_lesson_id, attended, mark)
values
(1, 2, 1, 8), 
(2, 1, 0, 9), 
(1, 1, 1, 4),
(3, 3, 1, 6),
(3, 4, 0, 10),
(5, 1, 1, 7),
(4, 3, 1, 4),
(1, 3, 0 , 7),
(4, 2, 1, 9),
(2, 2, 0, 10);

set sql_safe_updates=0;


# %%%%%%%%%%%%%%%%%%%%%%%%%%


# Хранение информации о здровье, активности, оценках и оплате студента

alter table studs
add column st_health enum("bad", "ok", "perfect") default 'ok';


update studs
	set st_health = 'bad'
where ref_gr_id = 2;

alter table studs
add column st_activity enum('4len_ss', 'obichni_chel', 'starosta');

select * from studs;

update studs
	set st_activity = 'starosta'
where st_id = 10;

select * from studs;

create table students_fee (
	fee_id int primary key auto_increment,
    ref_st_id int not null,
    val float not null default 300,
    discount bool not null default false,
    state bool not null default false,
    constraint cn15 foreign key (ref_st_id) references studs(st_id)
);

insert into students_fee
(ref_st_id)
(select st_id from studs where st_form = 'paid');

create table students_marks(
	st_id int,
	mark int not null default 4,
	constraint cn16 foreign key (st_id) references studs(st_id) on delete cascade
);

insert into students_marks
(st_id)
(select st_id from studs);

select * from students_marks;