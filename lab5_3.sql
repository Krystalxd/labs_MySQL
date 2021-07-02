/*2.1*/
set SQL_SAFE_UPDATES = 0;

create database shop;
use shop;

drop database shop;

create table store
(
st_id int primary key,
st_name enum('1','2'),
st_number varchar(50),
st_money int
);

insert into store
values
(1,'1','2342 3845 8558 0583',12000),
(2,'2','2355 6577 7544 3665',11500);

create table shops
(
sh_id int primary key,
sh_name varchar(30),
sh_number varchar(50),
sh_money int
);

insert into shops
values
(1,'Duplo','2222 4566 3456 3924', 10000),
(2,'Olpud', '2345 3425 1847 8539', 15000);

create table sellers
(
sel_id int primary key,
sel_name varchar(30),
sel_surname varchar(30)
);

insert into sellers
values
(1,'Vitali','Cal'),
(2,'Valera', 'Gromak');

create table clients
(
cli_id int primary key,
cli_number varchar(50),
cli_money int
);

insert into clients
values
(1,'2435 5345 5466 3245', 1500),
(2,'2355 6577 3466 3455', 2000);

create table products
(
prod_id int primary key,
prod_name varchar(30),
prod_date date,
prod_cost int,
prod_location enum('store','shops')
);

insert into products
values
(1,'Moloko','2020-12-03', 200, 'store'),
(2,'Water','2020-12-03', 150, 'shops');

select * from products;

create table st_prod
(
st_prod_prod_id int,
st_prod_st_id int,
st_prod_prod_amount int,
constraint hh foreign key(st_prod_prod_id) references products(prod_id),
constraint ss foreign key(st_prod_st_id) references store(st_id)
);

insert into st_prod
values
(1,1, 200),
(2,2, 100),
(1,2, 200);

create table shop_prod
(
shop_prod_prod_id int,
shop_prod_shop_id int,
shop_prod_prod_amount int,
constraint vv foreign key(shop_prod_prod_id) references products(prod_id),
constraint cc foreign key(shop_prod_shop_id) references shops(sh_id)
);

insert into shop_prod
values
(1,1, 150),
(2,2, 100),
(1,2, 150);



create table sells
(
sell_id int primary key auto_increment,
sell_prod_id int,
sell_client_id int,
sell_shop_id int,
sell_store_id int,
sell_summ int,
sell_amount int,
constraint rr foreign key (sell_prod_id) references products(prod_id),
constraint yy foreign key (sell_client_id) references clients(cli_id),
constraint uu foreign key (sell_shop_id) references shops(sh_id),
constraint ii foreign key (sell_store_id) references store(st_id)
);

select *from products ;


set SQL_SAFE_UPDATES = 0;


select*from shops;
select*from st_prod;
select*from shop_prod;
select * from clients;
select * from products;
select * from sells;

drop table sells;
select * from store;

DELIMITER //
create procedure pokupka(in client_num varchar(50), in shop_num int, in id_tovara int,in sel_id int, in amount int)
begin
start transaction;
update clients
set cli_money=cli_money-(select prod_cost from products where prod_id=id_tovara)*amount  /* снимаем деньги у покупателя */
where cli_number=client_num;
    if row_count()>0
    then
    if (select prod_location from products where prod_id=id_tovara) = 'shops' 
        then
			update shops
			set sh_money=sh_money+(select prod_cost from products where prod_id=id_tovara)*amount  /* кладем деньги в кассу */
			where sh_id=shop_num;
      insert into sells
      (sell_prod_id, sell_client_id, sell_shop_id,sell_store_id, sell_summ, sell_amount)
      values
      (id_tovara,(select cli_id from clients where cli_number=client_num) ,(select sh_id from shops where sh_id=shop_num),null,(select prod_cost from products where prod_id=id_tovara)*amount, amount);
      if row_count()>0
        then
		update shop_prod
        set shop_prod_prod_amount = shop_prod_prod_amount - amount
        where (shop_prod_prod_id = id_tovara and shop_prod_shop_id = shop_num);  /* убираем купленный товар их шопов */
        end if;
        if row_count() > 0
        then
        commit;
        end if;
    else 
	  update store
	  set st_money=st_money+(select prod_cost from products where prod_id=id_tovara)*amount  /* кладем деньги в кассу */
	  where st_id=shop_num;
      insert into sells
      (sell_prod_id, sell_client_id,sell_store_id,sell_summ, sell_amount)
      values
      (id_tovara,(select cli_id from clients where cli_number=client_num) ,(select st_id from store where st_id=shop_num),(select prod_cost from products where prod_id=id_tovara)*amount,amount);
    if row_count()>0
        then
        update st_prod
        set st_prod_prod_amount = st_prod_prod_amount - amount
        where (st_prod_prod_id = id_tovara and st_prod_st_id = shop_num);  /* убираем купленный товар их сторов */
        end if;
        if row_count()>0
        then
        commit;
        end if;
    end if;
  else rollback;
end if;

end//
DELIMITER ;

delete from sells;
select * from shops;
select * from store;
select * from clients;
select*from st_prod;
select*from shop_prod;
select * from sells;

call pokupka('2435 5345 5466 3245', 1, 1, 2, 2);
call pokupka('2435 5345 5466 3245','2345 3425 1847 8539',2, 2, 1);
call pokupka('2435 5345 5466 3245','2345 3425 1847 8539',2, 2, 1);
call pokupka('2435 5345 5466 3245','2345 3425 1847 8539',2, 2, 1);
select*from products;
select * from sells;
call pokupka('2435 5345 5466 3245','2345 3425 1847 8539',2, 2, 5);



delimiter //
create trigger proverka_na_bomsha before update on clients
for each row
begin  
  if new.cli_money<0 
    then
    signal sqlstate '45000';
  end if;
end//
delimiter ;

/*если товара нигде нет*/
delimiter //
create trigger check_status before insert on sells
for each row 
begin
  if new.sell_shop_id is null and new.sell_store_id is null
    then
        signal sqlstate '45000';
  end if;
end //
delimiter ;

update clients
set cli_money=cli_money+10000;

select * from sells;

delimiter //
create trigger store_bonus before insert on sells
for each row
begin
     if new.sell_summ/(select prod_cost from products where prod_id=new.sell_prod_id)>=3 /*купил более 3 штук */
     and (select count(sell_id) from sells where sell_client_id=new.sell_client_id group by sell_client_id)>=3 
     then 
    set new.sell_shop_id=null;
    set new.sell_store_id=(select st_prod_st_id from st_prod where st_prod_prod_id=new.sell_prod_id limit 1);  
        set new.sell_amount=new.sell_amount+1;
     end if;
end//
delimiter ;