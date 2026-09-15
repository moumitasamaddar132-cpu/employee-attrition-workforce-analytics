CREATE DATABASE hr_analytics;

USE hr_analytics;

SELECT *
FROM employee_hr
LIMIT 10;

-- Q1. Calculate the total number of employees,the number of churned employees, and the churn rate for each department.
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Churn_Rate
FROM employee_hr
GROUP BY Department
ORDER BY Churn_Rate DESC;


-- Q2. Compare employees who churned vs employees who were retained.
-- Calculate:
-- 1. Average salary
-- 2. Average monthly working hours
-- 3. Average satisfaction score


SELECT
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS Churn_Status,
    ROUND(AVG(Salary_INR), 2) AS Avg_Salary,
    ROUND(AVG(average_montly_hours), 2) AS Avg_Monthly_Hours,
    ROUND(AVG(Satisfaction), 2) AS Avg_Satisfaction
FROM employee_hr
GROUP BY Churn
ORDER BY Churn DESC;

-- Q3. Identify departments whose churn rate is higher
-- than the overall company churn rate.

SELECT
    Department,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY Department
HAVING AVG(Churn) > (
    SELECT AVG(Churn)
    FROM employee_hr
)
ORDER BY Churn_Rate DESC;


-- Q4. Find the top 3 departments with the highest
-- number of churned employees.
--
-- Expected output:
-- Department | Churned_Employees
--
-- Sort from highest to lowest.

SELECT
    Department,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees
FROM employee_hr
GROUP BY Department
ORDER BY Churned_Employees DESC
LIMIT 3;

-- Q5. Compare the churn rate of employees who were promoted
-- with employees who were not promoted.
--
-- Expected output:
-- Promotion_Status | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    CASE
        WHEN Promotion = 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS Promotion_Status,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY Promotion
ORDER BY Churn_Rate DESC;

-- Q6. Find the average salary and average monthly working
-- hours for each department.
--
-- Expected output:
-- Department | Avg_Salary | Avg_Monthly_Hours
--
-- Sort by Avg_Salary from highest to lowest.

SELECT
    Department,
    ROUND(AVG(Salary_INR), 2) AS Avg_Salary,
    ROUND(AVG(average_montly_hours), 2) AS Avg_Monthly_Hours
FROM employee_hr
GROUP BY Department
ORDER BY Avg_Salary DESC;

-- Q7. Find the average salary of retained and churned
-- employees within each department.
--
-- Expected output:
-- Department | Churn_Status | Avg_Salary
--
-- Sort by Department, then Churn_Status.

SELECT
    Department,
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS Churn_Status,
    ROUND(AVG(Salary_INR), 2) AS Avg_Salary
FROM employee_hr
GROUP BY Department, Churn
ORDER BY Department, Churn_Status;

-- Q8. Identify employees who have:
-- 1. Low satisfaction (below 4)
-- 2. High monthly working hours (above 240)
-- 3. And eventually churned.
--
-- Return:
-- Department | Churned_Employees
--
-- Sort by Churned_Employees from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Churned_Employees
FROM employee_hr
WHERE Satisfaction < 4
  AND average_montly_hours > 240
  AND Churn = 1
GROUP BY Department
ORDER BY Churned_Employees DESC;

-- Q9. Find the top 5 departments with the highest
-- average monthly working hours among churned employees.
--
-- Expected output:
-- Department | Avg_Monthly_Hours
--
-- Consider only Churn = 1.
-- Sort from highest to lowest.

SELECT
    Department,
    ROUND(AVG(average_montly_hours), 2) AS Avg_Monthly_Hours
FROM employee_hr
WHERE Churn = 1
GROUP BY Department
ORDER BY Avg_Monthly_Hours DESC
LIMIT 5;


-- Q10. Find departments where the average salary of
-- churned employees is lower than the average salary
-- of retained employees.
--
-- Expected output:
-- Department | Avg_Churned_Salary | Avg_Retained_Salary
--
-- Sort by the salary gap from highest to lowest.


SELECT
    Department,
    ROUND(AVG(CASE WHEN Churn = 1 THEN Salary_INR END), 2) AS Avg_Churned_Salary,
    ROUND(AVG(CASE WHEN Churn = 0 THEN Salary_INR END), 2) AS Avg_Retained_Salary
FROM employee_hr
GROUP BY Department
HAVING AVG(CASE WHEN Churn = 1 THEN Salary_INR END)
     < AVG(CASE WHEN Churn = 0 THEN Salary_INR END)
