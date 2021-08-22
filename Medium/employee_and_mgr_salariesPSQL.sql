-- Employee and Manager Salaries

-- https://platform.stratascratch.com/coding/9894-employee-and-manager-salaries

-- Find employees who are earning more than their 
-- managers. Output the employee name along with 
-- the corresponding salary.

-- Use self join to match employees with their manager
-- and give the columns aliases with some context to
-- be used later
WITH joined_tbl AS (
    SELECT e1.id AS mgr_id,
      e1.first_name AS mgr_first_name,
      e1.last_name AS mgr_last_name,
      e1.salary AS mgr_sal,
      e1.manager_id AS mgr_manager_id,
      e2.id AS sub_id,
      e2.first_name AS sub_first_name,
      e2.last_name AS sub_last_name,
      e2.salary AS sub_sal
    FROM employee AS e1
    INNER JOIN employee AS e2
    ON e1.id = e2.manager_id
    )

-- Filter results to only include those where
-- a subordinate's salary is larger than their
-- manager's salary.
SELECT sub_first_name,
       sub_sal
FROM joined_tbl
WHERE sub_sal > mgr_sal;