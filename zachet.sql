create database languages;

drop database languages;
use languages;

SET SQL_SAFE_UPDATES = 0;

create table english_word
(
id_word int primary key auto_increment not null,
word_english_name varchar(50) not null
);

insert into english_word
(word_english_name)
values
("Gay"),
("Club"),
("Data"),
("Base"),
("Mathematics"),
("Analysis"),
("Paper"),
("Toilet"),
("Telephone"),
("Computer");

select * from english_word;


create table russian_word
(
id_word int not null,
word_russian_name varchar(50) not null,
primary key(id_word),
constraint cn1 foreign key (id_word) references english_word(id_word)
);

insert into russian_word
(id_word, word_russian_name)
values
(1,"Гей"),
(2,"Клуб"),
(3,"Данные"),
(4,"База"),
(5,"Математика"),
(6,"Анализ"),
(7,"Бумага"),
(8,"Туалет"),
(9,"Телефон"),
(10,"Кампутер");


create table french_word
(
id_word int not null,
word_french_name varchar(50) not null,
primary key(id_word),
constraint cn2 foreign key (id_word) references english_word(id_word)
);

insert into french_word
(id_word, word_french_name)
values
(1,"Gay"),
(2,"Club"),
(3,"Les données"),
(4,"Base"),
(5,"Mathématiques"),
(6,"Une analyse"),
(7,"Papier"),
(8,"Toilette"),
(9,"Téléphone"),
(10,"ordinateur");


create table deutch_word
(
id_word int not null,
word_deutch_name varchar(50) not null,
primary key(id_word),
constraint cn3 foreign key (id_word) references english_word(id_word)
);

insert into deutch_word
(id_word, word_deutch_name)
values
(1,"Fröhlich"),
(2,"Verein"),
(3,"Daten"),
(4,"Base"),
(5,"Mathematik"),
(6,"Analyse"),
(7,"Papier"),
(8,"Toilette"),
(9,"Telefon"),
(10,"Computer");

create table translate
(
id_word int not null,
english_name varchar(50) default NULL,
russian_name varchar(50) default NULL,
french_name varchar(50) default NULL,
deutch_name varchar(50) default NULL,
primary key(id_word),
constraint cn4 foreign key (id_word) references english_word(id_word)
);

insert into translate
(id_word, english_name, russian_name)
values
(1, "Gay", "Гей");

select * from english_word
	join russian_word using(id_word);
    
    
update table1,
(select id as i, col as c from table2) as tb
set col = tb.c where id = tb.i


DELIMITER //
create procedure perevod(in id int, in first enum("Englsih", "Russian", "French", "Deutch"), in second enum("Englsih", "Russian", "French", "Deutch"))
begin
	if first = "English" and second = "Russian" then
	insert into translate
    (id_word, english_name, russian_name)
    select * from english_word
    join russian_word using(id_word)
    where english_word.id_word = id;
    
    end if;
    
    if first = "Russian" and second = "English" then
	insert into translate
    (id_word, english_name, russian_name)
    select * from russian_word
    join english_word using(id_word)
    where russian_word.id_word = id;
    
    end if;
    
    
    if first = "English" and second = "French" then
	insert into translate
    (id_word, english_name, french_name)
    select * from english_word
    join french_word using(id_word)
    where english_word.id_word = id;
    
    end if;
    
    if first = "French" and second = "English" then
	insert into translate
    (id_word, english_name, french_name)
    select * from french_word
    join english_word using(id_word)
    where french_word.id_word = id;
    
    end if;
    
    if first = "English" and second = "Deutch" then
	insert into translate
    (id_word, english_name, deutch_name)
    select * from english_word
    join deutch_word using(id_word)
    where english_word.id_word = id;
    
    end if;
    
    if first = "Deutch" and second = "English" then
	insert into translate
    (id_word, english_name, deutch_name)
    select * from deutch_word
    join english_word using(id_word)
    where deutch_word.id_word = id;
    
    end if;
    
    
    if first = "Russian" and second = "French" then
	insert into translate
    (id_word, russian_name, french_name)
    select * from russian_word
    join french_word using(id_word)
    where russian_word.id_word = id;
    
    end if;
    
    
    if first = "French" and second = "Russian" then
	insert into translate
    (id_word, russian_name, french_name)
    select * from french_word
    join russian_word using(id_word)
    where french_word.id_word = id;
    
    end if;
    
    
    if first = "Russian" and second = "Deutch" then
	insert into translate
    (id_word, russian_name, deutch_name)
    select * from russian_word
    join deutch_word using(id_word)
    where russian_word.id_word = id;
    
    end if;
    
    if first = "French" and second = "Deutch" then
	insert into translate
    (id_word, french_name, deutch_name)
    select * from french_word
    join deutch_word using(id_word)
    where french_word.id_word = id;
    
    end if;
    
     if first = "Deutch" and second = "French" then
	insert into translate
    (id_word, french_name, deutch_name)
    select * from deutch_word
    join french_word using(id_word)
    where deutch_word.id_word = id;
    
    end if;
end//

DELIMITER ;
drop procedure perevod;
delete from translate;
select * from translate;
select * from english_word;

call perevod(3,"Russian","Deutch");



DELIMITER //
create trigger same before insert on translate
for each row
begin
	if new.id_word in (select id_word from translate) and (new.english_name in (select english_name from translate) and new.russian_name in (select russian_name from translate)) then
		signal sqlstate '45000'
			set message_text = 'Perevod bil sdelan rannee';
    end if;
    
    if new.id_word in (select id_word from translate) and (new.english_name in (select english_name from translate) and new.french_name in (select french_name from translate)) then
		signal sqlstate '45000'
			set message_text = 'Perevod bil sdelan rannee';
    end if;
    
    if new.id_word in (select id_word from translate) and (new.english_name in (select english_name from translate) and new.deutch_name in (select deutch_name from translate)) then
		signal sqlstate '45000'
			set message_text = 'Perevod bil sdelan rannee';
    end if;
    
    if new.id_word in (select id_word from translate) and (new.russian_name in (select russian_name from translate) and new.french_name in (select french_name from translate)) then
		signal sqlstate '45000'
			set message_text = 'Perevod bil sdelan rannee';
    end if;
    
    if new.id_word in (select id_word from translate) and (new.russian_name in (select russian_name from translate) and new.deutch_name in (select deutch_name from translate)) then
		signal sqlstate '45000'
			set message_text = 'Perevod bil sdelan rannee';
    end if;
    
    if new.id_word in (select id_word from translate) and (new.french_name in (select french_name from translate) and new.deutch_name in (select deutch_name from translate)) then
		signal sqlstate '45000'
			set message_text = 'Perevod bil sdelan rannee';
    end if;
    
end//
DELIMITER ;

call perevod(3,"Russian","Deutch");

select * from english_word;

DELIMITER //
create trigger dlina before insert on translate
for each row
begin
	if length(new.id_word) > (select avg(word_english_name) from english_word) * 2  then
		signal sqlstate '45000'
			set message_text = 'Slovo Slishkom dlinnoe';
    end if;
    
end//
DELIMITER ;

