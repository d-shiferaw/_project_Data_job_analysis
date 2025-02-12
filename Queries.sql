SELECT * FROM job_postings_fact
LIMIT 100


SELECT job_posted_date


SELECT 
    '2023-02-19'::DATE,
    '123',
    'true':: BOOLEAN,
    '3.14'::REAL


--converting date & time zone as well as month and year
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT 100


--showing the count of job postings by month for data analyst
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY    
    month 
ORDER BY
    job_posted_count DESC

--showing job postings by month 
SELECT *
FROM job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 10



-- Table for each month of job postings
CREATE TABLE january_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1

CREATE TABLE february_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2

CREATE TABLE march_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3

CREATE TABLE april_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4

CREATE TABLE may_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5

CREATE TABLE june_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6

CREATE TABLE july_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7

CREATE TABLE august_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8

CREATE TABLE september_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9

CREATE TABLE october_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10

CREATE TABLE november_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11

CREATE TABLE december_jobs AS   
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12


SELECT job_posted_date 
FROM march_jobs


--Case Expressions

SELECT 
    job_title_short,
    job_location
FROM job_postings_fact

/*
case expressions example 

Label new column as follows:
- 'Anywhere' jobs as 'remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/

SELECT 
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'In-State'
        WHEN job_location = 'Rochester, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact

--turning that into a count
SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'In-State'
        WHEN job_location = 'Rochester, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;


--Subqueries
SELECT * 
FROM (--Subquery starts
    SELECT *
    FROM job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 1 GROUP
) AS January_jobs

--Sub query mentioning Company name with the dgeree requirment inside the query
SELECT 
    company_id, name
FROM 
    company_dim
WHERE company_id IN(
    SELECT
            company_id
    FROM
            job_postings_fact
    WHERE
            job_no_degree_mention = true
    ORDER BY
            company_id
)





--CTEs: define a temorary result set that you can reference using WITH
WITH january_jobs AS (--CTE definition starts here 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) --CTE definition ends here

Select *
FROM january_jobs


--CTE for Company count
WITH company_job_count AS(
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM
        Job_postings_fact
    GROUP BY
        company_id
)
--left join company_job_count.company_id to company_dim.company.id
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY   
    total_jobs DESC




/* 
Find the count of the number of remote job postings per skill
        - display the top 5 skills by their demand in remote jobs
        - Include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = TRUE AND 
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id  
)

SELECT
    skills.skill_id,
    skills AS skill_name, 
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
    skill_count DESC
LIMIT 5