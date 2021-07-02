SET GLOBAL log_bin_trust_function_creators = 1;
set SQL_SAFE_UPDATES = 0;

# Процедура для изменения стипендии у всех студентов
select * from studs;

DELIMITER //
create procedure change_scolars(in n float)
begin
	update studs
		set st_scolar = st_scolar * n
    where st_form = 'budget';
end//
DELIMITER ;

call change_scolars(1.1);

# Функция, вычисляющая среднюю оценку на экзамене у определённого преподавателя.


DELIMITER //
create function teach_avg_mark_exm(teacher_id int)
returns float deterministic 
begin
	return (
		select avg(exams_students.mark) from exams_students
			inner join exams
			on exams.exam_id = exams_students.ref_exam_id
			inner join subjects
			on exams.ref_sub_id = subjects.sub_id
		where subjects.ref_teach_id = teacher_id
	);
end//
DELIMITER ;


select teach_avg_mark_exm(2);


# Процедура для  начисления  надбавок  общественно  активным  студентам.


DELIMITER //
create procedure raise_scolars_active(in n float, in name int)
begin
		update studs
		set st_scolar = if(st_activity = '4len_ss', st_scolar + n * 100, st_scolar),
            st_scolar = if(st_activity = 'starosta', st_scolar + n * 10, st_scolar),
			st_scolar = if(st_activity = 'obichni_chel', st_scolar + n * 0, st_scolar)
		where st_form = 'budget' and st_id = name;
end//
DELIMITER ;

select * from studs;

call raise_scolars_active(1, 1);


# Процедуры для вывода топ-5 самых успешных студентов факультета, топ-5 «двоечников», топ-5 самых активных.


create table best_five_st(
	res_name varchar(30), 
	res_surname varchar(30),
    res_avg_mark float
);


DELIMITER //
create procedure best_five_studs()
begin
	declare s_name, s_surname varchar(30);
	declare s_avg float;
    declare is_end int default 0;
    
    declare studscur cursor for 
		select studs.st_name, studs.st_surname, avg(exams_students.mark) as avg_mark from studs
			inner join exams_students
			on studs.st_id = exams_students.ref_st_id
		group by studs.st_id
		order by avg_mark desc
        limit 5;
        
	declare continue handler for not found set is_end=1;
    
    open studscur;
    curs: loop
		fetch studscur into s_name,s_surname,s_avg;
        if is_end then
			leave curs;
		end if;
        insert into best_five_st values(s_name,s_surname,s_avg);
	end loop curs;
    close studscur;
end//
DELIMITER ;



call best_five_studs();

select * from best_five_st;



create table worst_five_st(
	res_name varchar(30), 
	res_surname varchar(30),
    res_avg_mark float
);


DELIMITER //
create procedure worst_five_studs()
begin
	declare s_name, s_surname varchar(30);
	declare s_avg float;
    declare is_end int default 0;
    
    declare studscur cursor for 
		select studs.st_name, studs.st_surname, avg(exams_students.mark) as avg_mark from studs
			inner join exams_students
			on studs.st_id = exams_students.ref_st_id
		group by studs.st_id
		order by avg_mark asc # отличие от пред функции
        limit 5;
        
	declare continue handler for not found set is_end=1;
    
    open studscur;
    curs: loop
		fetch studscur into s_name,s_surname,s_avg;
        if is_end then
			leave curs;
		end if;
        insert into worst_five_st values(s_name,s_surname,s_avg);
	end loop curs;
    close studscur;
end//
DELIMITER ;


call worst_five_studs();

select * from worst_five_st;



create table active_five_st(
	res_name varchar(30), 
	res_surname varchar(30),
    res_activity float
);


DELIMITER //
create procedure active_five_studs()
begin
	declare s_name, s_surname varchar(30);
	declare s_activity float;
    declare is_end int default 0;
    
    declare studscur cursor for 
		select st_name, st_surname, st_activity from studs
		order by st_activity desc
        limit 5;
        
	declare continue handler for not found set is_end=1;
    
    open studscur;
    curs: loop
		fetch studscur into s_name,s_surname,s_activity;
        if is_end then
			leave curs;
		end if;
        insert into active_five_st values(s_name,s_surname,s_activity);
	end loop curs;
    close studscur;
end//
DELIMITER ;

call active_five_studs();

select * from active_five_st;


# Процедура  для  отчисления  проблемных  студентов.


DELIMITER //
create procedure kick_pidarases()
begin
	delete from studs where st_id in (
		select studs.st_id from studs 
			join credits_students 
			on credits_students.ref_st_id = studs.st_id and credits_students.state = false
		group by studs.st_id
		having count(credits_students.state) > 0)
	or st_id in (
		select studs.st_id from studs
			inner join exams_students
			on exams_students.ref_st_id = studs.st_id and exams_students.mark < 4
		group by studs.st_id
		having count(exams_students.mark) > 0);