ORDER BY
    Avg_Retained_Salary - Avg_Churned_Salary DESC;
    
-- Q11. Find employees who have a higher-than-average salary
-- within their own department.
--
-- Expected output:
-- EmpId | Department | Salary_INR
--
-- Sort by Department, then Salary_INR from highest to lowest.

SELECT
    e.EmpId,
    e.Department,
    e.Salary_INR
FROM employee_hr e
JOIN (
    SELECT
        Department,
        AVG(Salary_INR) AS Avg_Dept_Salary
    FROM employee_hr
    GROUP BY Department
) d
ON e.Department = d.Department
WHERE e.Salary_INR > d.Avg_Dept_Salary
ORDER BY e.Department, e.Salary_INR DESC;

-- Q12. Find the top 5 employees with the highest
-- monthly working hours among employees who churned.
--
-- Expected output:
-- EmpId | Department | average_montly_hours | Salary_INR
--
-- Consider only Churn = 1.
-- Sort by average_montly_hours from highest to lowest.

SELECT
    EmpId,
    Department,
    average_montly_hours,
    Salary_INR
FROM employee_hr
WHERE Churn = 1
ORDER BY average_montly_hours DESC
LIMIT 5;

-- Q13. Find the department with the highest average
-- satisfaction score among employees who churned.
--
-- Expected output:
-- Department | Avg_Satisfaction
--
-- Consider only Churn = 1.
-- Return the highest department first.

SELECT
    Department,
    ROUND(AVG(Satisfaction), 2) AS Avg_Satisfaction
FROM employee_hr
WHERE Churn = 1
GROUP BY Department
ORDER BY Avg_Satisfaction DESC
LIMIT 1;

-- Q14. Find the departments where more than 25% of
-- employees have churned.
--
-- Expected output:
-- Department | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY Department
HAVING AVG(Churn) > 0.25
ORDER BY Churn_Rate DESC;

-- Q15. Calculate the churn rate for each salary level.
--
-- Salary levels:
-- Low    = Salary_INR < 30000
-- Medium = Salary_INR BETWEEN 30000 AND 60000
-- High   = Salary_INR > 60000
--
-- Expected output:
-- Salary_Level | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    CASE
        WHEN Salary_INR < 30000 THEN 'Low'
        WHEN Salary_INR <= 60000 THEN 'Medium'
        ELSE 'High'
    END AS Salary_Level,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY Salary_Level
ORDER BY Churn_Rate DESC;

-- Q16. Find the average number of projects handled by
-- employees in each department, separately for churned
-- and retained employees.
--
-- Expected output:
-- Department | Churn_Status | Avg_Projects
--
-- Sort by Department, then Churn_Status.

SELECT
    Department,
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS Churn_Status,
    ROUND(AVG(number_of_projects), 2) AS Avg_Projects
FROM employee_hr
GROUP BY Department, Churn
ORDER BY Department, Churn_Status;

-- Q17. Find the department-wise churn rate for employees
-- who have worked at the company for more than 3 years.
--
-- Expected output:
-- Department | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
WHERE time_spent_company > 3
GROUP BY Department
ORDER BY Churn_Rate DESC;

-- Q18. Find the top 5 departments with the highest
-- churn rate among employees with low satisfaction
-- (Satisfaction < 4).
--
-- Expected output:
-- Department | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
WHERE Satisfaction < 4
GROUP BY Department
ORDER BY Churn_Rate DESC
LIMIT 5;

-- Q19. Find the average salary and churn rate for each
-- combination of department and promotion status.
--
-- Expected output:
-- Department | Promotion_Status | Avg_Salary | Churn_Rate
--
-- Sort by Department, then Churn_Rate highest to lowest.

SELECT
    Department,
    CASE
        WHEN Promotion = 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS Promotion_Status,
    ROUND(AVG(Salary_INR), 2) AS Avg_Salary,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY Department, Promotion
ORDER BY Department, Churn_Rate DESC;

-- Q20. Find employees who have churned and have:
-- 1. Satisfaction below the overall average satisfaction
-- 2. Salary below the overall average salary
--
-- Return:
-- EmpId | Department | Satisfaction | Salary_INR
--
-- Sort by Satisfaction from lowest to highest.

SELECT
    EmpId,
    Department,
    Satisfaction,
    Salary_INR
