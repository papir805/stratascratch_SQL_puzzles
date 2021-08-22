-- Highest Energy Consumption

-- https://platform.stratascratch.com/coding/10064-highest-energy-consumption

-- Find the date with the highest total energy consumption 
-- from the Facebook data centers. Output the date along 
-- with the total energy consumption across all data centers.

-- ORIGINAL SOLUTION, but less efficient:

-- Create CTE by joining tables together.  Use a left join, starting with
-- the fb_asia_energy table as it has the 
WITH joined_tbl AS (
    SELECT asia.date,
           asia.consumption AS asia_consumption, 
           eu.consumption AS eu_consumption, 
           na.consumption AS na_consumption
    FROM fb_asia_energy AS asia
    LEFT JOIN fb_eu_energy AS eu
    ON asia.date = eu.date
    LEFT JOIN fb_na_energy AS na
    ON asia.date = na.date
    ),
    
consumption_totals AS (
    SELECT date,
           COALESCE(asia_consumption, 0) + 
           COALESCE(eu_consumption, 0) + 
           COALESCE(na_consumption, 0) AS total_consumption
    FROM joined_tbl
    )
  
SELECT date, total_consumption
FROM consumption_totals
WHERE total_consumption = (SELECT MAX(total_consumption) FROM consumption_totals);





-- NEW SOLUTION, more efficient:

WITH tbl_of_dates AS (
    SELECT date
    FROM fb_asia_energy
    UNION
    SELECT date
    FROM fb_eu_energy
    UNION
    SELECT date
    FROM fb_na_energy
    ),

tbl_consumption AS (
    SELECT tod.date,
           COALESCE(asia.consumption, 0) +
           COALESCE(eu.consumption, 0) +
           COALESCE(na.consumption, 0) AS tot_consumption
    FROM tbl_of_dates AS tod
    LEFT JOIN fb_asia_energy AS asia
    ON tod.date = asia.date
    LEFT JOIN fb_eu_energy AS eu
    ON tod.date = eu.date
    LEFT JOIN fb_na_energy AS na
    ON tod.date = na.date
    )
    
SELECT date, tot_consumption 
FROM tbl_consumption
WHERE tot_consumption = (SELECT MAX(tot_consumption) FROM tbl_consumption);