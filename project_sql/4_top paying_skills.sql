/*
Question: What are the most in-demand skills for data analysts?
    - Join jobs postings to inner join table similar to query 2 
    - Identify the top 5 in-demand skills for a data analyst.
    - Focus on all job postings 
    - Why? Retreives the top 5 skills with the highest demand in the job market,
        providing the insights into the most valuable skills for job seekers.

*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND job_work_from_home = 'True'
    AND salary_year_avg IS NOT NULL 
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25


/*
Top Paying Skills:

    PySpark: $208,172
    Bitbucket: $189,155
    Couchbase: $160,515
    Watson: $160,515
    DataRobot: $155,486
    
Key Trends:

        Big Data and Machine Learning: Skills like PySpark, DataRobot, and Watson are highly valued, reflecting the growing importance of big data and machine learning in data analysis.
    Version Control Systems: Bitbucket and GitLab are among the top-paying skills, indicating the importance of version control in managing data projects.
    Data Management and Analysis Tools: Tools like Couchbase, Jupyter, Pandas, and Elasticsearch are crucial for data storage, management, and analysis, leading to higher salaries for professionals proficient in these tools.
    Programming Languages: Swift, Golang, and Scala are among the top-paying skills, highlighting the demand for programming expertise in data analysis.
    Cloud and DevOps: Skills like Kubernetes, GCP, and Jenkins are also well-paid, showing the integration of cloud computing and DevOps practices in data analysis workflows.
    These trends suggest that data analysts with expertise in big data, machine learning, version control, data management, programming, and cloud/DevOps are in high demand and command higher salaries.

*/