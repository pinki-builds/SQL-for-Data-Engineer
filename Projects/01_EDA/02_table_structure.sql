
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE 1: EXPLORATORY DATA ANALYSIS
FILE: 02_table_structure.sql
=========================================================

OBJECTIVE:
Understand the structure of all four database tables.

QUESTIONS:
1. What columns exist in each table?
2. What are their data types?
3. How are the tables related?
*/


-- Q1. Company table structure

DESCRIBE data_jobs.main.company_dim;


-- Q2. Job postings table structure

DESCRIBE data_jobs.main.job_postings_fact;


-- Q3. Skills table structure

DESCRIBE data_jobs.main.skills_dim;


-- Q4. Job-skill mapping table structure

DESCRIBE data_jobs.main.skills_job_dim;


/*
END OF TABLE STRUCTURE ANALYSIS
*/


/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. company_dim:
   - Contains company_id, name, link, link_google and thumbnail.
   - company_id is the Primary Key.

2. job_postings_fact:
   - Contains job posting details, company information,
     location, posting date, work mode and salary details.
   - job_id is the Primary Key.
   - company_id connects job postings with company_dim.

3. skills_dim:
   - Contains skill_id, skills and type.
   - skill_id is the Primary Key.

4. skills_job_dim:
   - Acts as a bridge table between job postings and skills.
   - Contains job_id and skill_id.
   - Uses a Composite Primary Key (job_id, skill_id).

5. DATABASE RELATIONSHIPS:
   - One company can have multiple job postings.
   - One job can require multiple skills.
   - One skill can be associated with multiple jobs.

6. DATA MODEL:
   - company_dim and skills_dim are Dimension Tables.
   - job_postings_fact is the Fact Table.
   - skills_job_dim is a Bridge Table.

7. The database follows a relational structure and
   supports analysis of job postings, companies,
   salaries and skill demand.

8. Primary and composite keys were identified through
   table structure inspection. Foreign-key relationships
   will be validated through data quality checks.

=========================================================
END OF OBSERVATIONS
=========================================================
*/