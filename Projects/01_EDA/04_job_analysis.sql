
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE: EXPLORATORY DATA ANALYSIS
FILE: 04_job_analysis.sql
=========================================================

OBJECTIVE:
Analyze job postings to understand job market trends.

BUSINESS QUESTIONS:
1. How many jobs are available for each job title?
2. What are the most common job titles?
3. Which countries have the most job postings?
4. How many jobs are remote vs non-remote?
5. What are the most common employment types?
6. How many jobs are posted each year?
7. Which locations have the most job opportunities?
8. How many jobs mention that a degree is not required?
9. How many jobs offer health insurance?
10. What is the distribution of job postings by month?

=========================================================
*/


-- Q1. Count job postings by job title

SELECT
    job_title_short,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
GROUP BY job_title_short
ORDER BY total_jobs DESC;


-- Q2. Top 10 most common job titles

SELECT
    job_title,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
GROUP BY job_title
ORDER BY total_jobs DESC
LIMIT 10;


-- Q3. Top 10 countries by job postings

SELECT
    job_country,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
WHERE job_country IS NOT NULL
GROUP BY job_country
ORDER BY total_jobs DESC
LIMIT 10;


-- Q4. Remote vs non-remote job postings

SELECT
    CASE
        WHEN job_work_from_home = TRUE THEN 'Remote'
        WHEN job_work_from_home = FALSE THEN 'Non-Remote'
        ELSE 'Not Specified'
    END AS work_mode,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
GROUP BY work_mode
ORDER BY total_jobs DESC;


-- Q5. Most common employment types

SELECT
    job_schedule_type,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
WHERE job_schedule_type IS NOT NULL
GROUP BY job_schedule_type
ORDER BY total_jobs DESC
LIMIT 10;


-- Q6. Job postings by year

SELECT
    EXTRACT(YEAR FROM job_posted_date) AS posting_year,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
WHERE job_posted_date IS NOT NULL
GROUP BY posting_year
ORDER BY posting_year;


-- Q7. Top 10 job locations

SELECT
    job_location,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
WHERE job_location IS NOT NULL
GROUP BY job_location
ORDER BY total_jobs DESC
LIMIT 10;


-- Q8. Jobs where degree is not mentioned as required

SELECT
    job_no_degree_mention,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
GROUP BY job_no_degree_mention
ORDER BY total_jobs DESC;


-- Q9. Jobs offering health insurance

SELECT
    job_health_insurance,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
GROUP BY job_health_insurance
ORDER BY total_jobs DESC;


-- Q10. Job postings by month

SELECT
    EXTRACT(YEAR FROM job_posted_date) AS posting_year,
    EXTRACT(MONTH FROM job_posted_date) AS posting_month,
    COUNT(*) AS total_jobs
FROM data_jobs.main.job_postings_fact
WHERE job_posted_date IS NOT NULL
GROUP BY posting_year, posting_month
ORDER BY posting_year, posting_month;



/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. JOB TITLE ANALYSIS:
   - Data Analyst has the highest number of broad job
     category postings (408,640).
   - Data Engineer follows with 391,957 postings.
   - Data Scientist has 331,002 postings.
   - Among exact job titles, Data Engineer is the most
     frequently occurring title (90,892).

2. COUNTRY ANALYSIS:
   - United States has the highest number of postings
     (464,483).
   - India ranks second with 112,904 postings.
   - United Kingdom ranks third with 104,187 postings.

3. WORK MODE ANALYSIS:
   - 1,471,398 postings are classified as non-remote.
   - 144,532 postings are classified as remote.
   - Remote jobs account for approximately 8.94%
     of total postings.

4. EMPLOYMENT TYPE:
   - Full-time is the most common employment type
     with 1,416,889 postings.
   - Contractor and internship opportunities are
     considerably fewer.

5. YEARLY POSTING TREND:
   - 2023 has 787,356 postings.
   - 2024 has 483,959 postings.
   - 2025 has 344,615 postings.
   - 2025 data covers only January to June,
     so full-year comparisons are not appropriate.

6. LOCATION ANALYSIS:
   - Anywhere is the most frequent job location label.
   - Singapore and New York are among the leading
     specific locations.

7. DEGREE REQUIREMENT:
   - 541,310 postings do not explicitly mention
     a degree requirement.
   - This does not necessarily mean a degree
     is not required by the employer.

8. HEALTH INSURANCE:
   - 183,487 postings mention health insurance.
   - Most postings do not explicitly mention
     health insurance availability.

9. MONTHLY TREND:
   - January 2023 has the highest monthly posting
     count in the displayed results.
   - November 2024 has the lowest monthly count.

10. OVERALL INSIGHT:
    - Data-related roles represent a significant
      portion of the job market.
    - Full-time and non-remote jobs dominate.
    - The United States and India are major job
      posting markets in this dataset.

=========================================================
END OF JOB ANALYSIS
=========================================================
*/
