
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE: EXPLORATORY DATA ANALYSIS
FILE: 05_salary_analysis.sql
=========================================================

OBJECTIVE:
Analyze salary trends across different job roles,
countries and employment categories.

IMPORTANT:
Salary columns contain many NULL values.
Only available salary records will be considered
for salary calculations.

BUSINESS QUESTIONS:
1. What is the overall average yearly salary?
2. What is the minimum and maximum yearly salary?
3. What is the median yearly salary?
4. Which job titles have the highest average salary?
5. What is the average salary by job category?
6. Which countries offer the highest average salaries?
7. What is the average hourly salary?
8. How do Data Engineer salaries compare?
9. What is the salary distribution by range?
10. Which job categories have the most salary records?

=========================================================
*/


-- Q1. Overall yearly salary statistics

SELECT
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 2) AS average_salary,
    ROUND(MIN(salary_year_avg), 2) AS minimum_salary,
    ROUND(MAX(salary_year_avg), 2) AS maximum_salary
FROM data_jobs.main.job_postings_fact;


-- Q2. Median yearly salary

SELECT
    ROUND(MEDIAN(salary_year_avg), 2) AS median_yearly_salary
FROM data_jobs.main.job_postings_fact
WHERE salary_year_avg IS NOT NULL;


-- Q3. Top 10 highest-paying exact job titles
-- Minimum 100 salary records required

SELECT
    job_title,
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM data_jobs.main.job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title
HAVING COUNT(salary_year_avg) >= 100
ORDER BY average_salary DESC
LIMIT 10;


-- Q4. Average yearly salary by job category

SELECT
    job_title_short,
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM data_jobs.main.job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
ORDER BY average_salary DESC;


-- Q5. Top 10 countries by average yearly salary
-- Minimum 100 salary records required

SELECT
    job_country,
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM data_jobs.main.job_postings_fact
WHERE salary_year_avg IS NOT NULL
  AND job_country IS NOT NULL
GROUP BY job_country
HAVING COUNT(salary_year_avg) >= 100
ORDER BY average_salary DESC
LIMIT 10;


-- Q6. Overall hourly salary statistics

SELECT
    COUNT(salary_hour_avg) AS salary_records,
    ROUND(AVG(salary_hour_avg), 2) AS average_hourly_salary,
    ROUND(MIN(salary_hour_avg), 2) AS minimum_hourly_salary,
    ROUND(MAX(salary_hour_avg), 2) AS maximum_hourly_salary
FROM data_jobs.main.job_postings_fact;


-- Q7. Data Engineer yearly salary analysis

SELECT
    COUNT(salary_year_avg) AS salary_records,
    ROUND(AVG(salary_year_avg), 2) AS average_salary,
    ROUND(MEDIAN(salary_year_avg), 2) AS median_salary,
    ROUND(MIN(salary_year_avg), 2) AS minimum_salary,
    ROUND(MAX(salary_year_avg), 2) AS maximum_salary
FROM data_jobs.main.job_postings_fact
WHERE job_title_short = 'Data Engineer'
  AND salary_year_avg IS NOT NULL;


-- Q8. Salary distribution by salary range

SELECT
    CASE
        WHEN salary_year_avg < 50000 THEN 'Below 50K'
        WHEN salary_year_avg < 100000 THEN '50K - 100K'
        WHEN salary_year_avg < 150000 THEN '100K - 150K'
        WHEN salary_year_avg < 200000 THEN '150K - 200K'
        ELSE 'Above 200K'
    END AS salary_range,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY salary_range
ORDER BY
    CASE salary_range
        WHEN 'Below 50K' THEN 1
        WHEN '50K - 100K' THEN 2
        WHEN '100K - 150K' THEN 3
        WHEN '150K - 200K' THEN 4
        WHEN 'Above 200K' THEN 5
    END;


-- Q9. Salary records by job category

SELECT
    job_title_short,
    COUNT(*) AS total_salary_records
FROM data_jobs.main.job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
ORDER BY total_salary_records DESC;


-- Q10. Compare yearly and hourly salary availability

SELECT
    COUNT(*) FILTER (
        WHERE salary_year_avg IS NOT NULL
    ) AS yearly_salary_records,

    COUNT(*) FILTER (
        WHERE salary_hour_avg IS NOT NULL
    ) AS hourly_salary_records,

    COUNT(*) FILTER (
        WHERE salary_year_avg IS NOT NULL
          AND salary_hour_avg IS NOT NULL
    ) AS records_with_both

FROM data_jobs.main.job_postings_fact;



/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. OVERALL YEARLY SALARY:
   - Total yearly salary records: 51,026.
   - Average yearly salary: 123,788.58.
   - Median yearly salary: 116,950.
   - Minimum yearly salary: 15,000.
   - Maximum yearly salary: 960,000.
   - Average is higher than median, suggesting
     a right-skewed salary distribution.

2. HIGHEST-PAYING JOB TITLES:
   - Principal Data Scientist has the highest average
     salary (185,203.11) among the filtered exact titles.
   - Staff Data Engineer follows with 179,922.73.
   - Senior and leadership roles dominate the top results.

3. SALARY BY JOB CATEGORY:
   - Senior Data Scientist has the highest average
     salary (156,390.76).
   - Senior Data Engineer follows with 149,222.25.
   - Data Engineer average salary is 134,867.11.
   - Data Analyst average salary is 93,223.18.

4. COUNTRY-WISE SALARY:
   - Canada has the highest average salary
     (135,600.40) among the selected countries.
   - United States has the largest salary sample
     with 39,448 records.
   - Country comparisons require currency and
     purchasing-power considerations.

5. HOURLY SALARY:
   - Total hourly salary records: 26,059.
   - Average hourly salary: 47.39.
   - Minimum hourly salary: 8.
   - Maximum hourly salary: 391.

6. DATA ENGINEER SALARY:
   - Salary records: 10,551.
   - Average salary: 134,867.11.
   - Median salary: 130,000.
   - Minimum salary: 15,000.
   - Maximum salary: 640,000.

7. SALARY DISTRIBUTION:
   - The 100K-150K range contains the highest
     number of salary records (20,323).
   - The 50K-100K range contains 16,044 records.
   - Only 3,594 records have salaries above 200K.

8. SALARY DATA AVAILABILITY:
   - 51,026 yearly salary records.
   - 26,059 hourly salary records.
   - No records contain both yearly and hourly salary.
   - The two salary columns represent separate
     groups of records in this dataset.

9. OVERALL INSIGHT:
   - Senior and leadership data roles have higher
     average salaries than many non-senior roles.
   - Data Engineer and Data Scientist salaries
     are relatively close.
   - Salary analysis is limited by missing salary
     information and requires unit verification.

=========================================================
END OF SALARY ANALYSIS
=========================================================
*/
