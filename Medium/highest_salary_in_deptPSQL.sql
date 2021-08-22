-- Highest Salary In Department

-- https://platform.stratascratch.com/coding/9897-highest-salary-in-department

-- Find the employee with the highest salary 
-- per department.  Output the department name, 
-- employee's first name along with the 
-- corresponding salary.

-- My solution using a correlated subquery:
-- First, create a CTE that contains the maximum 
-- salary for each department.
WITH dept_max AS (
    SELECT department,
       MAX(salary) AS max_sal
	FROM employee
	GROUP BY department
    )
    
-- Next, use a correlated subquery to work through
-- the table row by row, returning only the rows
-- that have matching salaries and matching
-- departments in the table from above.
SELECT e.department, e.first_name, e.salary
FROM employee AS e
WHERE e.salary = (SELECT d.max_sal
                  FROM dept_max AS d
                  WHERE d.department = e.department
                  AND d.max_sal = e.salary
                  );


-- My solution using window functions:
-- First, create a CTE that ranks salaries in each
-- department in descending order.
WITH ranked_table AS (
    SELECT *,
       DENSE_RANK() OVER win AS dn
    FROM employee
    WINDOW win AS (PARTITION BY department ORDER BY salary DESC)
    )
    
-- Next, filter to return only results that
-- have a rank of 1.
SELECT department, first_name, salary
FROM ranked_table
WHERE dn = 1;