FROM employee_hr
WHERE Churn = 1
  AND Satisfaction < (
      SELECT AVG(Satisfaction)
      FROM employee_hr
  )
  AND Salary_INR < (
      SELECT AVG(Salary_INR)
      FROM employee_hr
  )
ORDER BY Satisfaction ASC;

-- Q21. Find the department-wise average salary of employees
-- who were promoted, and compare it with employees who were
-- not promoted.
--
-- Expected output:
-- Department | Promoted_Avg_Salary | Not_Promoted_Avg_Salary
--
-- Sort by the difference between the two averages
-- from highest to lowest.

SELECT
    Department,
    ROUND(AVG(CASE WHEN Promotion = 1 THEN Salary_INR END), 2) AS Promoted_Avg_Salary,
    ROUND(AVG(CASE WHEN Promotion = 0 THEN Salary_INR END), 2) AS Not_Promoted_Avg_Salary
FROM employee_hr
GROUP BY Department
ORDER BY
    Promoted_Avg_Salary - Not_Promoted_Avg_Salary DESC;
    
    
-- Q22. Find the top 5 departments with the highest
-- percentage of employees working more than 240 hours
-- per month.
--
-- Expected output:
-- Department | Total_Employees | High_Workload_Employees | High_Workload_Percentage
--
-- Sort by High_Workload_Percentage from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(
        CASE
            WHEN average_montly_hours > 240 THEN 1
            ELSE 0
        END
    ) AS High_Workload_Employees,
    ROUND(
        SUM(
            CASE
                WHEN average_montly_hours > 240 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS High_Workload_Percentage
FROM employee_hr
GROUP BY Department
ORDER BY High_Workload_Percentage DESC
LIMIT 5;

-- Q23. Find the churn rate for each combination of
-- satisfaction level and workload level.
--
-- Satisfaction:
-- Low    < 4
-- Medium = 4 to 7
-- High   > 7
--
-- Workload:
-- Low    < 170 hours
-- Normal = 170 to 240 hours
-- High   > 240 hours
--
-- Expected output:
-- Satisfaction_Level | Workload_Level | Total_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    CASE
        WHEN Satisfaction < 4 THEN 'Low'
        WHEN Satisfaction <= 7 THEN 'Medium'
        ELSE 'High'
    END AS Satisfaction_Level,

    CASE
        WHEN average_montly_hours < 170 THEN 'Low'
        WHEN average_montly_hours <= 240 THEN 'Normal'
        ELSE 'High'
    END AS Workload_Level,

    COUNT(*) AS Total_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate

FROM employee_hr

GROUP BY
    Satisfaction_Level,
    Workload_Level

ORDER BY Churn_Rate DESC;


-- Q24. Find the top 5 employee segments with the highest
-- churn rate based on satisfaction level and salary level.
--
-- Salary:
-- Low    < 30000
-- Medium = 30000 to 60000
-- High   > 60000
--
-- Expected output:
-- Satisfaction_Level | Salary_Level | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    CASE
        WHEN Satisfaction < 4 THEN 'Low'
        WHEN Satisfaction <= 7 THEN 'Medium'
        ELSE 'High'
    END AS Satisfaction_Level,

    CASE
        WHEN Salary_INR < 30000 THEN 'Low'
        WHEN Salary_INR <= 60000 THEN 'Medium'
        ELSE 'High'
    END AS Salary_Level,

    COUNT(*) AS Total_Employees,

    SUM(
        CASE
            WHEN Churn = 1 THEN 1
            ELSE 0
        END
    ) AS Churned_Employees,

    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate

FROM employee_hr

GROUP BY
    Satisfaction_Level,
    Salary_Level

ORDER BY Churn_Rate DESC
LIMIT 5;

-- Q25. Find the average tenure of employees who churned
-- versus employees who were retained, for each department.
--
-- Expected output:
-- Department | Churn_Status | Avg_Tenure
--
-- Sort by Department, then Churn_Status.

SELECT
    Department,
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS Churn_Status,
    ROUND(AVG(time_spent_company), 2) AS Avg_Tenure
FROM employee_hr
GROUP BY Department, Churn
ORDER BY Department, Churn_Status;

-- Q26. Find the average monthly working hours and
-- churn rate for each combination of department and
-- satisfaction level.
--
-- Satisfaction:
-- Low    < 4
-- Medium = 4 to 7
-- High   > 7
--
-- Expected output:
-- Department | Satisfaction_Level | Avg_Monthly_Hours | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    CASE
        WHEN Satisfaction < 4 THEN 'Low'
        WHEN Satisfaction <= 7 THEN 'Medium'
        ELSE 'High'
    END AS Satisfaction_Level,
    ROUND(AVG(average_montly_hours), 2) AS Avg_Monthly_Hours,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY
    Department,
    Satisfaction_Level
ORDER BY Churn_Rate DESC;

-- Q27. Find the top 5 departments with the highest
-- churn rate among employees who have NOT received
-- a promotion.
--
-- Expected output:
-- Department | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
WHERE Promotion = 0
GROUP BY Department
ORDER BY Churn_Rate DESC
LIMIT 5;

-- Q28. Find the department-wise churn rate for employees
-- who have both:
-- 1. Low satisfaction (below 4)
-- 2. High workload (above 240 monthly hours)
--
-- Expected output:
-- Department | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
WHERE Satisfaction < 4
  AND average_montly_hours > 240
GROUP BY Department
ORDER BY Churn_Rate DESC;

-- Q29. Find the department with the highest churn rate
-- among employees who have been with the company for
-- more than 4 years.
--
-- Expected output:
-- Department | Total_Employees | Churned_Employees | Churn_Rate
--
-- Return the top 3 departments.
-- Sort by Churn_Rate from highest to lowest.

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
WHERE time_spent_company > 4
GROUP BY Department
ORDER BY Churn_Rate DESC
LIMIT 3;

-- Q30. Calculate the churn rate for each combination of
-- department and workload level.
--
-- Workload:
-- Low    < 170 hours
-- Normal = 170 to 240 hours
-- High   > 240 hours
--
-- Expected output:
-- Department | Workload_Level | Total_Employees | Churned_Employees | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.
SELECT
    Department,
    CASE
        WHEN average_montly_hours < 170 THEN 'Low'
        WHEN average_montly_hours <= 240 THEN 'Normal'
        ELSE 'High'
    END AS Workload_Level,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
GROUP BY
    Department,
    Workload_Level
ORDER BY Churn_Rate DESC;

-- Q31. Rank employees within each department based on salary.
--
-- Expected output:
-- EmpId | Department | Salary_INR | Salary_Rank
--
-- Highest salary should have rank 1.

SELECT
    EmpId,
    Department,
    Salary_INR,
    RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary_INR DESC
    ) AS Salary_Rank
FROM employee_hr;

-- Q32. Find the highest-paid employee in each department.
--
-- Expected output:
-- EmpId | Department | Salary_INR
--
-- If multiple employees have the same highest salary,
-- return all of them.

WITH ranked_employees AS (
    SELECT
        EmpId,
        Department,
        Salary_INR,
        RANK() OVER (
            PARTITION BY Department
            ORDER BY Salary_INR DESC
        ) AS salary_rank
    FROM employee_hr
)
SELECT
    EmpId,
    Department,
    Salary_INR
FROM ranked_employees
WHERE salary_rank = 1
ORDER BY Department;

-- Q33. Find the top 3 highest-paid employees in each department.
--
-- Expected output:
-- EmpId | Department | Salary_INR | Salary_Rank
--
-- Return all employees tied within the top 3 ranks.

WITH ranked_employees AS (
    SELECT
        EmpId,
        Department,
        Salary_INR,
        DENSE_RANK() OVER (
            PARTITION BY Department
            ORDER BY Salary_INR DESC
        ) AS Salary_Rank
    FROM employee_hr
)
SELECT
    EmpId,
    Department,
    Salary_INR,
    Salary_Rank
FROM ranked_employees
WHERE Salary_Rank <= 3
ORDER BY Department, Salary_Rank;


-- Q34. Rank departments based on their churn rate.
--
-- Expected output:
-- Department | Churn_Rate | Department_Rank
--
-- Highest churn rate should have rank 1.

WITH department_churn AS (
    SELECT
        Department,
        ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
    FROM employee_hr
    GROUP BY Department
)
SELECT
    Department,
    Churn_Rate,
    RANK() OVER (
        ORDER BY Churn_Rate DESC
    ) AS Department_Rank
FROM department_churn
ORDER BY Department_Rank;

-- Q35. Find the top 2 highest-paid employees
-- in each department who have churned.
--
-- Expected output:
-- EmpId | Department | Salary_INR | Salary_Rank
--
-- Return all employees tied within the top 2 ranks.

WITH ranked_employees AS (
    SELECT
        EmpId,
        Department,
        Salary_INR,
        DENSE_RANK() OVER (
            PARTITION BY Department
            ORDER BY Salary_INR DESC
        ) AS Salary_Rank
    FROM employee_hr
    WHERE Churn = 1
)
SELECT
    EmpId,
    Department,
    Salary_INR,
    Salary_Rank
FROM ranked_employees
WHERE Salary_Rank <= 2
ORDER BY Department, Salary_Rank;


-- Q36. For each employee, compare their salary with the
-- previous salary in the same department.
--
-- Expected output:
-- EmpId | Department | Salary_INR | Previous_Salary | Salary_Difference
--
-- Order employees by salary from lowest to highest within
-- each department.

WITH salary_comparison AS (
    SELECT
        EmpId,
        Department,
        Salary_INR,
        LAG(Salary_INR) OVER (
            PARTITION BY Department
            ORDER BY Salary_INR
        ) AS Previous_Salary
    FROM employee_hr
)
SELECT
    EmpId,
    Department,
    Salary_INR,
    Previous_Salary,
    Salary_INR - Previous_Salary AS Salary_Difference
FROM salary_comparison
ORDER BY Department, Salary_INR;

-- Q37. Calculate the overall churn rate and compare it
-- with the churn rate of employees who have low satisfaction
-- (Satisfaction < 4).
--
-- Expected output:
-- Employee_Group | Total_Employees | Churned_Employees | Churn_Rate

WITH employee_groups AS (
    SELECT
        'Overall' AS Employee_Group,
        COUNT(*) AS Total_Employees,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
        AVG(Churn) * 100 AS Churn_Rate
    FROM employee_hr

    UNION ALL

    SELECT
        'Low Satisfaction' AS Employee_Group,
        COUNT(*) AS Total_Employees,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
        AVG(Churn) * 100 AS Churn_Rate
    FROM employee_hr
    WHERE Satisfaction < 4
)
SELECT
    Employee_Group,
    Total_Employees,
    Churned_Employees,
    ROUND(Churn_Rate, 2) AS Churn_Rate
FROM employee_groups;

-- Q38. Find departments where:
-- 1. Churn rate is above the company-wide churn rate
-- 2. Average salary is below the company-wide average salary
--
-- Expected output:
-- Department | Churn_Rate | Avg_Salary
--
-- Sort by Churn_Rate from highest to lowest.

WITH department_metrics AS (
    SELECT
        Department,
        AVG(Churn) * 100 AS Churn_Rate,
        AVG(Salary_INR) AS Avg_Salary
    FROM employee_hr
    GROUP BY Department
)
SELECT
    Department,
    ROUND(Churn_Rate, 2) AS Churn_Rate,
    ROUND(Avg_Salary, 2) AS Avg_Salary
FROM department_metrics
WHERE Churn_Rate > (
    SELECT AVG(Churn) * 100
    FROM employee_hr
)
AND Avg_Salary < (
    SELECT AVG(Salary_INR)
    FROM employee_hr
)
ORDER BY Churn_Rate DESC;

-- Q39. Calculate the percentage of all churned employees
-- contributed by each department.
--
-- Expected output:
-- Department | Churned_Employees | Churn_Contribution_Percentage
--
-- Sort by Churn_Contribution_Percentage from highest to lowest.

SELECT
    Department,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Employees,
    ROUND(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / (
            SELECT SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END)
            FROM employee_hr
        ),
        2
    ) AS Churn_Contribution_Percentage
FROM employee_hr
GROUP BY Department
ORDER BY Churn_Contribution_Percentage DESC;

-- Q40. Identify high-risk employee segments.
--
-- A high-risk employee is:
-- 1. Satisfaction < 4
-- 2. average_montly_hours > 240
-- 3. Salary_INR < 60000
--
-- Calculate for each department:
-- Total high-risk employees
-- Churned high-risk employees
-- Churn rate among high-risk employees
--
-- Expected output:
-- Department | High_Risk_Employees | Churned_High_Risk | Churn_Rate
--
-- Sort by Churn_Rate from highest to lowest.


SELECT
    Department,
    COUNT(*) AS High_Risk_Employees,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_High_Risk,
    ROUND(AVG(Churn) * 100, 2) AS Churn_Rate
FROM employee_hr
WHERE Satisfaction < 4
  AND average_montly_hours > 240
  AND Salary_INR < 60000
GROUP BY Department
ORDER BY Churn_Rate DESC;