-- Average Salary per Role
create view vw_avg_salary_by_job_title as
select job_title,
       ROUND(AVG(salary_usd), 2) as avg_salary_usd,
       COUNT(*) as job_count
from ai_jobs
group by job_title
order by avg_salary_usd desc;

-- Average Salary by Company Location
create view vw_salary_by_location as
select company_location,
       ROUND(AVG(salary_usd), 2) as avg_salary_usd,
       COUNT(*) as location_count
from ai_jobs
group by company_location
order by avg_salary_usd desc;

-- Top Roles Based on Remote Friendliness
CREATE VIEW vw_remote_friendly_roles AS
SELECT job_title,
       ROUND(AVG(remote_ratio), 1) AS avg_remote_ratio,
       COUNT(*) AS job_count
FROM ai_jobs
GROUP BY job_title
HAVING COUNT(*) > 1
ORDER BY avg_remote_ratio DESC;

-- Skill Demanded by Location
CREATE or REPLACE VIEW vw_location_skill_demand AS
SELECT company_location, required_skills,
       COUNT(*) AS demand
FROM ai_jobs_exploded
GROUP BY company_location, required_skills
ORDER BY demand DESC;

-- Role, Location, and Experience Summary
CREATE OR REPLACE VIEW vw_role_location_summary AS
SELECT 
    job_title,
    company_location,
    experience_level,
    ROUND(AVG(salary_usd), 2) AS avg_salary_usd,
    COUNT(*) AS job_count
FROM ai_jobs
GROUP BY job_title, company_location, experience_level
ORDER BY ROUND(AVG(salary_usd), 2) DESC;

-- Summary Insights
CREATE OR REPLACE VIEW vw_summary_insights AS
SELECT 
    (SELECT job_title FROM vw_avg_salary_by_title LIMIT 1) AS highest_paying_role,
    (SELECT company_location FROM vw_salary_by_location LIMIT 1) AS highest_paying_country,
    (SELECT company_location FROM ai_jobs GROUP BY company_location ORDER BY COUNT(*) DESC LIMIT 1) AS most_common_location,
    (SELECT job_title FROM vw_remote_friendly_roles LIMIT 1) AS most_remote_friendly_role;
