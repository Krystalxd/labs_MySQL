use bank;

DELIMITER //
create procedure transfer1(in sender varchar(50), in rec varchar(50), in sum integer)
begin

declare var int;

set var = (select acc_balance from account
where acc_owner=sender);

set sum = convert(sum, unsigned);
 
start transaction;

if (var>=0 and sum<=var and ((select acc_balance from account where acc_owner = sender) - sum) > (((((1+sqrt(5))/2)^(select(dayofmonth(current_date())))) - ((-((1+sqrt(5))/2))^(select(dayofmonth(current_date())) * -1)))/ (1 + sqrt(5) - 1))) 
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
end//
DELIMITER ;

call transfer1(2,4,1500);

select * from account;

select 256%10;

DELIMITER //
create procedure sli9nie(in owner int)
begin

declare var int;
declare var1 int;
declare new_number int;
declare var3 int;
declare var4 int;

set var = (select acc_balance from account
where acc_owner=owner order by acc_balance limit 1);

set var1 = (select acc_balance from account
where acc_owner=owner order by acc_balance desc limit 1);

set var3 = (select acc_number from account
where acc_owner=owner order by acc_balance limit 1);

set var4 = (select acc_number from account
where acc_owner=owner order by acc_balance desc limit 1);

/* задаем новый номер (не успел до конца прописать) */

set new_number = if(var4%1000000000000000 > var3%1000000000000000,var4%1000000000000000 * 1000000000000000 + if(var4%100000000000000 > var3%100000000000000,var4%100000000000000 * 100000000000000, var3%100000000000000 * 100000000000000), var3%1000000000000000 * 1000000000000000 + if(var4%100000000000000 > var3%100000000000000,var4%100000000000000 * 100000000000000, var3%100000000000000 * 100000000000000));

start transaction;

if (select count(acc_owner) from account where acc_owner = owner) > 1 
then

delete from account where acc_balance = var1;

update account
set acc_balance = var + var1
where acc_owner=owner;

if row_count()>0
	then 
    update account
    set acc_number= new_number
	where acc_owner=owner;
else rollback;
end if;
end if;
end//
DELIMITER ;

drop procedure sli9nie;

call sli9nie(1);