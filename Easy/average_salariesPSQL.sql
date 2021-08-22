-- Average Salaries

-- https://platform.stratascratch.com/coding/9917-average-salaries

-- Compare each employee's salary with the average salary of 
-- the corresponding department.  Output the department, first name, 
-- and salary of employees along with the average salary of that 
-- department.

-- Use window function to partition by department and find the
-- average salary of that department.
SELECT department, 
       first_name, 
       salary, 
       AVG(salary) OVER win AS avg_dept_salary
FROM employee
WINDOW win AS (PARTITION BY department);