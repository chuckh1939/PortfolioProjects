
select *
from PortfolioProject..covidVacinations
order by location, date

--select Data that we are going to be using

Select Location, date, new_cases, total_cases, new_deaths, total_deaths, population 
from PortfolioProject..covidDeaths
order by 1,2

--looking at death percentage based on cases

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..covidDeaths
--where location like 'United States'
order by 1,2

--looking at population percent infected

select location, date, total_cases, population, (total_cases/population)*100 as PercentPolulationInfected
from PortfolioProject..covidDeaths
--where location like 'United States'
order by 1,2

--looking at countries with highest percent of population infected

select location, MAX(total_cases) as totalCases, population, (MAX(total_cases)/population)*100 as PercentPopulationInfected
from PortfolioProject..covidDeaths
--where location like 'United States'
Group by location, population
order by PercentPopulationInfected desc

--showing the countries with highest death count per pop

select location, MAX(cast(total_deaths as int)) as TotalDeathCount, population, (MAX(cast(total_deaths as int))/population)*100 as PercentPopDead
from PortfolioProject..covidDeaths
--where location like 'United States'
where continent is not null
Group by location, population
order by PercentPopDead desc

--lets break things down by continent
--showing continents with highest death count

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--where location like 'United States'
where continent is not null
Group by continent
order by TotalDeathCount desc

--global cases vs deaths

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as PercentageDeaths
from PortfolioProject..covidDeaths
--where location like 'United States'
order by 1,2

--looking at total population vs vaccinations

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 1,2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

--temp table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 1,2,3
select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--creating view to store data for later visualizations

Create View VaccinatedPop as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 1,2,3










