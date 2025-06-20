/*
Question: What are the most optimal skills to learn in US as a Data Analyst?
- Identify each skill with its Count and Salary year average(high-demand & high-paying)
- Focusing on specified Salary (Remove Null)
- Obtain the Top 20 skills with the highest dmeand and highest salary
- Optional: Which order you preferred for the top 20 skills? (Highest Demand or Highest Salary)
*/

-- Using CTEs for the query
WITH skills_demand AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
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
        skills_dim.skill_id
), average_salary AS(
    SELECT 
        skills_dim.skill_id,
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
        skills_dim.skill_id
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary ON
    average_salary.skill_id = skills_demand.skill_id
ORDER BY
-- The Count will be ordered before the avg_salary in descending order
    demand_count DESC,
    avg_salary DESC
LIMIT 20;


-- Another way without using CTEs to write the same query more concisely
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country LIKE '%United States%' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 20;