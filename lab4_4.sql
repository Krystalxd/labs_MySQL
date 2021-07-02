use mmf2020;



create table session_ended(
	val bool default false
);

insert into session_ended
()
values
();



DELIMITER //
create function group_to_migrate(group_id int)
returns int deterministic
begin
	return (select _groups.gr_id from  _groups, 
			(select _groups.gr_course as old_course, _groups.gr_spec as old_spec from _groups 
			where _groups.gr_id = group_id) as res
			where _groups.gr_course = res.old_course + 1 and _groups.gr_spec = res.old_spec
		);
end//
DELIMITER ;


DELIMITER //
create procedure studs_migration()
begin
	delete from studs where (select _groups.gr_course from _groups where _groups.gr_id = studs.ref_gr_id) = 4;
	
    update studs
		set ref_gr_id = group_to_migrate(ref_gr_id)
    where st_form ='budget';
    
    
    update studs
		set ref_gr_id = group_to_migrate(ref_gr_id)
    where st_form ='paid' and (select state from students_fee where ref_st_id = st_id);
    
end//
DELIMITER ;


DELIMITER //
create trigger session_end before update on session_ended
for each row
begin
	if new.val = true and old.val = false then
		call kick_pidarases();
        call studs_migration();
        delete from lessons where true;
        delete from credits where true;
        delete from exams where true;
    end if;
end//
DELIMITER ;


insert into _groups
(gr_course, gr_spec)
values
(3, 'km'),
(3, 'web'),
(3, 'econom');

update studs
	set st_health = 'ok'
where ref_gr_id = 2;


update session_ended 
set val = true;

