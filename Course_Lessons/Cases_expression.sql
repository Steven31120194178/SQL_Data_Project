-- From the video
SELECT
    COUNT(job_id),
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- Problem 1
SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Standard Salary'
        ELSE 'Low Salary'
    END AS  Salary_category

FROM job_postings_fact
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;   

-- Problem 2
-- We are using distinct for this case because there are mulitple rows has the same company_id(better to check it)
-- So we want the same company_id only count as once
-- The code means when wfh=True, return its company_id
SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM job_postings_fact;

--Problem 3
SELECT
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%senior%' THEN 'Senior'
        WHEN job_title ILIKE '%lead%' OR job_title ILIKE '%manager%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%junior%' OR job_title ILIKE '%entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,

    CASE
        WHEN job_work_from_home = TRUE THEN 'Yes' 
        WHEN job_work_from_home = FALSE THEN 'No'
    END AS remote_option
FROM job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;