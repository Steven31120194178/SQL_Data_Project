/*
Question: What are the Top-Paying Data Analyst Jobs in the United States?
- Finding various Data Analyst roles that are in the US
- Focusing on job postings with specified salaries (Remove Nulls)
*/

SELECT 
	job_id,
    job_title,
    company_dim.name AS Company_Name,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim ON
	company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    -- Contains the phrase United States anywhere within the value.
    job_country LIKE '%United States%' AND
    salary_year_avg IS NOT NULL
ORDER BY
	salary_year_avg DESC
LIMIT 10;    