end//
DELIMITER ;



# Функция вычисляющую самую популярную оценку на факультете (в группе)

create table popular_marks (
	mark int primary key auto_increment,
	quant int default 0
);

insert into popular_marks
()
values
(),
(),
(),
(),
(),
(),
(),
(),
(),
();




DELIMITER //
create function popular_mark_group(group_id int)
returns int deterministic 
begin
	return (
		select lessons_students.mark from lessons_students
			inner join lessons
			on lessons.ref_gr_id = group_id
		group by lessons_students.mark
		order by count(lessons_students.mark) desc
		limit 1
	);
end//
DELIMITER ;

select popular_mark_group(3);


# Процедура для вычисления процента пропущенных занятий для студентов определённой группы.


DELIMITER //
create function not_attended(group_id int)
returns float deterministic
begin
	declare group_qt int default 0;
	declare lessons_qt int default 0;
    declare not_attend_qt int default 0;
    
    set group_qt = (select count(studs.st_id) from studs where ref_gr_id = group_id);
    
    set lessons_qt = (select count(lessons.lesson_id) from lessons where lessons.ref_gr_id = group_id);
    
    set not_attend_qt = (
		select count(lessons_students.attended) from lessons 
			inner join lessons_students 
			on lessons_students.ref_lesson_id = lessons.lesson_id and lessons_students.attended = false
		where lessons.ref_gr_id = group_id
	);
    
    return not_attend_qt / (group_qt * lessons_qt);
end//
DELIMITER ;


select not_attended(1);

# Процедура для выдачи бонусов студентам. 


DELIMITER //
create procedure xl_bonus(in start_date date, in end_date date)
begin
	declare delta int default 1;
    
    set delta = DATEDIFF(end_date, start_date);
    
	update studs
		set st_scolar = st_scolar + 50*(datediff(end_date, st_birth)/delta)
    where st_form = 'budget' and st_birth >= start_date and st_birth <= end_date;
end//
DELIMITER ;


call xl_bonus('1999/01/01', '2005/09/01');

select * from studs;


DELIMITER //
create procedure xxl_bonus(in start_date date, in end_date date, in week_day int)
begin
	declare delta int default 1;
    
    set delta = datediff(end_date, start_date);
	
    update studs
		set st_scolar = st_scolar + 50*(datediff(end_date, st_birth)/delta)
    where st_form = 'budget' and st_birth >= start_date and st_birth <= end_date;
    
    update studs
		set st_scolar = st_scolar + 150 - 50*(datediff(end_date, st_birth)/delta)
    where st_form = 'budget' and st_birth >= start_date and st_birth <= end_date and dayofweek(st_birth) = week_day;
end//
DELIMITER ;



call xxl_bonus('1999/01/01', '2005/09/01', 5);

# Процедура лояльности преподавателей


DELIMITER //
create function teach_loyalty(teacher_id int)
returns float deterministic
begin
	declare lesn_avg float default 0;
    declare exm_avg float default 0;
    
    set lesn_avg = (
		select avg(lessons_students.mark) from subjects 
			inner join lessons
			on lessons.ref_sub_id = subjects.sub_id
			inner join lessons_students 
			on lessons_students.ref_lesson_id = lessons.lesson_id 
		where subjects.ref_teach_id = teacher_id
    );
    
    set exm_avg = (
		select avg(exams_students.mark) from subjects 
			inner join exams
			on exams.ref_sub_id = subjects.sub_id
			inner join exams_students on 
			exams_students.ref_exam_id = exams.exam_id 
		where subjects.ref_teach_id = teacher_id
    );
    
    return (lesn_avg / exm_avg);
end//
DELIMITER ;


select teach_loyalty(2);


# Функция предсказания оценок


DELIMITER //
create function expected_mark(stud_id int, ex_id int)
returns float deterministic
begin
	declare teacher_id int default (
		select subjects.ref_teach_id from exams 
			inner join subjects 
			on subjects.sub_id = exams.ref_sub_id 
		where exams.exam_id = ex_id
    );

	declare teach_loyalty float default teach_loyalty(teacher_id);
    
    declare lesn_avg float default (
		select avg(lessons_students.mark) from subjects 
			inner join lessons
			on lessons.ref_sub_id = subjects.sub_id
			inner join lessons_students 
			on (lessons_students.ref_lesson_id = lessons.lesson_id)  and (ref_st_id = stud_id)
		where subjects.ref_teach_id = teacher_id
    );
    
    declare exm_avg float default (
		select avg(exams_students.mark) from exams_students 
		where exams_students.ref_st_id = stud_id
    );
    
    return teach_loyalty*lesn_avg*0.6 + 0.4*exm_avg;
end//
DELIMITER ;


select expected_mark(3 ,4);