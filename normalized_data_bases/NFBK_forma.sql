DROP DATABASE poshilii_tarifi;

CREATE DATABASE poshilii_tarifi;
USE poshilii_tarifi;

create table tarifi
(
	id_korta int not null,
	vrem9_nachala time,
    vrem9_konca time,
    tarif varchar(50)
);

insert into tarifi values
(1,'09:30', '10:30', 'Бережливый'),
(1,'11:00', '12:00', 'Бережливый'),
(1,'14:00', '15:30', 'Стандарт'),
(2,'10:00', '11:30', 'Премиум-В'),
(2,'11:30', '13:30', 'Премиум-В'),
(2,'15:00', '16:30', 'Премиум-A');

select * from tarifi;


create table tarifi_1
(
	tarif varchar(50),
	id_korta int not null,
	dorogoi bool,
    primary key(tarif)
);

insert into tarifi_1 values
('Бережливый', 1, 0),
('Стандарт', 1, 1),
('Премиум-В', 2, 0),
('Премиум-А',2, 1);

select * from tarifi_1;



create table tarifi_2
(
	tarif varchar(50),
	vrem9_nachala time,
    vrem9_konca time,
    constraint cn1 foreign key(tarif) references tarifi_1(tarif)
);

insert into tarifi_2 values
('Бережливый', '09:30', '10:30'),
('Бережливый', '11:00', '12:00'),
('Стандарт', '14:00', '15:30'),
('Премиум-В', '10:00', '11:30'),
('Премиум-В', '11:30', '13:30'),
('Премиум-А', '15:00', '16:30');

select * from tarifi_2;