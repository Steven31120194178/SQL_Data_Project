/*
Question: What are the most in-demand skills for Data Analyst in US?
- Identify the Top 10 in-demand skills for a Data Analyst
- Therefore, we focus on the Count for skills of each job postings
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS Demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country LIKE '%United States%' 
GROUP BY
    skills
ORDER BY
    Demand_count DESC
LIMIT 10;