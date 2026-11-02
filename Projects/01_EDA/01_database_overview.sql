
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE 1: EXPLORATORY DATA ANALYSIS (EDA)
FILE: 01_database_overview.sql
=========================================================

OBJECTIVE:
Understand the overall structure and size of the
Jobs database before performing detailed analysis.

DATABASE: data_jobs
SCHEMA: main

TABLES:
1. company_dim
2. job_postings_fact
3. skills_dim
4. skills_job_dim
*/


/*
---------------------------------------------------------
Q1. How many companies are available in the dataset?

APPROACH:
- Count all records in company_dim.

WHY?
To understand the number of companies represented
in the dataset.
*/

SELECT
    COUNT(*) AS total_companies
FROM data_jobs.main.company_dim;


/*
---------------------------------------------------------
Q2. How many job postings are available?

APPROACH:
- Count all records in job_postings_fact.

WHY?
To understand the overall size of the job market dataset.
*/

SELECT
    COUNT(*) AS total_job_postings
FROM data_jobs.main.job_postings_fact;


/*
---------------------------------------------------------
Q3. How many unique skills are available?

APPROACH:
- Count records in skills_dim.

WHY?
To understand how many different skills are
represented in the dataset.
*/

SELECT
    COUNT(*) AS total_skills
FROM data_jobs.main.skills_dim;


/*
---------------------------------------------------------
Q4. How many job-skill relationships exist?

APPROACH:
- Count all records in skills_job_dim.

WHY?
To understand how many skill associations
are available across job postings.
*/

SELECT
    COUNT(*) AS total_job_skill_mappings
FROM data_jobs.main.skills_job_dim;


/*
---------------------------------------------------------
Q5. What does the job postings data look like?

APPROACH:
- Retrieve the first 10 records.

WHY?
To get an initial understanding of the columns
and values stored in the job postings table.
*/

SELECT *
FROM data_jobs.main.job_postings_fact
LIMIT 10;


/*
---------------------------------------------------------
Q6. How many Data Engineer job postings are available?

APPROACH:
- Filter job_postings_fact by job_title_short.

WHY?
To understand the number of Data Engineer
opportunities in the dataset.
*/

SELECT
    COUNT(*) AS total_data_engineer_jobs
FROM data_jobs.main.job_postings_fact
WHERE job_title_short = 'Data Engineer';




/*
=========================================================
END OF DATABASE OVERVIEW
=========================================================
*/


/*
KEY FINDINGS:

1. Total companies: 215,940
2. Total job postings: 1,615,930
3. Total skills: 262
4. Total job-skill mappings: 7,193,426
5. Data Engineer job postings: 391,957

OBSERVATIONS:

- The dataset contains a large volume of job postings.
- Each job can be associated with multiple skills.
- Salary information appears to be missing in some records.
- Data quality checks are required before further analysis.
*/