-- Top Cool Votes

-- https://platform.stratascratch.com/coding/10060-top-cool-votes

-- Find the business and the review_text that received 
-- the highest number of  'cool' votes.
-- Output the business name along with the review text.

-- Use subquery to find the MAX # of cool votes, then
-- filter to show only the business_name and review_text
-- with that maximum number of cool votes.
SELECT business_name,
       review_text
FROM yelp_reviews
WHERE cool = (SELECT MAX(cool) FROM yelp_reviews)