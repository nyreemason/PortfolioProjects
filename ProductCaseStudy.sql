-- These queries were created for a product case study.


SELECT SUM(transaction_total) sales_total
FROM new_product.orders;


-- Calculating the total units sold
SELECT SUM(units_sold)
FROM new_product.orders;


-- Validating the units_sold dataset with the orders set
SELECT 
    SUM(units_sold) AS actual_volume,
    MONTHNAME(order_date) AS month
FROM new_product.orders
GROUP BY MONTHNAME(order_date);-- After running this query, the units_sold table has been validated


-- Compiling a quarterly sales statement. 
SELECT 
    QUARTER(order_date) AS quarter,
    COUNT(customer_id) AS num_of_customers,
    SUM(units_sold) AS units_sold,
    SUM(transaction_total) AS quarter_sales
FROM
    new_product.orders
GROUP BY quarter
ORDER BY quarter_sales DESC;


-- Finding the Top 10 customers in the U.S. YTD
SELECT 
    customer_id,
    customer_region,
    SUM(units_sold) AS total_units,
    SUM(transaction_total) AS total_sales,
    order_date,
    order_number
FROM
    new_product.orders
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;


-- Ranking the salespeople performance YTD
SELECT 
    o.sales_id,
    sp.salesperson,
    SUM(o.units_sold) AS total_units,
    SUM(o.transaction_total) AS total_sales
FROM
    new_product.orders o
        JOIN
    new_product.salesperson sp ON o.sales_id = sp.sales_id
GROUP BY o.sales_id
ORDER BY total_sales DESC;


-- Calculating the sales and number of customers by region
SELECT 
    customer_region AS region,
    COUNT(customer_id) AS num_of_customers,
    SUM(transaction_total) total_sales,
    SUM(units_sold) AS total_units
FROM
    new_product.orders
GROUP BY customer_region
ORDER BY total_sales DESC;



