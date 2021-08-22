-- Workers With The Highest Salaries

-- https://platform.stratascratch.com/coding/10353-workers-with-the-highest-salaries

-- Find the titles of workers that earn 
-- the highest salaries. Output the 
-- highest-paid titles.

-- Join the worker and title table to access each worker's
-- title, then use window function to rank employees by 
-- salary.
WITH ranked_tbl AS (
    SELECT w.worker_id,
           w.first_name,
           w.last_name,
           w.salary,
           t.worker_title,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_r
    FROM worker AS w
    INNER JOIN title AS t
    ON w.worker_id = t.worker_ref_id
    )

-- Filter results to only include the highest ranked salaries
SELECT worker_title, salary
FROM ranked_tbl
WHERE dense_r = 1;