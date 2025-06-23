
-- Subqueries Example in the video
SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = TRUE    

    ORDER BY
        company_id
)

-- CTEs - common table expression

WITH company_job_count AS(
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact    
    GROUP BY
        company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON 
    company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC    

-- Problem 1 (using CTEs)

WITH skill_top_5 AS(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim   
    GROUP BY
        skill_id
    ORDER BY
        skill_count DESC                  
)

SELECT 
    skills_dim.skills AS skill_name,
    skill_top_5.skill_count
FROM 
    skills_dim
LEFT JOIN skill_top_5 ON 
    skill_top_5.skill_id = skills_dim.skill_id
ORDER BY
    skill_count DESC
LIMIT 5    


-- Problem 1 (using Subqueries)
SELECT 
    skills_dim.skills,
    TOP5_skills.skill_count
FROM skills_dim
INNER JOIN(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim   
    GROUP BY
        skill_id
    ORDER BY
        skill_count DESC  
    LIMIT 5        
) AS TOP5_skills ON skills_dim.skill_id = TOP5_skills.skill_id



-- Problem 2 
SELECT 
    company_dim.company_id,
    company_dim.name AS company_name,
    count_jobs.total_jobs,
    CASE
        WHEN total_jobs > 50 THEN 'Large'
        WHEN total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS  Salary_category  
FROM 
    company_dim
LEFT JOIN (   
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact    
    GROUP BY
        company_id
) AS count_jobs
ON company_dim.company_id = count_jobs.company_id;

/* Summary for this problem 2:
Start with company_dim table — this is your "base" table.

You build a "temporary table" (count_jobs) from your subquery, which aggregates job counts (COUNT(*)) per company_id.

Then you LEFT JOIN the subquery (count_jobs) onto company_dim based on company_id.

Because it's a LEFT JOIN, you keep all rows from company_dim, whether or not a match exists in count_jobs.     
*/

-- Problem 3

SELECT
    company_dim.name AS Company_Name,
    Average_salary.avg_jobs
FROM 
    company_dim
INNER join(
    SELECT
        company_id,
        AVG(salary_year_avg)AS avg_jobs
    FROM
        job_postings_fact    
    GROUP BY
        company_id
    HAVING
        AVG(salary_year_avg) IS NOT NULL
) AS Average_salary 
ON company_dim.company_id = Average_salary.company_id
WHERE
    Average_salary.avg_jobs > (
        SELECT AVG(salary_year_avg)
        FROM job_postings_fact
        WHERE salary_year_avg IS NOT NULL
    );