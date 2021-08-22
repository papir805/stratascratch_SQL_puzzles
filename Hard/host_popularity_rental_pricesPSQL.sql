-- Host Popularity Rental Prices

-- https://platform.stratascratch.com/coding/9632-host-popularity-rental-prices

-- You’re given a table of rental property searches 
-- by users. The table consists of search results and 
-- outputs host information for searchers. Find the 
-- minimum, average, maximum rental prices for each 
-- host’s popularity rating. The host’s popularity 
-- rating is defined as below:
--     0 reviews: New
--     1 to 5 reviews: Rising
--     6 to 15 reviews: Trending Up
--     16 to 40 reviews: Popular
--     more than 40 reviews: Hot

-- Tip: The `id` column in the table refers to the 
-- search ID. You'll need to create your own host_id 
-- by concating price, room_type, host_since, zipcode, 
-- and number_of_reviews.

-- Create a DISTINCT list of properties b/c
-- there are duplicate entries in the table
-- we're provided.
WITH distinct_tbl AS (
    SELECT DISTINCT price, 
                    property_type, 
                    room_type, 
                    amenities, 
                    host_since, 
                    number_of_reviews
    FROM airbnb_host_searches
    ),

-- Use CASE statement to assign every property 
-- a popularity rating, which will be used to 
-- GROUP BY in the next step
grouped_tbl AS (
    SELECT price,
           number_of_reviews,
        CASE
            WHEN number_of_reviews = 0 THEN 'New'
            WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'Rising'
            WHEN number_of_reviews BETWEEN 6 and 15 THEN 'Trending Up'
            WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
            WHEN number_of_reviews > 40 THEN 'Hot'
            END AS host_pop_rating
    FROM distinct_tbl
    )

-- GROUP BY host_pop_rating and 
-- find the minimum, average, and max prices
-- for each popularity rating
SELECT host_pop_rating,
      MIN(price) AS min_price,
      AVG(price) AS avg_price,
      MAX(price) AS max_price
FROM grouped_tbl
GROUP BY host_pop_rating;

