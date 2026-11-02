
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE: EXPLORATORY DATA ANALYSIS
FILE: 06_company_analysis.sql
=========================================================

OBJECTIVE:
Analyze company-wise hiring patterns and salary trends.

BUSINESS QUESTIONS:
1. Which companies have the most job postings?
2. Which companies hire the most Data Engineers?
3. Which companies hire the most Data Analysts?
4. Which companies recruit across multiple job categories?
5. Which companies offer the most remote jobs?
6. Which companies have the highest average yearly salary?
7. How many job postings does each company have?
8. Which companies have at least 100 job postings?

=========================================================
*/


-- Q1. Top 10 companies by total job postings

SELECT
    c.company_id,
    c.name AS company_name,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
ORDER BY total_jobs DESC
LIMIT 10;


-- Q2. Top 10 companies hiring Data Engineers

SELECT
    c.name AS company_name,
    COUNT(*) AS data_engineer_jobs
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
WHERE j.job_title_short = 'Data Engineer'
GROUP BY c.name
ORDER BY data_engineer_jobs DESC
LIMIT 10;


-- Q3. Top 10 companies hiring Data Analysts

SELECT
    c.name AS company_name,
    COUNT(*) AS data_analyst_jobs
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
WHERE j.job_title_short = 'Data Analyst'
GROUP BY c.name
ORDER BY data_analyst_jobs DESC
LIMIT 10;


-- Q4. Companies hiring across multiple job categories

SELECT
    c.name AS company_name,
    COUNT(DISTINCT j.job_title_short) AS job_categories,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
HAVING COUNT(DISTINCT j.job_title_short) >= 5
ORDER BY job_categories DESC, total_jobs DESC
LIMIT 10;


-- Q5. Top 10 companies offering remote jobs

SELECT
    c.name AS company_name,
    COUNT(*) AS remote_jobs
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
WHERE j.job_work_from_home = TRUE
GROUP BY c.name
ORDER BY remote_jobs DESC
LIMIT 10;


-- Q6. Top 10 companies by average yearly salary
-- Minimum 20 salary records required

SELECT
    c.name AS company_name,
    COUNT(j.salary_year_avg) AS salary_records,
    ROUND(AVG(j.salary_year_avg), 2) AS average_salary
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY c.company_id, c.name
HAVING COUNT(j.salary_year_avg) >= 20
ORDER BY average_salary DESC
LIMIT 10;


-- Q7. Distribution of companies by job posting volume

SELECT
    CASE
        WHEN total_jobs = 1 THEN '1 job'
        WHEN total_jobs BETWEEN 2 AND 10 THEN '2-10 jobs'
        WHEN total_jobs BETWEEN 11 AND 50 THEN '11-50 jobs'
        WHEN total_jobs BETWEEN 51 AND 100 THEN '51-100 jobs'
        ELSE 'Above 100 jobs'
    END AS posting_category,
    COUNT(*) AS total_companies
FROM (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM data_jobs.main.job_postings_fact
    WHERE company_id IS NOT NULL
    GROUP BY company_id
) company_jobs
GROUP BY posting_category
ORDER BY total_companies DESC;


-- Q8. Companies with at least 100 job postings

SELECT
    c.name AS company_name,
    COUNT(*) AS total_jobs,
    COUNT(DISTINCT j.job_title_short) AS job_categories
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
GROUP BY c.company_id, c.name
HAVING COUNT(*) >= 100
ORDER BY total_jobs DESC
LIMIT 10;



/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. TOP COMPANIES:
   - beBee Careers has the highest number of job postings
     with 32,224 records.
   - Emprego and Dice follow with 6,669 and 6,568.
   - Capital One and Amazon also have significant
     job posting volumes.

2. DATA ENGINEER HIRING:
   - beBee Careers leads with 5,880 Data Engineer postings.
   - Listopro follows with 3,649 postings.
   - Dice has 2,889 postings.

3. DATA ANALYST HIRING:
   - beBee Careers leads with 10,008 Data Analyst postings.
   - Insight Global and Robert Half follow.

4. MULTI-CATEGORY HIRING:
   - Top 10 companies recruit across all 10 broad
     job categories available in the dataset.
   - These companies demonstrate diverse hiring patterns.

5. REMOTE JOBS:
   - Listopro has the highest number of remote postings
     with 4,445 records.
   - Dice and Upwork follow.

6. COMPANY-WISE SALARY:
   - Netflix has the highest average yearly salary
     (400,060.23) among companies with at least
     20 salary records.
   - Eleven Recruiting follows with 320,909.09.
   - Salary units and currencies require verification.

7. COMPANY POSTING DISTRIBUTION:
   - 105,380 companies have only one job posting.
   - 88,383 companies have 2-10 postings.
   - Only 1,777 companies have more than 100 postings.

8. HIGH-VOLUME COMPANIES:
   - The top 10 companies with at least 100 postings
     are the same as the leading companies in Q1.
   - All 10 recruit across 10 broad job categories.

9. OVERALL INSIGHT:
   - A small proportion of companies account for
     a large number of job postings.
   - Some companies have a strong presence in
     remote and data-related hiring.
   - Company-level salary comparisons should consider
     the number of available salary records.

=========================================================
END OF COMPANY ANALYSIS
=========================================================
*/
