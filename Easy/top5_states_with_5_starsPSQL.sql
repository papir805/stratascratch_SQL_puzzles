-- Top 5 States With 5 Star Businesses
-- https://platform.stratascratch.com/coding/10046-top-5-states-with-5-star-businesses
-- Find the top 5 states with the most 5 star businesses. 
-- Output the state name along with the number of 5-star 
-- businesses and order records by the number of 5-star businesses 
-- in descending order. In case there are two states with the same 
-- result, sort them in alphabetical order.

-- Create CTE that counts the number of 5 star restaurants exist per state
WITH grouped_tbl AS (
    select yb.state, COUNT(yb.*) AS cnt
    from yelp_business AS yb
    WHERE yb.stars = 5
    GROUP BY yb.state
    ),

-- Create new CTE which ranks states according to their count of 5 star restaurants
ranked_tbl AS (
    SELECT *,
           RANK() OVER (ORDER BY cnt DESC) AS rnk
    FROM grouped_tbl
    )

-- return only results that are in the top 5 rankings and order by
-- count, then state, as per the instructions
SELECT state, cnt
FROM ranked_tbl
WHERE rnk <= 5
ORDER BY cnt DESC, state;