## COVID Dataset Exploration

#standardSQL
SELECT 
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
ORDER BY 3,4


## Looking at Total Cases vs Total Deaths
## Shows the likelihood of dying if you contract COVID in the US
#standardSQL
SELECT 
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS DeathPercentage
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
WHERE location = 'United States'
ORDER BY 1,2

## Looking at Total Cases vs. Population
## Shows what percentage of population got COVID
#standardSQL
SELECT 
  location,
  date,
  total_cases,
  population,
  (population/total_cases)*100 AS PercentPopulationInfected
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
# WHERE location = 'United States'
ORDER BY 1,2

## Looking at countries with Highest Infection Rate compared to Population
#standardSQL
SELECT 
  location,
  population,
  MAX(total_cases) AS HighestInfectionCount,
  MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
# WHERE location = 'United States'
GROUP BY location, population
ORDER BY 4 DESC

## Showing Countries with Highest Death Count per Population
#standardSQL
SELECT 
  location,
  MAX(total_deaths) AS TotalDeathCount
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC


## Breaking Data Down By Continent

##Total death count per continent
#standardSQL
SELECT 
  continent,
  MAX(CAST(total_deaths AS int64)) AS TotalDeathCount
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC

## Showing the continents with the highest death count per population
#standardSQL
SELECT 
  continent,
  MAX(CAST(total_deaths AS int64)) AS TotalDeathCount
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC


## GLOBAL NUMBERS

## Daily death percentage from January 1st 2020 to November 17th 2022
#standardSQL
SELECT 
  date,
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS int64)) AS total_deaths,
  SUM(CAST(new_deaths AS int64))/SUM(new_cases)*100 AS DeathPercentage
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

## Global Death Percentage
#standardSQL
SELECT 
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS int64)) AS total_deaths,
  SUM(CAST(new_deaths AS int64))/SUM(new_cases)*100 AS DeathPercentage
FROM `nms-first-sandbox-project.covid_data.covid_deaths` 
WHERE continent IS NOT NULL
ORDER BY 1,2


## Joining the COVID death and vaccination tables
## Looking at Total Population vs. Vaccinations

## CTE Creation

#standardSQL
WITH PopvsVac AS
(
SELECT 
  cd.continent,
  cd.location,
  cd.date,
  cd.population,
  cv.new_vaccinations,
  SUM(CAST(cv.new_vaccinations AS int64)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM `nms-first-sandbox-project.covid_data.covid_deaths` cd
JOIN `nms-first-sandbox-project.covid_data.covid_vaccinations` cv
  ON cd.date = cv.date
  AND cd.location = cv.location
WHERE cd.continent IS NOT NULL
ORDER BY 2,3 
) 
SELECT 
  *,
  (RollingPeopleVaccinated/Population)*100 AS vaccinated_population_percent
FROM PopvsVac
