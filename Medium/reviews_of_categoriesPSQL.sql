-- Reviews of Categories

-- https://platform.stratascratch.com/coding/10049-reviews-of-categories

-- Find the top business categories 
-- based on the total number of reviews. 
-- Output the category along with the 
-- total number of reviews. Order by 
-- total reviews in descending order.

-- Use STRING_TO_ARRAY to split the categories column
-- into an array based on a delimiter.  Then use UNNEST
-- to split the array into multiple rows.  The end 
-- result will show the business_id and each individual 
-- category that business_id falls under.
WITH split_tbl AS (
    SELECT business_id, 
           review_count,
           UNNEST(STRING_TO_ARRAY(categories, ';')) AS individual_categories
    FROM yelp_business
    )

-- GROUP BY individual_categories
-- and SUM the review_counts to generate
-- the total number of reviews for each category
SELECT individual_categories,
       SUM(review_count) AS review_cnt
FROM split_tbl
GROUP BY individual_categories
ORDER BY review_cnt DESC;