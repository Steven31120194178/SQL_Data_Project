-- Problem 1
SELECT
    job_schedule_type,
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'    
GROUP BY
    job_schedule_type

ORDER BY
    job_schedule_type;   

-- Problem 2    (a bit harder)
SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS job_month,
    COUNT(job_id)   
FROM 
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date) = 2023     
GROUP BY
    job_month
ORDER BY
    job_month;

-- Problem 3 (A great question)
SELECT 
    company_dim.name,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
INNER JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_health_insurance = TRUE AND
    EXTRACT(QUARTER FROM job_posted_date)=2
GROUP BY
    company_dim.name
HAVING
    COUNT(job_id) >= 1
ORDER BY 
    job_count DESC;

