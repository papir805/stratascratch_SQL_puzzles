-- Highest Cost Orders

-- https://platform.stratascratch.com/coding/9915-highest-cost-orders

-- Find the customer with the highest total 
-- order cost between 2019-02-01 to 2019-05-01. 
-- Output their first name, total cost of their items, 
-- and the date.

-- For simplicity, you can assume that every first name 
-- in the dataset is unique.



WITH filtered_orders AS (
    SELECT *
    FROM orders
    WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
    ),
    
joined_tbl AS (
    SELECT fo.cust_id,
           fo.id,
           fo.order_date,
           fo.total_order_cost,
           c.first_name,
           c.last_name,
           DENSE_RANK() OVER (ORDER BY fo.total_order_cost DESC) AS dns_rnk
    FROM filtered_orders AS fo
    INNER JOIN customers AS c
    ON fo.cust_id = c.id
    )

SELECT first_name,
       total_order_cost,
       order_date
FROM joined_tbl
WHERE dns_rnk = 1;