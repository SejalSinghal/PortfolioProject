select * from PortfolioProject..CovidDeaths

select* from PortfolioProject..CovidVaccination

--Select data that we are going to use

select location,date,total_cases,new_cases,total_deaths,population from  PortfolioProject..CovidDeaths

--Total Case vs Total Death
--show liklihood of dying if you come in contact with covid in your country
select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100  as deathpercentage
from  PortfolioProject..CovidDeaths
where location = 'India' order by 1,2
--Total Case vs Population
select location,date,total_cases,new_cases,population,(total_cases/population)*100  as CasePercentage
from  PortfolioProject..CovidDeaths
where location = 'India' order by 1,2

--looking at counties with higheest infection compared to population
select location,max(total_cases),population,max((total_cases/population))*100  as CasePercentage
from  PortfolioProject..CovidDeaths
group by location, population order by CasePercentage desc

---looking at counties with higheest infection compared to population
select location,max(total_deaths),population,max((total_deaths/population))*100  as DeathpopPercentage
from  PortfolioProject..CovidDeaths
group by location, population order by DeathpopPercentage desc


select location,max(cast(total_deaths as int))  as Deathcases
from  PortfolioProject..CovidDeaths
group by location order by Deathcases desc

--We have to see data country wise in above we can see we are world as country asia as country so we removed continent having nul value

select location,max(cast(total_deaths as int))  as Deathcases
from  PortfolioProject..CovidDeaths where continent is not null
group by location order by Deathcases desc

--Breaking down in continent
select continent,location,max(cast(total_deaths as int))  as Deathcases
from  PortfolioProject..CovidDeaths where continent is not null
group by continent,location order by Deathcases desc

Select continent,max(cast(total_deaths as int)) as Deathcases--,location
from  PortfolioProject..CovidDeaths where continent is not null
group by continent order by Deathcases desc

select location,max(cast(total_deaths as int))  as Deathcases
from  PortfolioProject..CovidDeaths where continent is  null
group by location order by Deathcases desc

select continent,max(cast(total_deaths as int))  as Deathcases
from  PortfolioProject..CovidDeaths where continent is not null
group by continent order by Deathcases desc

--global Numbers

select date,max(cast(total_deaths as int))  as Deathcases
from  PortfolioProject..CovidDeaths where continent is not null
group by date order by Deathcases desc

select date,SUM(new_cases)--,total_deaths,(total_deaths/total_cases)*100  as DeathpopPercentage
from  PortfolioProject..CovidDeaths
where continent is not null
group by date order by 1,2

select date,SUM(new_cases),SUM(cast(new_deaths as int))--,total_deaths,(total_deaths/total_cases)*100  as DeathpopPercentage
from  PortfolioProject..CovidDeaths
where continent is not null
group by date order by 1,2

select date,SUM(new_cases),SUM(cast(new_deaths as int))--,total_deaths,(total_deaths/total_cases)*100  as DeathpopPercentage
from  PortfolioProject..CovidDeaths
where continent is not null
group by date order by 1,2

select date,SUM(new_cases),SUM(cast(new_deaths as int))--,total_deaths,(total_deaths/total_cases)*100  as DeathpopPercentage
from  PortfolioProject..CovidDeaths
where continent is not null
group by date order by 1,2

select date,SUM(new_cases)as total_new_case,SUM(cast(new_deaths as int)) as total_new_deaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))*100  as DeathsPercentage
from  PortfolioProject..CovidDeaths
where continent is not null
group by date order by 1,2

select SUM(new_cases)as total_new_case,SUM(cast(new_deaths as int)) as total_new_deaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))*100  as DeathsPercentage
from  PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

select * from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
where dea.continent is not null
and dea.date=vac.date
order by 2,3

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
where dea.continent is not null
and dea.date=vac.date
order by 2,3

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
where dea.continent is not null
and dea.date=vac.date
order by 2,3

--use CTE

with PopvsVac (continent,loactaion,date ,population,new_vaccination,RollingPeopleVac)
as
(select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location) as RollingPeopleVac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
where dea.continent is not null
and dea.date=vac.date
--order by 2,3
)
select*,(RollingPeopleVac/Population)*100 as PercentagePeopleVac
from PopvsVac

--temp Table

drop table if exists #PopulationVaccinattedPercentage
create table #PopulationVaccinattedPercentage
(
continent varchar(200),
Location varchar(200),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVac numeric
)

insert into #PopulationVaccinattedPercentage
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
--where dea.continent is not null
and dea.date=vac.date
--order by 2,3

select *,(RollingPeopleVac/Population)*100 as PercentagePeopleVac
from #PopulationVaccinattedPercentage


create view PopulationVacinn as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVac
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null







