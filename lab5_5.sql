/*4*/

create database phrases;
use phrases;

create table phrase
(
ph_id int primary key auto_increment,
ph_text Varchar(200)
);

insert into phrase
(ph_text)
values
('Пройдут года, и я останусь, а ты станешь тенью
И будешь также говорить про дорогой ремень'),
('Я сам себе хозяин, но спасибо моим фэнам,
Благодаря им всем я скоро выйду на арены.'),
('Я теперь домашний кот, но я с улиц навсегда.'),
('Говорит я изменился, меня можно слушать,
Вот мой хуй, вот твой рот - согрей мою душу.'),
('Они не хотят готовить со мной,
Но почему-то хотят, чтобы я с ними делился едой.
'),
('Никогда не буду старым, я умру молодым.'),
('Я читаю фейков шаринганом, как Учиха Саске.'),
('Я чувствую боль, где-то в груди,
И мои раны сердца не залечить.
Кандзи на лбу означает любовь,
Но, скажи, почему не могу я любить?'),
('Я смеюсь сейчас, буду плакать потом.
Не думаю о завтра, я живу одним днём.'),
('Я живу в твоих сохранённых фото.'),
('Зачем мечтать? Ведь мечта — это выстрел мимо.'),
('Лучшие'),
('Мне охота пристрелить тебя, ведь ты ведёшь себя как дичь'),
('вставай, заебал'),
('Ей попало не в то горло, хуй сосала захлебнулась'),
('этот никотин заменяет мне любовь..'),
('Не мужчина, а мечта!'),
('аааааааа
она хочет меняя, меняя, меняяя'),
('мы друзья с Пашей идите нахуй, мы вам всех отъебашим ебало нахуй!!1!'),
('Джарахов просит фит, но я его не вижу
Джарахов просит клип, но я его не слышу'),
('Чё, смешно, сука? Чё ты там услышал?
Я, чё, похож на клоуна? Ну-ка, встал и вышел!'),
('Ты на мне сверху, или ты снизу
Или я сзади, открой мне визу'),
('Я курю как можно больше, ведь я не хочу стареть'),
('И не надо принимать слишком близко к сердцу свои недостатки'),
('Бандиты не на геликах — на геликах с мигалкой.'),
('Мы копим на кусок гранита из-под палки.
Собираем крошки, запивая просроченным Pulpy.'),
('Улица Аврора воспитала подлеца 😎'),
('Депрессия — моя богиня, и в крови рука у меня опять..'),
('почему ты хочешь есть со мной, если ты не голодал со мной, уебок?'),
('Серые дома так давят серых людей.
Ненависть в глазах у наших белых детей.'),
('Покойся с миром, Децл 🙏🏻'),
('Мне не надо семьи, мне не надо тебя.
Я не нужен себе сам, и я не верю в чудеса.'),
('а помнишь, сука, что было в январе?'),
('Я проснулся, почистил свои зубы.
Заказал еду, поцеловал тебя в губы. 😙❤'),
('Оставайся человеком даже если ты при бабках ☝🏻'),
('Твой любимый рэпер носит вместо хуя клитор'),
('Тяжело стать богатым, но тяжелее остаться ☝'),
('Никого не уважаю, будто никого не знаю
Пью коньяк заместо чая, мне нормально, если чё
Я рифмую на глаголы, ведь я клал на это всё
Если я здесь выступаю, значит будет горячо'),
('Вы можете меня убить, мне не страшно,
Мне страшно стать таким, как ты — таким продажным.'),
('Хорошо, когда есть сука, что всегда сосёт🤤'),
('Мы играем в Фифу, после курим траву😈'),
('васап я фейс ну и хули'),
('пиф паф'),
('Когда светит солнце,
Я вижу лишь тень.
Я так привык, если можешь, развей
Эту ревность во мне, ведь я верю тебе. 🌖'),
('Ничего не должен людям, я хозяин себе сам.'),
('я называю ее сукой, потому что она сука'),
('"Главное, чтобы ты был счастлив от того, чем занимаешься"'),
('бииииич'),
('Я враг государства, мой язык — это правда.'),
('Никогда я не доверю свое сердце вам.
Чтоб вот так его когда-то, кто-то мне ещё разбивал.'),
('Среди тревог и вечной грусти,
Стань мне антидепрессантом. 💊
Позволь любить себя допустим,
Я не прошу любви обратной. 💔'),
('Если страны — это времена года, тогда Россия — осень.');

select*from phrase;

create fulltext index ind9 on phrase (ph_text);

select*from phrase
where match(ph_text) against ('сука');

select*from phrase
where match(ph_text) against ('любви');

select ph_text,
match (ph_text) against('Если')
from phrase
where match (ph_text) against('Если');

select ph_text,
match (ph_text) against('почему')
from phrase
where match (ph_text) against('почему');


/* величина зависит от количества слов в поле ph_text, того насколько близко данное слово встречается к началу текста, 
отношения количества встретившихся слов к количеству всех слов в поле и тд*/


select*from phrase;

SELECT * FROM phrase
        WHERE MATCH (ph_text)
        AGAINST ('если' IN NATURAL LANGUAGE MODE);
        
select ph_text,
match (ph_text) against('Если' IN NATURAL LANGUAGE MODE)
from phrase
where match (ph_text) against('Если' IN NATURAL LANGUAGE MODE);
        
        
select ph_text,
match (ph_text) against('Если' IN NATURAL LANGUAGE MODE with Query Expansion)
from phrase
where match (ph_text) against('Если' IN NATURAL LANGUAGE MODE with Query Expansion);

/*5*/


/*https://itif.ru/otlichiya-myisam-innodb/*/

/*индекс*/

/*https://forums.devart.com/ru/viewtopic.php?t=13033*/
create database dvizh;
use dvizh;


create table textt_my
(
id int primary key auto_increment,
t_textt varchar(50)
)engine=MyISAM;

insert into textt_my
(t_textt)
values
('Это антихайп'),
('а я ебу чтоли???');

create fulltext index ii on textt_my (t_textt);

select*from textt_my
where match(t_textt) against ('Это' in boolean mode);

create table textt_inno
(
id int primary key auto_increment,
textt varchar(50)
);

insert into textt_inno
(textt)
values
('Это антихайп'),
('а я ебу чтоли???');

create fulltext index ii2 on textt_inno (textt);

select*from textt_inno
where match(textt) against ('Это');

/*транзакции*/


CREATE TABLE t1(
  i INT
) ENGINE = MYISAM;

DELIMITER //
CREATE PROCEDURE p()
BEGIN
  START TRANSACTION;
  INSERT INTO t1 VALUES (1);
  ROLLBACK;
END//
DELIMITER ;

CALL p();

SHOW WARNINGS;

SELECT*FROM t1;

CREATE TABLE t2(
  i INT
) ;

DELIMITER //
CREATE PROCEDURE p2()
BEGIN
  START TRANSACTION;
  INSERT INTO t2 VALUES (1);
  ROLLBACK;
END//
DELIMITER ;

CALL p2();

SHOW WARNINGS;

SELECT*FROM t2;