
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE: EXPLORATORY DATA ANALYSIS
FILE: 07_skills_analysis.sql
=========================================================

OBJECTIVE:
Analyze technical skill demand across different job roles.

TABLES:
1. job_postings_fact
2. skills_job_dim
3. skills_dim

BUSINESS QUESTIONS:
1. What are the most in-demand skills overall?
2. What are the top Data Engineer skills?
3. What are the top Data Analyst skills?
4. What are the top Data Scientist skills?
5. Which skill categories are most common?
6. What are the most demanded programming languages?
7. Which cloud platforms are most in demand?
8. What are the top skills for remote Data Engineer jobs?
9. What are the top skills for Senior Data Engineer jobs?
10. Which skills are common across Data Engineer,
    Data Analyst and Data Scientist roles?

=========================================================
*/


-- Q1. Top 10 most in-demand skills overall

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.skills_job_dim sj
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q2. Top 10 skills for Data Engineers

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Engineer'
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q3. Top 10 skills for Data Analysts

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q4. Top 10 skills for Data Scientists

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Scientist'
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q5. Most common skill categories

SELECT
    s.type AS skill_category,
    COUNT(*) AS demand_count,
    COUNT(DISTINCT s.skill_id) AS unique_skills
FROM data_jobs.main.skills_job_dim sj
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
GROUP BY s.type
ORDER BY demand_count DESC;


-- Q6. Most demanded programming languages

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.skills_job_dim sj
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE LOWER(s.type) LIKE '%programming%'
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q7. Most demanded cloud platforms

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.skills_job_dim sj
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE LOWER(s.skills) IN (
    'aws',
    'azure',
    'gcp',
    'google cloud',
    'redshift',
    'bigquery'
)
GROUP BY s.skills
ORDER BY demand_count DESC;


-- Q8. Top 10 skills for remote Data Engineer jobs

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Engineer'
  AND j.job_work_from_home = TRUE
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q9. Top 10 skills for Senior Data Engineers

SELECT
    s.skills,
    COUNT(*) AS demand_count
FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Senior Data Engineer'
GROUP BY s.skills
ORDER BY demand_count DESC
LIMIT 10;


-- Q10. Skills common across three major job categories

SELECT
    s.skills,

    COUNT(DISTINCT j.job_title_short) AS job_categories,

    COUNT(*) AS total_demand

FROM data_jobs.main.job_postings_fact j
INNER JOIN data_jobs.main.skills_job_dim sj
    ON j.job_id = sj.job_id
INNER JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id

WHERE j.job_title_short IN (
    'Data Engineer',
    'Data Analyst',
    'Data Scientist'
)

GROUP BY s.skills

HAVING COUNT(DISTINCT j.job_title_short) = 3

ORDER BY total_demand DESC
LIMIT 20;


/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. OVERALL SKILL DEMAND:
   - Python is the most demanded skill with 759,081
     job-skill associations.
   - SQL follows closely with 758,824.
   - AWS and Azure are the leading cloud skills.
   - Excel, Tableau and Power BI also have high demand.

2. DATA ENGINEER SKILLS:
   - SQL is the most demanded Data Engineer skill
     with 233,132 associations.
   - Python follows with 224,102.
   - AWS, Azure and Spark are also highly demanded.
   - Databricks, Snowflake, Scala and Kafka are
     important technologies.

3. DATA ANALYST SKILLS:
   - SQL leads with 180,369 associations.
   - Excel and Python follow.
   - Tableau and Power BI are important visualization
     tools for Data Analyst roles.

4. DATA SCIENTIST SKILLS:
   - Python leads with 208,130 associations.
   - SQL and R follow.
   - AWS, Spark and TensorFlow also appear
     among the leading skills.

5. SKILL CATEGORY ANALYSIS:
   - Programming has the highest demand with
     2,689,906 associations.
   - Analyst tools and cloud follow.
   - Programming also has the highest number
     of unique skills (55).

6. PROGRAMMING SKILLS:
   - Python and SQL have the highest demand.
   - R, Java and Scala also have significant demand.
   - NoSQL appears in the dataset's programming
     category, although it is a database technology.

7. CLOUD PLATFORM DEMAND:
   - AWS leads with 302,245 associations.
   - Azure follows with 280,137.
   - GCP has 108,917 associations.
   - Redshift and BigQuery also appear in the results.

8. REMOTE DATA ENGINEER SKILLS:
   - SQL and Python lead remote Data Engineer demand.
   - AWS, Azure and Spark are also important.
   - Airflow, Snowflake and Databricks appear
     among the top 10 skills.

9. SENIOR DATA ENGINEER SKILLS:
   - Python and SQL lead the results.
   - Cloud platforms, Spark, Kafka and Databricks
     are also highly demanded.

10. COMMON SKILLS:
    - SQL and Python are common across Data Engineer,
      Data Analyst and Data Scientist roles.
    - AWS, Azure, R and visualization tools
      are also shared across these job categories.

11. OVERALL INSIGHT:
    - SQL and Python are foundational skills across
      major data-related job categories.
    - Cloud platforms and distributed processing
      technologies are particularly important
      for Data Engineering roles.
    - Remote Data Engineering jobs show similar
      core skill requirements.

NOTE:
Demand counts represent job-skill associations,
not necessarily unique job postings.

=========================================================
END OF SKILLS ANALYSIS
=========================================================
*/
