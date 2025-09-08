select * from PortfolioProject..CovidDeaths

select * from PortfolioProject..CovidVaccinations

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null

-- Analyze Total Cases vs Total Deaths --
-- This query shows the percentage of death if you contract covid
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_pct
from PortfolioProject..CovidDeaths
where continent is not null

-- Analyze Total Cases vs Population -- 
-- This query shows the percentage of total cases relative to the population
select location, date, total_cases, population, (total_cases/population)*100 as infected_population_pct
from PortfolioProject..CovidDeaths
where continent is not null

-- Analyze Countires with the Highest Infection Rate compared to Population --
select location, population, MAX(total_cases) as max_infected_count, MAX((total_cases/population))*100 as max_infected_population_pct
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by max_infected_population_pct desc

select location, MAX((total_deaths/population))*100 as max_death_population_pct,population, MAX(total_deaths) as max_deaths
from PortfolioProject..CovidDeaths
where continent is null 
group by location, population
order by max_death_population_pct desc

----- BREAKING DOWN BY CONTINENT -----

-- Analyze Continents with the Highest Death Rate compared to Population --
select continent, MAX((total_deaths/population))*100 as max_death_population_pct, MAX(total_deaths) as max_deaths
from PortfolioProject..CovidDeaths
where continent is not null 
group by continent
order by max_death_population_pct desc

----- GLOBAL ANALYSIS -----
-- Analyze Sum of (New) Deaths Relative to the Sum of (New) Cases Across the World GROUPED BY DATE --
select date, SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, (SUM(new_deaths)/SUM(new_cases)*100) as new_deaths_pct
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by date

-- Analyze Sum of (New) Deaths Relative to the Sum of (New) Cases Across the World --
select SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, (SUM(new_deaths)/SUM(new_cases)*100) as new_deaths_pct
from PortfolioProject..CovidDeaths
where continent is not null

----- ANALYSIS ON JOINED TABLES -----
select * 
from PortfolioProject..CovidDeaths cd 
	JOIN PortfolioProject..CovidVaccinations cv 
	ON cd.location=cv.location AND cd.date=cv.date

-- Analyze Total Population vs Total Vaccinations --
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER(partition by cd.location Order by cd.date) as rolling_vaccinations
from PortfolioProject..CovidDeaths cd 
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location=cv.location AND cd.date=cv.date
where cd.continent is not null
order by cd.location, cd.date

----- USING CTE -----
with pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER(partition by cd.location Order by cd.date) as rolling_vaccinations
from PortfolioProject..CovidDeaths cd 
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location=cv.location AND cd.date=cv.date
where cd.continent is not null
)
select *, (rolling_vaccinations/population)*100 as pop_vs_vac_pct
from pop_vs_vac

----- USING TEMP TABLE -----
DROP Table if exists #pct_pop_vaccinated
Create Table #pct_pop_vaccinated
(
continent nvarchar(255),
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric,
rolling_vaccinations numeric
)
Insert into #pct_pop_vaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER(partition by cd.location Order by cd.date) as rolling_vaccinations
from PortfolioProject..CovidDeaths cd 
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location=cv.location AND cd.date=cv.date
where cd.continent is not null
order by cd.location, cd.date

select *, (rolling_vaccinations/population)*100
from #pct_pop_vaccinated

----- CREATING VIEW FOR FUTURE VISUALIZATIONS -----
use PortfolioProject;
GO
create view pct_pop_vaccinated as 
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER(partition by cd.location Order by cd.date) as rolling_vaccinations
from PortfolioProject..CovidDeaths cd 
	JOIN PortfolioProject..CovidVaccinations cv
	ON cd.location=cv.location AND cd.date=cv.date
where cd.continent is not null
