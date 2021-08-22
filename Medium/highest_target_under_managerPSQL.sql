-- Highest Target Under Manager

-- https://platform.stratascratch.com/coding/9905-highest-target-under-manager

-- Find the highest target achieved by the 
-- employee or employees who works under the 
-- manager id 13. Output the first name of 
-- the employee and target achieved. The 
-- solution should show the highest target 
-- achieved under manager_id=13 and which 
-- employee(s) achieved it.

-- Filter results down to only those
-- who have a manager_id of 13.
WITH only_mgr_13 AS (
     SELECT *
     FROM salesforce_employees
     WHERE manager_id = 13
     )

-- Use a subquery to find the maximum target
-- for the employees who have #13 as their manager.
-- Using that value, we can filter the results further
-- to find those who have a manager of #13 and have
-- the maximum target.
SELECT first_name, target
FROM only_mgr_13
WHERE target = (SELECT MAX(target) FROM only_mgr_13);
