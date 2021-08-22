-- Premium vs Freemium

-- https://platform.stratascratch.com/coding/10300-premium-vs-freemium

-- Find the total number of downloads for paying 
-- and non-paying users by date. Include only 
-- records where non-paying customers have more 
-- downloads than paying customers. The output 
-- should be sorted by earliest date first and 
-- contain 3 columns date, non-paying downloads, 
-- paying downloads.


-- Start by INNER JOINING all the tables
-- together
WITH joined_tbl AS (
    SELECT ud.user_id,
           ud.acc_id,
           ad.paying_customer,
           df.date,
           df.downloads
    FROM ms_user_dimension AS ud
    INNER JOIN ms_acc_dimension AS ad
    ON ud.acc_id = ad.acc_id
    INNER JOIN ms_download_facts AS df
    ON ud.user_id = df.user_id
    ),
    
-- Use GROUP BY date and paying_customer
-- to get a total number of downloads
-- for each type of customer on each
-- day 
dl_totals AS (
    SELECT jt.date,
           jt.paying_customer,
           SUM(jt.downloads) AS tot_dl
    FROM joined_tbl AS jt
    GROUP BY date, paying_customer
    ),

-- Use CASE statements with SUM to pivot
-- the paying_customer column into a 
-- non-paying customer total and a 
-- paying customer total for each day
-- then return only the days that have 
-- a higher number of non-paying customers
-- compared to the paying customers
sum_tbl AS (
    SELECT dl.date,
            SUM(CASE
                WHEN dl.paying_customer = 'no' THEN tot_dl
                ELSE 0
                END) AS non_paying_dl,
            SUM(CASE
                WHEN dl.paying_customer = 'yes' THEN tot_dl
                ELSE 0
                END) as paying_dl
    FROM dl_totals AS dl 
    GROUP BY dl.date
    )
    
SELECT *
FROM sum_tbl AS st
WHERE non_paying_dl > paying_dl
ORDER BY st.date;