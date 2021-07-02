/*1.1*/

select * from account;

update account
set acc_balance = 1600
where acc_start_date = '2014-08-18';

DELIMITER //
create procedure transfer1(in sender varchar(50), in rec varchar(50), in sum integer)
begin

declare var int;
declare var1 int;

set var = (select acc_balance from account
where acc_owner=sender order by acc_balance limit 1);

set var1 = (select acc_balance from account
where acc_owner=sender order by acc_balance desc limit 1);

set sum = convert(sum, unsigned);
 
start transaction;

if (var>=0 and sum<=var and sum>=0) 
then
update account
set acc_balance=acc_balance-sum
where acc_owner=sender and acc_balance = var;
if row_count()>0
	then 
    update account
    set acc_balance=acc_balance+sum
	where acc_owner=rec;
    if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_recipient,app_time,app_value,app_contr_number)
        values
        (1,sender,rec,now(),sum,rand(10));
        commit;
	else rollback;
end if;
else rollback;
end if;
end if;


if (var1>=0 and sum<=var1 and sum>=0) 
then
update account
set acc_balance=acc_balance-sum
where acc_owner=sender and acc_balance = var1;
if row_count()>0
	then 
    update account
    set acc_balance=acc_balance+sum
	where acc_owner=rec;
    if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_recipient,app_time,app_value,app_contr_number)
        values
        (1,sender,rec,now(),sum,rand(10));
        commit;
	else rollback;
end if;
else rollback;
end if;

else 
signal sqlstate '45000'
			set message_text = 'Nedostatochno sredstv';
end if;

end//
DELIMITER ;

select * from account;

call transfer1(1, 2, 1500);

select * from account;

select*from appointment;


/*1.2*/

DELIMITER //
create procedure popolnenie(in sender varchar(50), in sum double)
begin
 
start transaction;

update account
set acc_balance=acc_balance+sum
where acc_number=sender;
if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_time,app_value,app_contr_number)
        values
        (3,sender,now(),sum,rand(10));
        commit;
	else rollback;
end if;

end//
DELIMITER ;

call popolnenie('3525 5456 4557 3424',300);

select*from account;

DELIMITER //
create procedure snyatie(in sender varchar(50), in sum double)
begin
 
start transaction;

if ((select acc_balance from account
where acc_number=sender)>=0 and sum<=(select acc_balance from account
where acc_number=sender)) 
then
update account
set acc_balance=acc_balance-sum
where acc_number=sender;
if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_time,app_value,app_contr_number)
        values
        (2,sender,now(),sum,rand(10));
        commit;
	else rollback;
end if;
end if;

end//
DELIMITER ;

call snyatie('2366 8867 4657 2355',300);

select*from account;

/*1.3*/


create database bank_with_triggers;
use bank_with_triggers;

drop database bank_with_triggers;

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
acc_number Varchar(50) primary key,
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



delimiter //
create trigger proverka before update on account
for each row
begin
if old.acc_balance<0 or new.acc_balance<0 then
  signal sqlstate '45000';
end if;
end//
delimiter ;

select*from account;

update account
set acc_balance=acc_balance-1500
where acc_number='2366 8867 4657 2355';

/*1.4*/

use bank;

SET SQL_SAFE_UPDATES = 0;

alter table appointment drop foreign key ff2;
alter table account modify acc_number varbinary(50);
alter table appointment modify app_sender varbinary(50);
alter table appointment
add constraint ff2 foreign key (app_sender) references account(acc_number) 
on delete cascade on update cascade;
alter table appointment modify app_recipient varbinary(50);

select * from appointment;

select * from account;

update account set acc_number=aes_encrypt(acc_number, 'bank');
select cast(aes_decrypt(acc_number, 'bank') as char) as acc_number, acc_owner from account;

drop procedure perevod;

DELIMITER //
create procedure perevod(in sender varchar(50), in rec varchar(50), in sum double)
begin
 
start transaction;

if (select acc_balance from account
where cast(aes_decrypt(acc_number, 'bank') as char)=sender)>=0 and sum<=(select acc_balance from account
where cast(aes_decrypt(acc_number, 'bank') as char)=sender) 
then
update account
set acc_balance=acc_balance-sum
where cast(aes_decrypt(acc_number, 'bank') as char)=sender;
if row_count()>0
  then 
    update account
    set acc_balance=acc_balance+sum
  where cast(aes_decrypt(acc_number, 'bank') as char)=rec;
    if row_count()>0
    then
        insert into appointment
        (app_op,app_sender,app_recipient,app_time,app_value,app_contr_number)
        values
        (1,aes_encrypt(sender, 'bank'),aes_encrypt(rec, 'bank'),now(),sum,rand(10));
        commit;
  else rollback;
end if;
else rollback;
end if;
end if;

end//
DELIMITER ;

call perevod('8888 2345 6453 8547','7824 1244 3465 6577',300);

select*from account;


drop procedure popolnenie1;

DELIMITER //
create procedure popolnenie1(in sender varchar(50), in sum double)
begin
 
start transaction;

