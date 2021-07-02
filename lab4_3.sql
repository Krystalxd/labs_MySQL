use mmf2020;

# Тригер для успешной успеваемости

select * from exams_students;

alter table exams_students
add column zachet varchar(50);


DELIMITER //
create trigger udpdate_scolars after insert on exams_students
for each row
begin
	if new.mark is not null then
		if (select st_form from studs where st_id = new.ref_st_id) ='budget' then
			update studs
				set st_scolar = 100 + 40 * ((select avg(mark) from exams_students where ref_exam_id = new.ref_exam_id and zachet = "Yes") / 10) 
			where st_id = new.ref_st_id;
		else
			if (select avg(mark) from exams_students where ref_exam_id = new.ref_exam_id and zachet = "Yes" ) > 9 then
				update students_fee
					set discount = true
				where ref_st_id = new.ref_st_id;
            end if;
        end if;
    end if;
end//
DELIMITER ;

/*ДОООООООООООООООООООППППППППППППП*/

DELIMITER //
create trigger ekzamen before insert on exams_students
for each row
begin
	if new.mark is not null then
		if new.mark < 4 or new.zachet = "No" then
			signal sqlstate '45000'
			set message_text = 'Sessi9 ne sdana';
		end if;
	end if;
end//
DELIMITER ;


select * from exams_students;

DELIMITER //
create procedure ekzamen_pass(in st_id_ int, in exam_id_ int, in mark_ int, in zachet_ varchar(50))
begin
	insert into exams_students
    (ref_st_id, ref_exam_id, mark, zachet)
    values
    (st_id_, exam_id_, mark_, zachet_);
    
    if (select count(mark) = 4 from exams_students where ref_st_id = st_id_) then
        update studs
			set st_scolar = 100 + 50*((select avg(mark) from exams_students where ref_st_id = st_id_)/10)
            where st_id = st_id_;
            
		delete from exams_students where ref_st_id = st_id_;
        
	end if;
end//

DELIMITER ;

delete from exams_students;
select * from exams_students;
select * from studs;
select * from _groups;

call ekzamen_pass(1, 1, 4, "Yes");
call ekzamen_pass(1, 2, 4, "No");
call ekzamen_pass(1, 2, 4, "Yes");
call ekzamen_pass(1, 3, 10, "Yes");
call ekzamen_pass(1, 4, 7, "Yes");
call ekzamen_pass(2, 4, 7, "Yes");

/* /////////////////////////////////////////// */

DELIMITER //
create procedure iz_grupi_v_grupu(in st_id_ int, in new int, in old int, in exam_id_ int, in mark_ int, in zachet_ varchar(50))
begin
if (select gr_spec from _groups where gr_id = old) = (select gr_spec from _groups where gr_id = new) then
	update studs
		set ref_gr_id = new
		where st_id = st_id_;
	else 
		if (mark_ < 4 or zachet_ = "No") then
        signal sqlstate '45000'
			set message_text = 'Vi ne perevelis :(';
		end if;
		
        call ekzamen_pass(st_id_, exam_id_, mark_, zachet_);
        update studs
			set ref_gr_id = new
			where st_id = st_id_;
	end if;

end//

DELIMITER ;

call iz_grupi_v_grupu(1, 4, 1, 2, 6, "Yes");


/* ///////////////////////////////////////////// */

DELIMITER //
create trigger migration before update on studs
for each row
begin
	if (select mark from exams_students where ref_st_id = new.st_id) < 4 and new.ref_gr_id > old.ref_gr_id then
		signal sqlstate '45000'
			set message_text = 'Problems with session';
    end if;
end//
DELIMITER ;



DELIMITER //
create trigger prevent_ill_studs before update on studs
for each row
begin
	if new.ref_gr_id > old.ref_gr_id and new.st_health = 'bad' then
		signal sqlstate '45000'
			set message_text = 'Problems with health';
    end if;
end//
DELIMITER ;


DELIMITER //
create trigger exam_gr_id before insert on exams_students
for each row
begin
	if (select exams.ref_gr_id from exams where exams.exam_id = new.ref_exam_id) != (select studs.ref_gr_id from studs where st_id = new.ref_st_id) then
		signal sqlstate '45000'
			set message_text = 'Group id mismatch';
    end if;
end//
DELIMITER ;

