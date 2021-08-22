-- Finding Updated Records

-- https://platform.stratascratch.com/coding/10299-finding-updated-records

-- We have a table with employees and their salaries, 
-- however, some of the records are old and contain 
-- outdated salary information. Find the current salary 
-- of each employee assuming that salaries increase each 
-- year. Output their id, first name, last name, department ID, 
-- and current salary. Order your list by employee ID 
-- in ascending order.

-- Create CTE that partitions by a unique employee id to figure
-- out each employees maximum salary.  Additionally, assign
-- row numbers to each partition to be used as a filter later.
WITH temp_tbl AS (
       SELECT id,
       first_name, 
       last_name, 
       department_id, 
       MAX(salary) OVER (partition by id) AS max_sal,
       ROW_NUMBER() OVER (partition by id) AS row_num
    FROM ms_employee_salary
    )

-- Filter out duplicate results by restricting the output to
-- just the first row of each partition
SELECT *
FROM temp_tbl
WHERE row_num = 1;