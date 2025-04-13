CREATE DATABASE projects;

USE projects;

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
  WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
  ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT birthdate FROM hr;

UPDATE hr
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
  ELSE NULL
END;

SELECT hire_date FROM hr;

SELECT termdate FROM hr;

UPDATE hr
SET termdate = CASE
  WHEN termdate = '' THEN NULL -- Set empty strings to NULL
  WHEN termdate IS NOT NULL THEN DATE(STR_TO_DATE((termdate, '%Y-%m-%d %H:%i:%s UTC'))) -- Convert valid timestamps
  ELSE termdate -- Keep existing NULL values as NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

DESCRIBE hr;

ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
  SET age = timestampdiff(YEAR, birthdate, CURDATE());


DELETE FROM hr
WHERE age < 18;


SELECT
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr;

SELECT age FROM hr;

-- Questions

-- 1) What is the gender breakdown of employees in the company?
SELECT gender, COUNT(gender) AS gender_count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY gender;

-- 2) What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(race) AS race_count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY race
ORDER BY race_count DESC;

-- 3) What is the age distribution of employees in the company?
SELECT
  age_group,
  COUNT(*) AS age_group_count
FROM (
  SELECT
    CASE
	  WHEN age BETWEEN 18 AND 24 THEN '18-24'
	  WHEN age BETWEEN 25 AND 34 THEN '25-34'
	  WHEN age BETWEEN 35 AND 44 THEN '35-44'
	  WHEN age BETWEEN 45 AND 54 THEN '45-54'
	  WHEN age BETWEEN 55 AND 64 THEN '55-64'
	  ELSE '65+'
	END AS age_group
	FROM hr
	WHERE termdate IS NOT NULL
) grouped
GROUP BY age_group
ORDER BY age_group;


SELECT
  age_group,
  gender,
  COUNT(*) AS age_group_count
FROM (
  SELECT
    CASE
	  WHEN age BETWEEN 18 AND 24 THEN '18-24'
	  WHEN age BETWEEN 25 AND 34 THEN '25-34'
	  WHEN age BETWEEN 35 AND 44 THEN '35-44'
	  WHEN age BETWEEN 45 AND 54 THEN '45-54'
	  WHEN age BETWEEN 55 AND 64 THEN '55-64'
	  ELSE '65+'
  END AS age_group,
  gender
  FROM hr
  WHERE termdate IS NOT NULL
) grouped
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4) How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY location;

-- 5) What is the average length of employment for employees who have been terminated?
SELECT
  ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365, 0) AS avg_length_employment
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL;

-- 6) How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY department, gender
ORDER BY department, gender;

-- 7) What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8) Which department has the highest turnover rate?
SELECT
    department,
    total_count,
    terminated_count,
    terminated_count / total_count AS termination_rate
FROM (
    SELECT
        department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9) What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age IS NOT NULL
GROUP BY location_state
ORDER BY count DESC;

-- 10) How has the company's employee count changed over time based on hire and term dates?
SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) / hires * 100, 2) AS net_change_percent
FROM (
    SELECT
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    GROUP BY year
) AS subquery
ORDER BY year ASC;

-- 11) What is the tenure distribution for each department?
SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_tenue
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL
GROUP BY department;