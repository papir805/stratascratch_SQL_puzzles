-- Popularity of Hack

-- https://platform.stratascratch.com/coding/10061-popularity-of-hack

-- Facebook has developed a new programing language called Hack.
-- To measure the popularity of Hack they ran a survey with their employees. 
-- The survey included data on previous programing familiarity as well as
-- the number of years of experience, age, gender and most importantly 
-- satisfaction with Hack. Due to an error location data was not collected, 
-- but your supervisor demands a report showing average popularity of Hack by 
-- office location. Luckily the user IDs of employees completing the surveys were 
-- stored.  Based on the above, find the average popularity of the Hack per 
-- office location. Output the location along with the average popularity.

-- Create CTE that joins together the table containing the results of the survey with
-- with the table on facebook. Use a left join so that we only consider employees
-- who actually took the survey.  Partition by location to find the average popularity
-- for each location.  Assign row number to be used in later filtering.
WITH joined_tbl AS (
    SELECT id,
           location,
           AVG(popularity) OVER win AS avg_popularity,
           ROW_NUMBER() OVER win AS row_num
    FROM facebook_hack_survey AS fb_hs
    LEFT JOIN facebook_employees AS fb_e
    ON fb_e.id = fb_hs.employee_id
    WINDOW win AS (PARTITION BY location)
    )
    

SELECT location, avg_popularity
FROM joined_tbl
WHERE row_num = 1;