-- Customer Revenue In March

-- https://platform.stratascratch.com/coding/9782-customer-revenue-in-march

-- Calculate the total revenue from each customer in March 2019. 

-- Output the revenue along with the customer id and sort the 
-- results based on the revenue in descending order.

-- MY SOLUTION USING CTEs
-- Extract the numerical value of the month for each order_date to be used
-- as a filter in the next step
WITH tbl_with_mnths AS (
      SELECT *,
      EXTRACT(month FROM order_date) AS mnth
FROM orders
)

-- Filter table to include only orders from March (where mnth=3) and
-- group by cust_id to find the SUM of a customer's orders for March
SELECT cust_id,
       SUM(total_order_cost) AS tot_rev
FROM tbl_with_mnths
WHERE mnth = 3
GROUP BY cust_id
ORDER BY tot_rev DESC;



-- MY SOLUTION USING CORRELATED SUBQUERIES

-- By using a correlated subquery, we can work row by row through the
-- orders table to filter results that include only orders which were 
-- placed in March.  We then group by cust_id and find the SUM of those
-- orders.
SELECT o1.cust_id,
       SUM(o1.total_order_cost) AS tot_rev
FROM orders AS o1
WHERE 3 = (SELECT EXTRACT(month FROM order_date)
            FROM orders AS o2 
            WHERE o2.id = o1.id)
GROUP BY o1.cust_id
ORDER BY tot_rev DESC;