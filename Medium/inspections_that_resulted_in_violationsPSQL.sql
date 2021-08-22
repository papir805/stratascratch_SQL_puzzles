-- Inspections That Resulted In Violations

-- https://platform.stratascratch.com/coding/9728-inspections-that-resulted-in-violations

-- You're given a dataset of health inspections. 
-- Count the number of inspections that resulted 
-- in a violation for 'Roxanne Cafe' for each 
-- year. If an inspection resulted in a 
-- violation, there will be a value in the 
-- 'violation_id' column. Output the number 
-- of inspections by year in ascending order.

-- Create CTE that extracts the year from the 
-- inspection_date field to be used for grouping later.
-- Also filters results to only those that we care about,
-- only the ones for Roxanne Cafe.
WITH violations_with_year AS (
    SELECT *,
       EXTRACT(year FROM inspection_date) AS year
    FROM sf_restaurant_health_violations
    WHERE business_name = 'Roxanne Cafe'
    )

-- Group by the year field we generated earlier and
-- count the violations per year
SELECT year, COUNT(*) AS cnt
FROM violations_with_year
GROUP BY year;