
/*
=========================================================
PROJECT: JOB MARKET DATA ANALYSIS
PHASE: EXPLORATORY DATA ANALYSIS
FILE: 03_data_quality.sql
=========================================================

OBJECTIVE:
Identify missing values, duplicates and invalid records.

*/

/* Q1. Check NULL values in company_dim */

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE company_id IS NULL) AS null_company_id,
    COUNT(*) FILTER (WHERE name IS NULL) AS null_company_name
FROM data_jobs.main.company_dim;


/* Q2. Check NULL values in job_postings_fact */

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE job_id IS NULL) AS null_job_id,
    COUNT(*) FILTER (WHERE company_id IS NULL) AS null_company_id,
    COUNT(*) FILTER (WHERE job_title_short IS NULL) AS null_job_title,
    COUNT(*) FILTER (WHERE job_country IS NULL) AS null_country,
    COUNT(*) FILTER (WHERE salary_year_avg IS NULL) AS null_yearly_salary,
    COUNT(*) FILTER (WHERE salary_hour_avg IS NULL) AS null_hourly_salary
FROM data_jobs.main.job_postings_fact;


/* Q3. Check NULL values in skills_dim */

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE skill_id IS NULL) AS null_skill_id,
    COUNT(*) FILTER (WHERE skills IS NULL) AS null_skill_name,
    COUNT(*) FILTER (WHERE type IS NULL) AS null_skill_type
FROM data_jobs.main.skills_dim;


/* Q4. Check duplicate job IDs */

SELECT
    job_id,
    COUNT(*) AS occurrences
FROM data_jobs.main.job_postings_fact
GROUP BY job_id
HAVING COUNT(*) > 1
LIMIT 20;


/* Q5. Check duplicate company IDs */

SELECT
    company_id,
    COUNT(*) AS occurrences
FROM data_jobs.main.company_dim
GROUP BY company_id
HAVING COUNT(*) > 1
LIMIT 20;


/* Q6. Check orphan company references */

SELECT COUNT(*) AS orphan_company_references
FROM data_jobs.main.job_postings_fact j
LEFT JOIN data_jobs.main.company_dim c
    ON j.company_id = c.company_id
WHERE j.company_id IS NOT NULL
  AND c.company_id IS NULL;


/* Q7. Check orphan skill references */

SELECT COUNT(*) AS orphan_skill_references
FROM data_jobs.main.skills_job_dim sj
LEFT JOIN data_jobs.main.skills_dim s
    ON sj.skill_id = s.skill_id
WHERE s.skill_id IS NULL;


/* Q8. Check orphan job references */

SELECT COUNT(*) AS orphan_job_references
FROM data_jobs.main.skills_job_dim sj
LEFT JOIN data_jobs.main.job_postings_fact j
    ON sj.job_id = j.job_id
WHERE j.job_id IS NULL;

-- Q9. Overall salary availability

SELECT
    COUNT(*) AS total_jobs,

    COUNT(*) FILTER (
        WHERE salary_year_avg IS NOT NULL
           OR salary_hour_avg IS NOT NULL
    ) AS jobs_with_salary,

    COUNT(*) FILTER (
        WHERE salary_year_avg IS NULL
          AND salary_hour_avg IS NULL
    ) AS jobs_without_salary

FROM data_jobs.main.job_postings_fact;

/* END OF DATA QUALITY ANALYSIS */


/*
=========================================================
OBSERVATIONS & KEY FINDINGS
=========================================================

1. COMPANY DATA:
   - Total company records: 215,940.
   - Only 1 record has a NULL company name.
   - No NULL company IDs found.

2. JOB POSTINGS DATA:
   - Total job postings: 1,615,930.
   - No NULL job IDs, company IDs or job titles.
   - 1,125 job postings have missing country information.

3. SALARY DATA:
   - 77,085 job postings have at least one salary value.
   - 1,538,845 job postings have no salary information.
   - Only 4.77% of job postings contain salary data.
   - 95.23% of job postings have missing salary information.
   - Salary-based analysis must account for this limitation.

4. SKILLS DATA:
   - No NULL values found in skills_dim.

5. DUPLICATE CHECK:
   - No duplicate job IDs found.
   - No duplicate company IDs found.

6. REFERENTIAL INTEGRITY:
   - No orphan company references found.
   - No orphan skill references found.
   - No orphan job references found.

7. OVERALL DATA QUALITY:
   - IDs and table relationships appear consistent
     based on the checks performed.
   - Salary and country fields require further
     investigation.
   - Raw source tables will remain unchanged.

=========================================================
END OF OBSERVATIONS
=========================================================
*/