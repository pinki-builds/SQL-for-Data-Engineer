
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE: EXPLORATORY DATA ANALYSIS
FILE: 08_advanced_analysis.sql
=========================================================

OBJECTIVE:
Perform advanced analysis using CTEs, subqueries
and SQL window functions.

BUSINESS QUESTIONS:
1. What are the top 3 skills for each job category?
2. What are the top 3 highest-paying job titles
   within each job category?
3. Rank companies by total job postings.
4. Find companies with above-average job postings.
5. Calculate running total of monthly job postings.
6. Compare monthly job postings with previous month.
7. Find the highest-paying job in each job category.
8. Find the top 3 companies hiring Data Engineers.
9. Calculate each skill's percentage of total demand.
10. Rank job categories by average yearly salary.

=========================================================
*/


-- Q1. Top 3 skills for each job category
-- Window function: ROW_NUMBER()

WITH skill_demand AS (
    SELECT
        j.job_title_short,
        s.skills,
        COUNT(*) AS demand_count
    FROM data_jobs.main.job_postings_fact j
    INNER JOIN data_jobs.main.skills_job_dim sj
        ON j.job_id = sj.job_id
    INNER JOIN data_jobs.main.skills_dim s
        ON sj.skill_id = s.skill_id
    GROUP BY j.job_title_short, s.skills
),

ranked_skills AS (
    SELECT
        job_title_short,
        skills,
        demand_count,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY demand_count DESC
        ) AS skill_rank
    FROM skill_demand
)

SELECT *
FROM ranked_skills
WHERE skill_rank <= 3
ORDER BY job_title_short, skill_rank;


-- Q2. Top 3 highest-paying exact job titles
-- within each broad job category

WITH title_salary AS (
    SELECT
        job_title_short,
        job_title,
        COUNT(salary_year_avg) AS salary_records,
        AVG(salary_year_avg) AS average_salary
    FROM data_jobs.main.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    GROUP BY job_title_short, job_title
    HAVING COUNT(salary_year_avg) >= 20
),

ranked_titles AS (
    SELECT
        job_title_short,
        job_title,
        salary_records,
        ROUND(average_salary, 2) AS average_salary,
        DENSE_RANK() OVER (
            PARTITION BY job_title_short
            ORDER BY average_salary DESC
        ) AS salary_rank
    FROM title_salary
)

SELECT *
FROM ranked_titles
WHERE salary_rank <= 3
ORDER BY job_title_short, salary_rank;


-- Q3. Rank companies by total job postings

WITH company_jobs AS (
    SELECT
        c.company_id,
        c.name AS company_name,
        COUNT(*) AS total_jobs
    FROM data_jobs.main.job_postings_fact j
    INNER JOIN data_jobs.main.company_dim c
        ON j.company_id = c.company_id
    GROUP BY c.company_id, c.name
)

SELECT
    company_name,
    total_jobs,
    RANK() OVER (
        ORDER BY total_jobs DESC
    ) AS company_rank
FROM company_jobs
ORDER BY company_rank
LIMIT 20;


-- Q4. Companies with above-average job postings

WITH company_jobs AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM data_jobs.main.job_postings_fact
    WHERE company_id IS NOT NULL
    GROUP BY company_id
)

SELECT
    company_id,
    total_jobs
FROM company_jobs
WHERE total_jobs > (
    SELECT AVG(total_jobs)
    FROM company_jobs
)
ORDER BY total_jobs DESC
LIMIT 20;


-- Q5. Running total of monthly job postings

WITH monthly_jobs AS (
    SELECT
        DATE_TRUNC('month', job_posted_date) AS posting_month,
        COUNT(*) AS total_jobs
    FROM data_jobs.main.job_postings_fact
    WHERE job_posted_date IS NOT NULL
    GROUP BY posting_month
)

SELECT
    posting_month,
    total_jobs,
    SUM(total_jobs) OVER (
        ORDER BY posting_month
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total
FROM monthly_jobs
ORDER BY posting_month;


-- Q6. Compare monthly job postings with previous month

WITH monthly_jobs AS (
    SELECT
        DATE_TRUNC('month', job_posted_date) AS posting_month,
        COUNT(*) AS total_jobs
    FROM data_jobs.main.job_postings_fact
    WHERE job_posted_date IS NOT NULL
    GROUP BY posting_month
)

SELECT
    posting_month,
    total_jobs,
    LAG(total_jobs) OVER (
        ORDER BY posting_month
    ) AS previous_month_jobs,

    total_jobs - LAG(total_jobs) OVER (
        ORDER BY posting_month
    ) AS month_over_month_change

FROM monthly_jobs
ORDER BY posting_month;


-- Q7. Highest-paying exact job title in each category

WITH title_salary AS (
    SELECT
        job_title_short,
        job_title,
        COUNT(salary_year_avg) AS salary_records,
        AVG(salary_year_avg) AS average_salary
    FROM data_jobs.main.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    GROUP BY job_title_short, job_title
    HAVING COUNT(salary_year_avg) >= 20
),

ranked_titles AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY average_salary DESC
        ) AS salary_rank
    FROM title_salary
)

