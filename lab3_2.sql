use poshiloi_stachkom;

select masshtab.akcii_id, opisanie_akcii.opisanie_akcii, gde_sidish.nazvanie_ruvd, contract.salary
from masshtab, opisanie_akcii, gde_sidish, contract;

select count(kolvo_ludei) as ludi, opisanie_akcii.opisanie_akcii
from masshtab inner join opisanie_akcii
on masshtab.akcii_id = opisanie_akcii.akcii_id
group by masshtab.akcii_id;

select akcii.akcii_name as akci9, akcii.uchastnik_id
from akcii inner join uchastniki_stachkoma
on akcii.uchastnik_id = uchastniki_stachkoma.uchastnik_id
group by akcii.uchastnik_id;

select de9telnost_na_akcii.stepen_aktivnosti as aktivnost, contract.contract_id
from de9telnost_na_akcii inner join contract
on de9telnost_na_akcii.contract_id = contract.contract_id
group by de9telnost_na_akcii.contract_id;


select finansirovanie.id_strani as kuklovod, masshtab.kolvo_ludei
from finansirovanie inner join masshtab
on finansirovanie.akcii_id = masshtab.akcii_id
group by finansirovanie.akcii_id;

select nakazanie.bolno, gde_sidish.nazvanie_ruvd as ruvd
from nakazanie inner join gde_sidish
on nakazanie.nakazanie_id = gde_sidish.nakazanie_id
group by nakazanie.nakazanie_id;


select masshtab.akcii_id, masshtab.kolvo_ludei from masshtab,
(select avg(kolvo_ludei) as avg_kolvo from masshtab) as res
where masshtab.kolvo_ludei < res.avg_kolvo;

select finansirovanie.id_strani, finansirovanie.summa_deneg from finansirovanie,
(select avg(summa_deneg) as dengi from finansirovanie) as res1
where finansirovanie.summa_deneg between res1.dengi - 10000
and res1.dengi + 10000;


(select akcii.akcii_name, opisanie_akcii.opisanie_akcii
from akcii inner join opisanie_akcii
on akcii.akcii_id = opisanie_akcii.akcii_id
where akcii.akcii_name = "beganie")
union
(select akcii.akcii_name, opisanie_akcii.opisanie_akcii
from akcii inner join opisanie_akcii
on akcii.akcii_id = opisanie_akcii.akcii_id
where akcii.akcii_name = "po_fanchiku");

# Обновление таблиц с использование оператора соединения
set sql_safe_updates=0;
update finansirovanie join masshtab using(akcii_id)
set summa_deneg = summa_deneg + masshtab.kolvo_ludei
where finansirovanie.prioritet_poddershki = 'Shizneno vashni';

select * from finansirovanie;

create or replace view poshila9_akci9
(akcii_id, uchastnik_id, akcii_name) as
select akcii_id, uchastnik_id, akcii_name from akcii,
(select akcii.akcii_name as idshnik from akcii
where akcii.akcii_name = 'po_fanchiku') as res
where akcii.akcii_name = res.idshnik;


select * from poshila9_akci9;
select * from akcii;