select * from [portfolio project]..['covid death']
WHERE continent IS NOT NULL
order by 3,4

--select * from [portfolio project]..['covid vacc$']
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population_density  
from [portfolio project]..['covid death']
WHERE continent IS NOT NULL
order by 1,2


-- Looking at Total Cases Vs Total Deaths
-- Shows Likelihood of dying if you contract covid in your country.

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    CASE 
        WHEN TRY_CAST(total_cases AS FLOAT) IS NOT NULL AND TRY_CAST(total_cases AS FLOAT) <> 0
        THEN (TRY_CAST(total_deaths AS FLOAT) / TRY_CAST(total_cases AS FLOAT))*100
        ELSE NULL
    END AS death_percentage
FROM
    [portfolio project]..['covid death']
WHERE continent IS NOT NULL
where location like '%states%'
ORDER BY
    location, date;

-- Looking at Total Cases Vs Population
-- Shows What percentage population got covid.

SELECT
    location,
    date,
    total_cases,
    population,
    CASE 
        WHEN TRY_CAST(total_cases AS FLOAT) IS NOT NULL AND TRY_CAST(total_cases AS FLOAT) <> 0
        THEN (TRY_CAST(total_cases AS FLOAT) / TRY_CAST(population AS FLOAT))*100
        ELSE NULL
    END AS Population_percentage
FROM
    [portfolio project]..['covid death']
WHERE continent IS NOT NULL
where location like '%states%'
ORDER BY
    location, date;


-- Looking at countries with highest infection rate compared to population

SELECT
    location,
    population,
    MAX(total_cases) as highestinfectioncount,
    MAX((TRY_CAST (total_cases AS FLOAT) / TRY_CAST(population AS FLOAT))*100) AS Max_Population_percentage
FROM
    [portfolio project]..['covid death']
WHERE continent IS NOT NULL
-- WHERE location LIKE '%states%'
GROUP BY
    location,population
ORDER BY
    Max_Population_percentage DESC;

-- Showing countries with highest death count per Population

SELECT
    location,
    MAX(CAST(total_deaths AS INT)) as totaldeathcount
FROM [portfolio project]..['covid death']
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY
    location
ORDER BY
    totaldeathcount DESC;

-- Showing continent with highest death count per Population

SELECT
    continent,
    MAX(CAST(total_deaths AS INT)) as totaldeathcount
FROM [portfolio project]..['covid death']
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY
    continent
ORDER BY
    totaldeathcount DESC;

-- Global Numbers

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
case
when SUM(new_cases)<>0
then
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 
else null
End as DeathPercentage
from [portfolio project]..['covid death']
where continent is not null
group by date
order by 1,2;

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
case
when SUM(new_cases)<>0
then
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 
else null
End as DeathPercentage
from [portfolio project]..['covid death']
where continent is not null
order by 1,2;

-- Looking at Total Population vs Vaccinations

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    CASE
        WHEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location) <> 0
        THEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
        ELSE NULL
    END AS RollingPeopleVaccinated
from [portfolio project]..['covid death'] dea
join [portfolio project]..['covid vacc$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3;

-- USE CTE

with PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    CASE
        WHEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location) <> 0
        THEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
        ELSE NULL
    END AS RollingPeopleVaccinated
from [portfolio project]..['covid death'] dea
join [portfolio project]..['covid vacc$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
-- order by 2,3
)
select*,(RollingPeopleVaccinated/population)*100 
from PopvsVac

-- Temp Table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    CASE
        WHEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location) <> 0
        THEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
        ELSE NULL
    END AS RollingPeopleVaccinated
from [portfolio project]..['covid death'] dea
join [portfolio project]..['covid vacc$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
-- order by 2,3
select*,(RollingPeopleVaccinated/population)*100 as Vaccinatedpopperc
from #PercentPopulationVaccinated


-- Creating view to store data for future visualizations

create view PercentPopulationVaccinated as
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    CASE
        WHEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location) <> 0
        THEN SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location order by dea.location,dea.date)
        ELSE NULL
    END AS RollingPeopleVaccinated
from [portfolio project]..['covid death'] dea
join [portfolio project]..['covid vacc$'] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
-- order by 2,3

select * from PercentPopulationVaccinated
