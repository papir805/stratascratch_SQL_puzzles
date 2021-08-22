-- Order Details

-- https://platform.stratascratch.com/coding/9913-order-details

-- Find order details made by Jill and Eva.
-- Consider the Jill and Eva as first names of customers.
-- Output the order date, details and cost along with the first name.
-- Order records based on the customer id in ascending order.

-- Use inner join based on unique customer_id, then filter results 
-- to only show orders where first_name is Jill or Eva and order 
-- by cust_id as per the instructions
SELECT c.first_name,
       o.order_date,
       o.order_details, 
       o.total_order_cost
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.cust_id
WHERE c.first_name IN ('Jill', 'Eva')
ORDER BY o.cust_id ASC