update account
set acc_balance=acc_balance+sum
where cast(aes_decrypt(acc_number, 'zaz') as char)=sender;
if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_time,app_value,app_contr_number)
        values
        (3,aes_encrypt(sender, 'zaz'),now(),sum,rand(10));
        commit;
	else rollback;
end if;

end//
DELIMITER ;

call popolnenie1('3525 5456 4557 3424',300);

select*from account;

DELIMITER //
create procedure snyatie1(in sender varchar(50), in sum double)
begin
 
start transaction;

if (select acc_balance from account
where cast(aes_decrypt(acc_number, 'zaz') as char)=sender)>=0 and sum<=(select acc_balance from account
where cast(aes_decrypt(acc_number, 'zaz') as char)=sender) 
then
update account
set acc_balance=acc_balance-sum
where cast(aes_decrypt(acc_number, 'zaz') as char)=sender;
if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_time,app_value,app_contr_number)
        values
        (2,aes_encrypt(sender, 'zaz'),now(),sum,rand(10));
        commit;
	else rollback;
end if;
end if;

end//
DELIMITER ;

call snyatie1('2366 8867 4657 2355',300);

/*1.5*/

drop view user1;
select * from appointment;

create view user1 
as select app_op, cast(aes_decrypt(app_sender, 'bank') as char) as user, app_time, app_value from appointment
where datediff(app_time,'2020-12-05')>0 
and datediff('2020-12-30',app_time)>0 
and cast(aes_decrypt(app_sender, 'bank') as char)='8888 2345 6453 8547';

select * from user1;

/*1.6*/
use bank;


create table credit
(
cr_id int primary key,
cr_user int,
cr_user_type enum('fiz','urid'),
cr_type enum('long','fast'),
cr_summ double,
cr_ostatok double default 0,
cr_start_date date,
cr_end_date date,
cr_procent double,
cr_aim_fiz enum('potrepitelskie','nedviszimost','avto'),
cr_aim_urid varchar(50),
constraint cn10 foreign key(cr_user) references person(person_id) on update cascade on delete cascade
);


select*from account;


delimiter //
create trigger dd before insert on credit
for each row
begin
  if (select acc_balance from account
	where acc_owner=new.cr_user)<=0.5*(new.cr_summ) THEN
	 signal sqlstate '45000';
	else	
		update account
        set acc_balance=acc_balance+new.cr_summ
        where acc_owner=new.cr_user;
  end if;
end//
delimiter ;


insert into credit 
values
(1, 1,'fiz ', 'long', 10000.5,0, '2019-11-22','2023-11-21', 12.5, 'nedviszimost',NULL),
(2, 2, 'fiz ', 'fast', 20000, 0, '2020-11-24','2021-02-25', 5, 'potrepitelskie',NULL),
(3, 3, 'fiz ', 'fast', 1000, 0, '2020-10-05','2021-01-06', 12.5, 'nedviszimost',NULL);

select * from credit;


DELIMITER //
create procedure pogashenie(in user int)
begin
 
declare sum_per_month, ostatok double; 
set sum_per_month=((select cr_summ from credit where cr_user=user order by cr_ostatok limit 1)/ /*сумма к оплате за месяц*/
(select 
truncate(datediff((select cr_end_date from credit where cr_user=user order by cr_ostatok limit 1),
(select cr_start_date from credit where cr_user=user order by cr_ostatok limit 1))*0.5,0))) /*сумма за месяц без процентов */
+ 
(((select cr_summ from credit where cr_user=user order by cr_ostatok limit 1)-(select cr_ostatok from credit where cr_user = user order by cr_ostatok limit 1))
*((select cr_procent from credit where cr_user=user order by cr_ostatok limit 1)/100))  /*количество средств, оставшихся для уплаты, делится на число месяцев*/
/ (select 
truncate(datediff((select cr_end_date from credit where cr_user=user order by cr_ostatok limit 1),
(select cr_start_date from credit where cr_user=user order by cr_ostatok limit 1))*0.5,0));
set ostatok = (select cr_summ from credit where cr_user = user order by cr_ostatok limit 1)-(select cr_ostatok from credit where cr_user = user order by cr_ostatok limit 1); 
if sum_per_month>ostatok then
	set sum_per_month=ostatok;
end if;
start transaction;

update account
set acc_balance=acc_balance-sum_per_month
where acc_owner=user;
if row_count()>0 and (select acc_balance from account where acc_owner=user)>0
	then 
    update credit
    set cr_ostatok=cr_ostatok+sum_per_month
	where cr_user=user;
    if row_count()>0
		then
        insert into appointment
        (app_op,app_sender,app_recipient,app_time,app_value,app_contr_number)
        values
        (2,(select acc_number from account where acc_owner=user),NULL,now(),sum_per_month,rand(10));
        commit;
	else rollback;
end if;
else rollback;
end if;

end//
DELIMITER ;

call pogashenie(3);
select * from account;
select * from credit;
select*from appointment;


delimiter //
create procedure history_(in id int)
begin
	select * from credit where cr_user=id order by cr_start_date;
end//
delimiter ;

call history_(3);