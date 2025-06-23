-- Problem 1
SELECT
    job_id,
    job_title,
    'With Salary Info' AS salary_info
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
   OR salary_hour_avg IS NOT NULL

UNION ALL

SELECT
    job_id,
    job_title,
    'Without Salary Info' AS salary_info
FROM job_postings_fact
WHERE salary_year_avg IS NULL
  AND salary_hour_avg IS NULL

ORDER BY
  job_id

-- Problem 1 (using CASE)
SELECT 
  job_id,
  job_title,
  CASE 
    WHEN salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL THEN 'With Salary Info'
    ELSE 'Without Salary Info'
  END AS salary_info
FROM job_postings_fact

-- Problem 2
SELECT
    job_postings_q1.job_id,
    job_postings_q1.job_title_short,
    job_postings_q1.job_location,
    job_postings_q1.job_via,
    job_postings_q1.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM
-- Get job postings from the first quarter of 2023 we can combine them to gether inside a from statement
    (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) as job_postings_q1

LEFT JOIN skills_job_dim ON 
    job_postings_q1.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_q1.salary_year_avg > 70000
ORDER BY
    job_postings_q1.job_id;

-- Problem 3
SELECT
  skills_dim.skills,
  job_postings_combine.year,
  job_postings_combine.month,
  COUNT(job_postings_combine.job_id)
FROM
    (
    SELECT *, EXTRACT(YEAR FROM job_posted_date) AS year, EXTRACT(MONTH FROM job_posted_date) AS month
    FROM january_jobs
    UNION ALL
    SELECT *, EXTRACT(YEAR FROM job_posted_date) AS year, EXTRACT(MONTH FROM job_posted_date) AS month
    FROM february_jobs
    UNION ALL
    SELECT *, EXTRACT(YEAR FROM job_posted_date) AS year, EXTRACT(MONTH FROM job_posted_date) AS month
    FROM march_jobs
    ) as job_postings_combine

LEFT JOIN skills_job_dim ON 
    job_postings_combine.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id

GROUP BY
  skills_dim.skills,
  job_postings_combine.year,
  job_postings_combine.month

ORDER BY
  skills_dim.skills

