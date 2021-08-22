-- Classify Business Type

-- https://platform.stratascratch.com/coding/9726-classify-business-type

-- Classify each business as either a restaurant, 
-- cafe, school, or other. A restaurant should have 
-- the word 'restaurant' in the business name. For 
-- cafes, either 'cafe' or 'coffee' can be in the 
-- business name. 'School' should be in the business 
-- name for schools. All other businesses should be 
-- classified as 'other'.


-- Use case statements to categorize each business
-- Note: If we don't use DISTINCT, we end up with duplicate
-- rows, as each business name may have been inspected by the health
-- department more than once and our original table will have 
-- duplicate business_names as a result.
SELECT DISTINCT business_name,
       CASE
           WHEN LOWER(business_name) LIKE '%restaurant%' THEN 'restaurant'
           WHEN LOWER(business_name) LIKE '%cafe%' THEN 'cafe' 
           WHEN LOWER(business_name) LIKE '%coffee%' THEN 'cafe'
           WHEN LOWER(business_name) LIKE '%school%' THEN 'school'
           ELSE 'other'
        END AS business_type
FROM sf_restaurant_health_violations;