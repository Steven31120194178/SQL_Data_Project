/*
Question: What skills are required for the Top-Paying Data Analyst jobs in the US?
- Using the first query for the Top 10 highest paying Data Analyst jobs
- Add the specific skills required for these roles
*/

WITH top_paying_jobs_US AS(
    SELECT 
        job_id,
        job_title,
        company_dim.name AS Company_Name,
        salary_year_avg
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
    LIMIT 10
)
SELECT 
    top_paying_jobs_US.*,
    skills
FROM top_paying_jobs_US
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = top_paying_jobs_US.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
	salary_year_avg DESC;
    
/*
💡 Key takeaways
🔹 Python is the most frequently mentioned skill — a clear priority for data analysts.

🔹 Traditional tools like Excel and SQL remain essential.

🔹 Data visualization tools (Tableau, Power BI) are highly valued.

🔹 R is still in demand for statistical analysis alongside Python.
*/