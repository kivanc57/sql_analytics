
# HR Data Analysis Project

This project involves creating a MySQL database to analyze employee data from a human resources dataset. The SQL scripts included cover data cleaning, transformation, and analysis to answer key business questions about the workforce.

## Database Setup

```sql
CREATE DATABASE projects;
USE projects;
```

## Table Preparation

1. **Column Name Correction**  
   Renamed malformed column:
   ```sql
   ALTER TABLE hr
   CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;
   ```

2. **Date Formatting and Conversion**
   - `birthdate`, `hire_date`, and `termdate` fields were cleaned and converted to `DATE` format.
   - Empty `termdate` entries were set to `NULL`.

3. **Add Age Column**
   Calculated from `birthdate` using `TIMESTAMPDIFF`:
   ```sql
   ALTER TABLE hr ADD COLUMN age INT;
   UPDATE hr SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());
   ```

4. **Remove Underage Employees**
   ```sql
   DELETE FROM hr WHERE age < 18;
   ```

## Key Analyses and Queries

### 1. Gender Breakdown
```sql
SELECT gender, COUNT(gender) AS gender_count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY gender;
```

### 2. Race/Ethnicity Breakdown
```sql
SELECT race, COUNT(race) AS race_count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY race
ORDER BY race_count DESC;
```

### 3. Age Distribution
Grouped by age ranges:
```sql
SELECT age_group, COUNT(*) AS age_group_count
FROM ( ... ) grouped
GROUP BY age_group
ORDER BY age_group;
```

### 4. Age and Gender Combined
```sql
SELECT age_group, gender, COUNT(*) AS age_group_count
FROM ( ... ) grouped
GROUP BY age_group, gender
ORDER BY age_group, gender;
```

### 5. Location Breakdown
```sql
SELECT location, COUNT(*) AS count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY location;
```

### 6. Average Length of Employment
```sql
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365, 0) AS avg_length_employment
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL;
```

### 7. Gender by Department
```sql
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY department, gender
ORDER BY department, gender;
```

### 8. Job Title Distribution
```sql
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE termdate IS NOT NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;
```

### 9. Turnover Rate by Department
```sql
SELECT department, total_count, terminated_count, terminated_count / total_count AS termination_rate
FROM ( ... ) AS subquery
ORDER BY termination_rate DESC;
```

### 10. Location by State
```sql
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age IS NOT NULL
GROUP BY location_state
ORDER BY count DESC;
```

### 11. Company Growth Over Time
```sql
SELECT year, hires, terminations, hires - terminations AS net_change, ...
FROM ( ... ) AS subquery
ORDER BY year ASC;
```

### 12. Tenure by Department
```sql
SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_tenue
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL
GROUP BY department;
```

## Notes
- Ensure `sql_safe_updates` is disabled when performing updates:
  ```sql
  SET sql_safe_updates = 0;
  ```

- `NULL` checks and transformations were applied to ensure clean and consistent data for analysis.

