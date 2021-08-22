-- Users By Avg Session time

-- https://platform.stratascratch.com/coding/10352-users-by-avg-session-time

-- Calculate each user's average session time. 
-- A session is defined as the time difference 
-- between a page_load and page_exit. For 
-- simplicity, assume an user has only 1 session 
-- per day and if there are multiple of the same 
-- events in that day, consider only the latest 
-- page_load and earliest page_exit. Output the 
-- user_id and their average session time.


-- Filter table to only include actions we're concerned with,
-- 'page_load' and 'page_exit'
WITH only_loads_and_exits AS (
    SELECT *,
           EXTRACT(doy FROM timestamp) AS day_of_year
    FROM facebook_web_log
    WHERE action IN ('page_load', 'page_exit')
    ),

-- Use Case statement and window functions to find the MAX(timestamp), or 
-- latest page load, as well as the MIN(timestamp), which is the earliest
-- page exit.
tbl_of_max_min AS (
     SELECT user_id, 
            day_of_year, 
            action, 
            CASE
                WHEN action = 'page_load' THEN MAX(timestamp) OVER win 
                WHEN action = 'page_exit' THEN MIN(timestamp) OVER win
            END as important_time_stamp
FROM only_loads_and_exits
WINDOW win AS (PARTITION BY user_id, day_of_year, action ORDER BY day_of_year)
),

-- For a given user_id and day_of year, find the time difference between their page_exit 
-- and page_load.  Need to use EXTRACT so that the time difference is an integer and not
-- an interval as it will affect the next part of the query
tbl_of_time_diffs AS (
    SELECT user_id,
           EXTRACT(epoch FROM MAX(important_time_stamp) - MIN(important_time_stamp)) AS time_diff
    FROM tbl_of_max_min
    GROUP BY user_id, day_of_year
    )
   
-- Calculate a users average session time, filtering to include only results that are
-- larger than 0.  The comparison in the HAVING clause only works because time_diff
-- was cast to an integer in the step above, otherwise the comparison would cause an error
-- as you can't compare an interval against an integer.
SELECT user_id,
      AVG(time_diff) AS avg_session
FROM tbl_of_time_diffs
GROUP BY user_id
HAVING AVG(time_diff) > 0
ORDER BY user_id;