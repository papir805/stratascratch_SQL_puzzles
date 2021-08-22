-- Finding User Purchases

-- https://platform.stratascratch.com/coding/10322-finding-user-purchases

-- Write a query that'll identify returning active 
-- users. A returning active user is a user that 
-- has made a second purchase within 7 days of any 
-- other of their purchases. Output a list of 
-- user_ids of these returning active users.

-- Use LAG window functions to calculate the difference in days between a user's
-- consecutive purchases by partitioning by user_id
WITH tbl_of_diffs AS (
       SELECT *,
       created_at - LAG(created_at, 1) OVER win AS day_diff
FROM amazon_transactions
WINDOW win AS (PARTITION BY user_ID ORDER BY created_at)
   ),

-- Create boolean condition that is TRUE when the day_diff column has a value <= 7,
-- indicating a purchase within 7 days of a prior purchase.
tbl_of_bools AS (
   SELECT *,
   day_diff <= 7 AS within_7_days
   FROM tbl_of_diffs
   )

-- Return the distinct set of user_ids that have a TRUE within_7_days boolean condition
SELECT DISTINCT user_id
FROM tbl_of_bools
WHERE within_7_days IS TRUE
ORDER BY user_id;