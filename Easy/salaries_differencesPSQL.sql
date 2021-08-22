-- Salaries Differences 
-- (https://platform.stratascratch.com/coding/10308-salaries-differences)
-- Write a query that calculates the difference
-- between the highest salaries found in
-- the marketing and engineering departments.
-- Output just the difference in salaries.


-- CREATE CTE by joining db_employee and db_dept tables, group by department and
-- find the max salary within the marketing and engineering department
WITH joined_tbl AS (
    SELECT MAX(dbe.salary) AS max_sal,
           dbd.department
    FROM db_employee AS dbe
    INNER JOIN db_dept AS dbd
    ON dbe.department_id = dbd.id
    WHERE dbd.department = 'marketing' OR dbd.department = 'engineering'
    GROUP BY dbd.department
    )

-- Calculate the difference of the two salaries
SELECT (MAX(max_sal) - MIN(max_sal)) AS salary_difference FROM joined_tbl;