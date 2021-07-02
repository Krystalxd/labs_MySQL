create database GAI;

use GAI;

create table plates
(
	driver_id int not null,
    car_plate_number varchar(20) not null,
    primary key(car_plate_number)
);

alter table plates add unique KEY driver_idx (car_plate_number, driver_id);