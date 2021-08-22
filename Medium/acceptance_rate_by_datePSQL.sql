-- Acceptance Rate By Date

-- https://platform.stratascratch.com/coding/10285-acceptance-rate-by-date

-- What is the overall friend acceptance rate by date? 
-- Your output should have the rate of acceptances by the 
-- date the request was sent. Order by the earliest date to 
-- latest.

-- Assume that each friend request starts by a user sending 
-- (i.e., user_id_sender) a friend request to another user 
-- (i.e., user_id_receiver) that's logged in the table with 
-- action = 'sent'. If the request is accepted, the table logs 
-- action = 'accepted'. If the request is not accepted, no 
-- record of action = 'accepted' is logged.


-- Create CTE using a left self join. I use the left join
-- to ensure all actions from the original table are matched
-- with the correct actions that occur on a later date. To prevent 
-- duplicate entries involving the same users, we set the condition that 
-- the  actions must be different.
WITH joined_tbl AS (
SELECT fb1.date AS date1,
       fb2.date AS date2,
       fb1.action AS action1,
       fb2.action AS action2
FROM fb_friend_requests AS fb1
LEFT JOIN fb_friend_requests AS fb2
ON fb1.user_id_sender = fb2.user_id_sender
AND fb1.user_id_receiver = fb2.user_id_receiver
AND fb1.action != fb2.action
AND fb2.date >= fb1.date
),

-- Partition by the original date, from the left table in the left
-- join that occurred above, then use case statements to count the total 
-- number of accepted requests by day, as well as the total number of
-- sent requests by day.
count_table AS (
    SELECT t.date1,
          SUM(
                CASE 
                    WHEN t.action2 = 'accepted' THEN 1
                    ELSE 0
                END
              ) OVER win AS accepted_count, 
            SUM(
                CASE
                    WHEN t.action1 = 'sent' THEN 1
                    ELSE 0
                END
              ) OVER win AS sent_count
    FROM joined_tbl AS t
    WINDOW win AS (PARTITION BY t.date1)
    )

-- To prevent division by 0, we filter out rows that have a sent_count = 0.
-- We then return the acceptance rate and use distinct to prevent duplicate rows.
-- Need to cast acceptance rate as a float so that we don't encouter rounding
-- issues.  Acceptance rate is defined as the number of accepted requests out 
-- of the number of sent requests.
SELECT DISTINCT date1,
       accepted_count/sent_count :: float AS acceptance_rate
FROM count_table
WHERE tot_count != 0 
ORDER BY date1;