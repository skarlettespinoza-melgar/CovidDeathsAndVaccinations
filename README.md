# 🦠 COVID-19 Data Analysis with Python & SQL Server  

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)  
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)  
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)  
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)  

## 📌 Project Overview  
This project explores the global impact of COVID-19 by analyzing **infection rates, death percentages, and vaccination progress** using data from **CovidDeaths** and **CovidVaccinations** datasets.  

The workflow demonstrates the process of **extracting, loading, and analyzing real-world health data** by combining **Python for ETL** with **SQL Server Management Studio (SSMS)** for data querying and insights.  

---

## 🛠 Tools & Technologies  
- **Python (Pandas, SQLAlchemy)** – Data extraction and loading into SQL Server  
- **SQL Server Management Studio (SSMS)** – Data exploration, transformation, and query-based analysis  
- **SQL** – Joins, CTEs, window functions, aggregate functions, and temporary tables  

---

## 📂 Project Workflow  

### 🔹 Data Extraction & Loading  
- Imported `CovidDeaths.xlsx` and `CovidVaccinations.xlsx` using **Pandas**.  
- Established a **SQLAlchemy** connection to SQL Server and uploaded both datasets into the `PortfolioProject` database.  

### 🔹 Data Exploration & Cleaning  
- Converted columns into appropriate data types for accurate aggregation and calculation.  
- Structured queries to analyze infection, death, and vaccination metrics.  

### 🔹 Analysis with SQL Queries  
Example insights generated:  
- ⚰️ **Case Fatality Rate (CFR):** % likelihood of death given total cases  
- 🦠 **Infection Rate by Population:** % of population infected per country  
- 🌍 **Continental Comparison:** Death rate and case severity across continents  
- 📈 **Global Trends:** Daily and cumulative new cases vs. deaths worldwide  
- 💉 **Vaccination Progress:** Rolling vaccination counts and % of population vaccinated using window functions, CTEs, and temp tables  

---

## 📊 Example Queries  

```sql
-- % likelihood of death if infected
SELECT location, date, total_cases, total_deaths, 
       (total_deaths/total_cases)*100 AS death_pct
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL;

-- Countries with the highest infection rate relative to population
SELECT location, population,
       MAX(total_cases) AS max_infected_count,
       MAX((total_cases/population))*100 AS max_infected_population_pct
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY max_infected_population_pct DESC;

-- Rolling vaccination progress
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       SUM(cv.new_vaccinations) OVER (
           PARTITION BY cd.location 
           ORDER BY cd.date
       ) AS rolling_vaccinations
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccinations cv
  ON cd.location=cv.location AND cd.date=cv.date
WHERE cd.continent IS NOT NULL;
```
## 🚀 Outcomes  
- Built a **Python-to-SQL ETL pipeline** for COVID-19 data ingestion  
- Designed **analytical SQL queries** to assess infection, death, and vaccination trends  
- Created **CTEs, temp tables, and views** to enable reusable insights and future visualizations  
- Generated insights into **global and regional COVID-19 patterns**, including vaccination progress  

---

## 📎 Repository Contents  
- `CovidDeaths.xlsx` – Raw COVID-19 deaths dataset
- `CovidProjectAnalysisQueries.sql` – SQL queries for exploration and analysis    
- `CovidVaccinations.xlsx` – Raw COVID-19 vaccination dataset
- `README.md` – Project documentation (this file)  
- `SQL Data Exploration Extract and Upload.ipynb` – Python ETL script for loading data into SQL Server    

---

## 📈 Key Skills Demonstrated  
- **ETL & Data Engineering** (Excel → Python → SQL Server pipeline)  
- **SQL Analytics** (joins, aggregates, window functions, temp tables, views)  
- **Data Visualization Prep** (cleaning and structuring data for dashboards)  
- **Real-World Data Analysis** (public health metrics and global trends)  

---

✨ *This project highlights the ability to combine Python and SQL to transform raw health data into structured, query-ready datasets and derive meaningful insights into global pandemic trends.*  
