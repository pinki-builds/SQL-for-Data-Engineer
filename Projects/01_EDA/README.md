# 📊 Job Market Data Analysis – SQL EDA

## 1. Project Overview

This project performs Exploratory Data Analysis (EDA) on a large-scale job postings dataset using SQL.

The objective is to analyze job market trends, salary distributions, company hiring patterns, and in-demand technical skills across different data-related job roles.

The analysis uses DuckDB with MotherDuck as the cloud database.

## 2. Objectives

- Explore job market trends across different roles and countries.
- Analyze salary distributions across job categories.
- Identify companies with the highest hiring activity.
- Discover the most in-demand technical skills.
- Compare skills required for Data Analyst, Data Engineer, and Data Scientist roles.
- Perform data quality checks.
- Apply advanced SQL techniques to extract meaningful insights.

## 3. Tech Stack

| Technology | Purpose |
|---|---|
| SQL | Data analysis |
| DuckDB | SQL query execution |
| MotherDuck | Cloud database |
| Python | SQL execution automation |
| Git & GitHub | Version control |

## 4. Dataset Overview

The project uses four tables from the `data_jobs.main` database.

| Table | Records | Description |
|---|---:|---|
| company_dim | 215,940 | Company information |
| job_postings_fact | 1,615,930 | Job posting details |
| skills_dim | 262 | Skills information |
| skills_job_dim | 7,193,426 | Job-skill mapping |

**Total Job Postings:** 1,615,930

## 5. Project Structure

```text
01_EDA/
│
├── README.md
├── 01_database_overview.sql
├── 02_table_structure.sql
├── 03_data_quality.sql
├── 04_job_analysis.sql
├── 05_salary_analysis.sql
├── 06_company_analysis.sql
├── 07_skills_analysis.sql
└── 08_advanced_analysis.sql
```

## 6. Analysis Modules

### 01. Database Overview
- Database and table exploration.
- Record counts.
- Sample job postings.
- Data Engineer job count.

### 02. Table Structure
- Column names and data types.
- Primary key identification.
- Fact, dimension, and bridge table identification.
- Relationship exploration.

### 03. Data Quality
- NULL value analysis.
- Duplicate record detection.
- Orphan record checks.
- Salary data availability.
- Referential integrity validation.

### 04. Job Analysis
- Job category distribution.
- Exact job title analysis.
- Country-wise job distribution.
- Remote vs non-remote jobs.
- Employment schedule types.
- Monthly and yearly posting trends.
- Degree and health insurance indicators.

### 05. Salary Analysis
- Average and median salary.
- Salary distribution.
- Job category salary comparison.
- Country-wise salary analysis.
- Data Engineer salary analysis.
- Yearly and hourly salary availability.

### 06. Company Analysis
- Top hiring companies.
- Data Engineer and Data Analyst hiring.
- Remote hiring patterns.
- Company-wise salary comparison.
- Company posting volume distribution.

### 07. Skills Analysis
- Most in-demand skills.
- Role-specific skill requirements.
- Programming skills.
- Cloud technologies.
- Remote Data Engineer skills.
- Common skills across job categories.

### 08. Advanced Analysis
- Top skills using ROW_NUMBER().
- Salary rankings using DENSE_RANK().
- Company rankings using RANK().
- Above-average company analysis.
- Running monthly job posting totals.
- Month-over-month changes using LAG().
- Skill demand percentages.

## 7. Key Findings

### Job Market Insights

| Job Category | Job Postings |
|---|---:|
| Data Analyst | 408,640 |
| Data Engineer | 391,957 |
| Data Scientist | 331,002 |
| Business Analyst | 101,167 |
| Software Engineer | 92,271 |

- The United States had the highest number of job postings.
- India ranked second with 112,904 postings.
- Approximately 8.94% of postings were marked as remote.
- Full-time employment was the most common schedule type.

### Salary Insights

| Metric | Value |
|---|---:|
| Average Yearly Salary | 123,788.58 |
| Median Yearly Salary | 116,950 |
| Data Engineer Average Salary | 134,867.11 |
| Senior Data Scientist Average Salary | 156,390.76 |

*Note: Salary currency and units have not been independently verified.*

### Most In-Demand Skills

| Skill | Job-Skill Associations |
|---|---:|
| Python | 759,081 |
| SQL | 758,824 |
| AWS | 302,245 |
| Azure | 280,137 |
| Excel | 245,645 |
| Tableau | 241,876 |
| R | 237,602 |
| Spark | 222,464 |
| Power BI | 205,785 |
| Java | 164,723 |

*Note: These counts represent job-skill associations, not necessarily distinct job postings.*

## 8. SQL Concepts Demonstrated

- SELECT, WHERE, ORDER BY
- GROUP BY and HAVING
- Aggregate Functions
- INNER JOIN and LEFT JOIN
- CASE WHEN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER(), RANK(), DENSE_RANK()
- LAG()
- Running Totals
- Date and String Functions
- NULL and Duplicate Handling

## 9. How to Execute

Run the SQL files from the main project directory using the Python SQL runner.

Example:

```powershell
python main.py Projects/01_EDA/01_database_overview.sql
```

Execute the remaining SQL files in numerical order.

**Prerequisite:** Python dependencies must be installed, MotherDuck must be configured, and access to the `data_jobs.main` source database is required.

## 10. Conclusion

This project demonstrates practical SQL skills through exploratory analysis of more than 1.6 million job postings.

It provides insights into job market demand, salary patterns, company hiring activity, and technical skill requirements.

The project establishes a foundation for further Data Engineering work, including Data Warehouse development and ETL pipeline implementation.

