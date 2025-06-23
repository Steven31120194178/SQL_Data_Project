
WITH remote_job_skills AS (
SELECT 
	skill_id,
    COUNT(skill_id) as skill_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
where
	job_work_from_home = TRUE
group by 
	skill_id
)    
SELECT 
	skills.skill_id, 
	skills as skill_name, 
	skill_count
FROM remote_job_skills
-- Get the skill name
INNER JOIN skills_dim AS skills 
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
	skill_count DESC
LIMIT 5;


-- Another way we solved without using subqueries and CTEs
-- Any column you SELECT that is not part of an aggregate function must appear in your GROUP BY clause.
SELECT 
    skills_dim.skill_id, 
    skills_dim.skills AS skill_name, 
    COUNT(skills_job_dim.skill_id) AS skill_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_work_from_home = TRUE
GROUP BY skills_dim.skill_id, skills_dim.skills
ORDER BY skill_count DESC
LIMIT 5;

-- Problem 1 
WITH most_diverse AS(
    SELECT
	    company_id,
        COUNT(DISTINCT job_title) AS Unique_title
    FROM 
        job_postings_fact
    GROUP BY
	    company_id
)
SELECT
    company_dim.name AS Company_Name,
    most_diverse.Unique_title
FROM    
    most_diverse
INNER JOIN company_dim ON
    company_dim.company_id = most_diverse.company_id
ORDER BY
    Unique_title DESC
LIMIT 10;


-- Problem 2
WITH avg_salary_country AS(
    SELECT 
	    job_country,
        AVG(salary_year_avg) AS average_country
    FROM job_postings_fact
    GROUP BY
	    job_country
)
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    company_dim.name,
    CASE
        WHEN job_postings_fact.salary_year_avg > avg_salary_country.average_country  THEN  'Above Average'
        ELSE 'Below Average'
    END AS Salary_Ratings,
    EXTRACT(MONTH FROM job_posted_date) AS job_month
FROM 
    job_postings_fact
INNER JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id
INNER JOIN avg_salary_country ON
    avg_salary_country.job_country = job_postings_fact.job_country    
ORDER BY
    job_month DESC


-- Problem 3
WITH first_CTE AS (
    SELECT 
	    company_id,
	    COUNT(DISTINCT skills_job_dim.skill_id) AS unique_skills_required
    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON
        skills_job_dim.job_id = job_postings_fact.job_id
    GROUP BY
	    company_id
),
second_CTE AS (
    SELECT 
        company_id,
        MAX(salary_year_avg) AS highest_average_salary
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT 
    company_dim.name,
    first_CTE.unique_skills_required,
    second_CTE.highest_average_salary
FROM second_CTE
LEFT JOIN company_dim ON
    company_dim.company_id = second_CTE.company_id
LEFT JOIN first_CTE ON
    first_CTE.company_id = second_CTE.company_id    
ORDER BY
    company_dim.name


