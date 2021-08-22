-- Number Of Bathrooms And Bedrooms

-- https://platform.stratascratch.com/coding/9622-number-of-bathrooms-and-bedrooms

-- Find the average number of bathrooms and 
-- bedrooms for each city’s property types. 
-- Output the result along with the city name 
-- and the property type.


-- Create CTE that partitions by city first, then property type
-- to find the average number of bathrooms and bedrooms in
-- each partition.  Also assigns row numbers to each partition
-- for filtering later.
WITH temp_table AS (
	SELECT city, property_type,
    AVG(bathrooms) OVER win AS avg_bathrooms,
    AVG(bedrooms) OVER win AS avg_bedrooms,
    ROW_NUMBER() OVER win AS row_num
    from airbnb_search_details
    WINDOW win AS (PARTITION BY city, property_type)
    )

-- Filter out duplicate results in each partition by using 
-- the row number.
SELECT *
FROM temp_table
WHERE row_num = 1;