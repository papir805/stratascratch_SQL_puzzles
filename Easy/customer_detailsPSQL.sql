-- Customer Details

-- https://platform.stratascratch.com/coding/9891-customer-details?python=

-- Find the details of each customer regardless of whether 
-- the customer made an order. Output the customer's first 
-- name, last name, and the city along with the order details.
-- Your output should be listing the customer's orders not 
-- necessarily listing the customers. This means that you may 
-- have duplicate rows in your results due to a customer ordering 
-- several of the same items. Sort records based on the customer's 
-- first name and the order details in ascending order.

-- Left join customers table to orders table so that all customers are included,
-- not just those that have made an order by matching customer ids. Order results
-- by first_name, then by order_details, as per the instructions.
SELECT c.first_name, c.last_name, c.city, o.order_details
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.cust_id
ORDER BY c.first_name ASC, o.order_details ASC;