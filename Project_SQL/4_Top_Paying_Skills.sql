/*
Question: What are the top skills based on Salary for Data Analyst in US?
- Identify each skill's salary year average for Data Analyst in US
- Searching the Top10 skills with the highest salary year average
- Focus on specified salary(Remove Null)
*/


SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country LIKE '%United States%' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10;