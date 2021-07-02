use world;

# Выведите страны, в которых ВНП превышает 20000.
select Code,Name,GNP
from country
where country.GNP > 20000
ORDER BY GNP;

select * from countrylanguage;

# Сколько стран мира используют русский язык
select CountryCode
from countrylanguage
where countrylanguage.Language = 'Russian' and countrylanguage.IsOfficial = 'T';

# Найдите страны по площади, превышающие территорию самой большой
# страны в Африке.
select country.Name, country.SurfaceArea, res.area_max from country,
	(
	select max(SurfaceArea) as area_max from country
	where Continent = 'Africa'
	) as res
where country.SurfaceArea > res.area_max;

# Найдите города, которые по населению превышают ровно 3 европейских
# государства


select city.Name, city.Population, min_sum, max_sum from city
,
	(
		select Code, sum(Population) as min_sum from 
		(
				select Code, Population  from country
				where country.Continent = 'Europe'
				order by country.Population
				LIMIT 3
		) as res
	) as res2
,
	(
	select Code, sum(Population) as max_sum from 
		(
				select Code, Population  from country
				where country.Continent = 'Europe'
				order by country.Population
				LIMIT 4
		) as res3
	) as res4

where city.Population > min_sum and city.Population < max_sum;


# дополнительное задание

# количество городов, названия которых состоят из 2 или более слов
select countryCode, count(Name) as amount from city
where (length(city.Name) - length(replace(city.Name, ' ',''))) > 0 or (length(city.Name) - length(replace(city.Name, '-',''))) > 0
group by countryCode;

# Кол-во языков, в названиях которых больше 5 букв
select CountryCode, count(Language) as amount from countrylanguage
where (length(countrylanguage.Language)) > 5
group by CountryCode;


select country.Code, country.Name, res1.amount as Language, res2.amount as Cities from country
join 
(
	select CountryCode, count(Language) as amount from countrylanguage
	where (length(countrylanguage.Language)) > 5
	group by CountryCode
) as res1
on res1.CountryCode = country.Code
join 
(
	select countryCode, count(Name) as amount from city
	where (length(city.Name) - length(replace(city.Name, ' ',''))) > 0 or (length(city.Name) - length(replace(city.Name, '-',''))) > 0
	group by countryCode
) as res2
on res2.countryCode = country.Code
where res2.amount > res1.amount;
