-- Monthly Percentage Difference

-- https://platform.stratascratch.com/coding/10319-monthly-percentage-difference

-- Given a table of purchases by date, 
-- calculate the month-over-month percentage 
-- change in revenue. The output should include 
-- the year-month date (YYYY-MM) and percentage 
-- change, rounded to the 2nd decimal point, and 
-- sorted from the beginning of the year to the 
-- end of the year.
-- The percentage change column will be populated 
-- from the 2nd month forward and can be calculated as 
-- ((this month's revenue - last month's revenue) / last month's revenue)*100.

-- Truncate the date to only include year and month,
-- then group by year and month to find the total
-- revenue for each.
WITH monthly_rev_tbl AS
(
         SELECT   DATE_TRUNC('month', created_at) AS year_month,
                  SUM(value)                      AS tot_rev
         FROM     sf_transactions
         GROUP BY DATE_TRUNC('month', created_at) 
         )

-- Use window functions to compute the difference between the current month
-- and the previous month.  Then round to 2 decimals and use TO_CHAR
-- function to extract just the year and month for our final output
SELECT   TO_CHAR(year_month, 'YYYY-MM')                                                          AS year_month,
         ROUND( ( (tot_rev - LAG(tot_rev, 1) OVER win) / (LAG(tot_rev, 1) OVER win) ) * 100, 2 ) AS rev_diff_pct
FROM     monthly_rev_tbl window win                                                              AS (ORDER BY year_month);