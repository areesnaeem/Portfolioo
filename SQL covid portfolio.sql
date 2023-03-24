-- 1st Excracting whole data to check data available in tables

select *
from coviddeaths
order by location;

select location, date, total_cases,new_cases, total_deaths, new_deaths, population
from coviddeaths;

-- Looking at  deaths to cases ratio in Pakistan
-- likely to die from covid

select location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as death_ratio
from coviddeaths
where location like 'pak%';

-- cases vs population

select location, date,population, total_cases, (total_cases/population)*100 as prevalance
from coviddeaths
where location like 'pak%';

-- countires with highest covid infection ration wrt population

select location, population, max(total_cases), max((total_cases/population))*100 as prevalance
from coviddeaths
where continent is not null
group by location, population
order by prevalance desc;

-- countires with high mortality for covid

select location, population, max(cast(total_deaths as unsigned)) as mortality
from coviddeaths
where continent is not null
group by location, population
order by mortality desc;

select location, max(cast(total_deaths as unsigned)) as mortality
from coviddeaths
where location not in ('europe', 'north america', 'european union', 'south america')
group by location
order by mortality desc;

-- Breaking data on the basis on continent

select continent, max(cast(total_deaths as unsigned)) as mortality
from coviddeaths
-- where location not in ('europe', 'north america', 'european union', 'south america')
where continent is not null
group by continent
order by mortality desc;

-- Global level cases per day


select date, sum(new_cases), sum(cast(new_deaths as unsigned)) as daily_deaths
from coviddeaths
where continent is not null
group by date;

-- Global death ratio

select date, sum(new_cases) as daily_cases, sum(cast(new_deaths as unsigned)) as daily_deaths, (sum(cast(new_deaths as unsigned))/(sum(new_cases)))*100 as death_ratio
from coviddeaths 
-- where continent is not null 
group by date;

/* select date, sum(new_cases), sum(cast(new_deaths as unsigned)) as daily_deaths, sum(cast(new_deaths as unsigned))/(sum(new_cases))* 100 as global_deaths
from coviddeaths 
where continent is not null 
group by date;

*/

-- for total percentage calculations

select sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned)) as daily_deaths, (sum(cast(new_deaths as unsigned))/(sum(new_cases)))*100 as death_ratio
from coviddeaths ;
-- where continent is not null 
-- group by date;


select * 
from covidvaccinations;

-- Joining death and vaccination tables

select * 
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
    and d.date = v.date;
    
-- vaccinations wrt population

select d.continent,d.location,d.date, d.population,v.new_vaccinations
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent is not null
order by location;

select d.continent,d.location,d.date, d.population,v.new_vaccinations
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent is not null and d.location like 'pak%'
order by location;


select d.continent,d.location,d.date, d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by d.location, d.date) as vaccinations
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent is not null
order by location;

-- to check vaccination/population, we need to create CTE (remeber always use select command after CTE creation just like below).

with popvac as (
    select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
        sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by d.location, d.date) as vaccinations
    from coviddeaths d
    join covidvaccinations v on d.location = v.location and d.date = v.date 
    where d.continent is not null
)
select *, (vaccinations/population)*100
from popvac
where continent is not null;

 -- for temporary tables
 
 SELECT CAST(new_vaccinations AS unsigned) FROM covidvaccinations;

 /* casted the column data type but still getting error on incorrect value 
 
drop table if exists temp_date;
create temporary table temp_date
 (
 continent varchar(50),
 loaction varchar(50),
 date date,
 population int,
 new_vaccinations int,
 vaccinations int);
 
INSERT INTO temp_date
SELECT d.continent, d.location, d.date, d.population, CAST(v.new_vaccinations AS UNSIGNED), 
       SUM(CAST(v.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS vaccinations
FROM coviddeaths d
JOIN covidvaccinations v
ON d.location = v.location AND d.date = v.date 
WHERE d.continent IS NOT NULL;

*/

-- Creating view

create view vaccination_ratio as
select d.continent,d.location,d.date, d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by d.location, d.date) as vaccinations
from coviddeaths d
join covidvaccinations v
	on d.location = v.location
    and d.date = v.date
where d.continent is not null;

 
 select * from vaccination_ratio;
 
 
 
 
 