SELECT
    job_title_short,
    job_title,
    salary_records,
    ROUND(average_salary, 2) AS average_salary
FROM ranked_titles
WHERE salary_rank = 1
ORDER BY average_salary DESC;


-- Q8. Top 3 companies hiring Data Engineers

WITH company_hiring AS (
    SELECT
        c.name AS company_name,
        COUNT(*) AS data_engineer_jobs
    FROM data_jobs.main.job_postings_fact j
    INNER JOIN data_jobs.main.company_dim c
        ON j.company_id = c.company_id
    WHERE j.job_title_short = 'Data Engineer'
    GROUP BY c.company_id, c.name
),

ranked_companies AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY data_engineer_jobs DESC
        ) AS hiring_rank
    FROM company_hiring
)

SELECT *
FROM ranked_companies
WHERE hiring_rank <= 3
ORDER BY hiring_rank;


-- Q9. Each skill's percentage of total demand

WITH skill_demand AS (
    SELECT
        s.skills,
        COUNT(*) AS demand_count
    FROM data_jobs.main.skills_job_dim sj
    INNER JOIN data_jobs.main.skills_dim s
        ON sj.skill_id = s.skill_id
    GROUP BY s.skills
)

SELECT
    skills,
    demand_count,
    ROUND(
        100.0 * demand_count /
        SUM(demand_count) OVER (),
        2
    ) AS demand_percentage
FROM skill_demand
ORDER BY demand_count DESC
LIMIT 20;


-- Q10. Rank job categories by average yearly salary

WITH category_salary AS (
    SELECT
        job_title_short,
        COUNT(salary_year_avg) AS salary_records,
        AVG(salary_year_avg) AS average_salary
    FROM data_jobs.main.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    GROUP BY job_title_short
)

SELECT
    job_title_short,
    salary_records,
    ROUND(average_salary, 2) AS average_salary,
    DENSE_RANK() OVER (
        ORDER BY average_salary DESC
    ) AS salary_rank
FROM category_salary
ORDER BY salary_rank;



/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. TOP SKILLS BY JOB CATEGORY:
   - SQL leads Data Engineer and Data Analyst categories.
   - Python leads Data Scientist and Machine Learning
     Engineer categories.
   - AWS is among the top Data Engineer skills.

2. HIGHEST-PAYING JOB TITLES:
   - Head of Data Engineering has the highest average
     salary in the Data Engineer category.
   - Director of Data Science leads the Data Scientist
     category.
   - Senior and leadership roles generally appear
     among the highest-paying titles.

3. COMPANY RANKING:
   - beBee Careers ranks first with 32,224 postings.
   - Emprego and Dice rank second and third.

4. ABOVE-AVERAGE COMPANIES:
   - The top 20 companies have the highest posting
     volumes in the dataset.
   - Company ranking is based on total job postings.

5. RUNNING TOTAL:
   - Cumulative job postings reach 1,615,930
     by June 2025.
   - Running totals increase chronologically.

6. MONTHLY CHANGE:
   - Job postings fluctuate month to month.
   - January 2025 shows an increase of 33,533
     compared with December 2024.
   - April 2025 shows a decrease of 28,625
     compared with March 2025.

7. HIGHEST-PAYING TITLES:
   - Head of Data Engineering leads the Data Engineer
     category with average salary of 327,173.91.
   - Salary rankings use a minimum of 20 records.

8. DATA ENGINEER HIRING:
   - beBee Careers leads with 5,880 postings.
   - Listopro follows with 3,649.
   - Dice ranks third with 2,889.

9. SKILL PERCENTAGE:
   - Python and SQL each contribute approximately
     10.55% of total job-skill associations.
   - Together they contribute approximately 21.10%.

10. SALARY BY JOB CATEGORY:
    - Senior Data Scientist has the highest average
      salary among the analyzed categories.
    - Senior Data Engineer ranks second.
    - Data Engineer and Data Scientist averages
      are relatively close.

11. DATA QUALITY OBSERVATION:
    - A suspicious malformed Business Analyst job title
      was identified in the salary ranking.
    - This should be investigated during staging.

12. OVERALL INSIGHT:
    - SQL, Python and cloud technologies are highly
      demanded across data-related job categories.
    - Window functions and CTEs helped perform
      ranking, trend and cumulative analysis.

NOTE:
Salary currency and units require verification.
Demand counts represent job-skill associations.

=========================================================
END OF ADVANCED ANALYSIS
=========================================================
*/
