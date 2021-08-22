-- Popularity Percentage

-- https://platform.stratascratch.com/coding/10284-popularity-percentage

-- Find the popularity percentage for 
-- each user on Facebook. The popularity 
-- percentage is defined as the total 
-- number of friends the user has 
-- divided by the total number of users 
-- on the platform, then converted into 
-- a percentage by multiplying by 100.
-- Output each user along with their 
-- popularity percentage. Order records 
-- in ascending order by user id.
-- The 'user1' and 'user2' column are 
-- pairs of friends.


-- Partition by user1, to find the friend counts relative
-- to the user ids in the user1 field
WITH friends1 AS (
    SELECT DISTINCT user1,
           COUNT(*) OVER (PARTITION BY user1) AS friend_cnt1
    FROM facebook_friends
    ),

-- Partition by user2, to find the friend counts relative
-- to the user ids in the user2 field
friends2 AS (
    SELECT DISTINCT user2,
           COUNT(*) OVER (PARTITION BY user2) as friend_cnt2
    FROM facebook_friends
    ),

-- Since user1 and user2 can contain duplicate user ids,
-- we use set logic and UNION to get a list of all
-- distinct user ids
user_list AS (
  SELECT DISTINCT user1 AS user_id
  FROM facebook_friends
    UNION
  SELECT DISTINCT user2 AS user_id
  FROM facebook_friends
  ),

-- Next, we use the distinct list of user ids and
-- perform a left join, where we add together the
-- friend counts for each user to achieve a the
-- total friend count for each user.  We use
-- COALESCE to change null fields to 0 so that 
-- the addition works properly.
friend_counts AS (
    SELECT user_id, 
           COALESCE(friend_cnt1, 0) + 
           COALESCE(friend_cnt2, 0) AS friend_cnt
    FROM user_list AS ul
    LEFT JOIN friends1 AS f1
    ON ul.user_id = f1.user1
    LEFT JOIN friends2 AS f2
    ON ul.user_id = f2.user2
    )

-- Lastly, calculate the popularity percent by dividing the
-- friend_cnt by the count of distinct user ids and 
-- multiplying by 100.  The division must be cast as a
-- float in order to avoid rounding issues.
SELECT user_id,
       friend_cnt / (SELECT COUNT(DISTINCT user_id) FROM user_list) :: float * 100 AS pop_percent
FROM friend_counts
ORDER BY user_id;