-- Creating a Database--
create database rataildb;

use retaildb;

-- Creating a Table--
create table retail_sales_analysis(
		order_id VARCHAR(50) ,
        order_date	 VARCHAR(50),
        customer_id	VARCHAR(50),
        customer_name VARCHAR(100),
        age	VARCHAR(20),
        gender VARCHAR(10),
        region VARCHAR(50),
        city VARCHAR(50),
        product_category	VARCHAR(50),
        product_name	VARCHAR(50),
        quantity	VARCHAR(20),
        unit_price	VARCHAR(20),
        discount_pct	VARCHAR(20),
        sales_amount	VARCHAR(20),
        profit	VARCHAR(20),
        shipping_cost	VARCHAR(20),
        payment_method	VARCHAR(20),
        customer_satisfaction	VARCHAR(20),
        return_status	VARCHAR(10),
        order_status	VARCHAR(20),
        days_to_ship VARCHAR(20)
);

-- ---------------------------DATA CLEANING--------------------------------

-- Count Total Rows
SELECT count(*) AS Total_rows
FROM retail_sales_analysis;

-- Count Total Empty Rows--

SELECT
    SUM(
        TRIM(order_id) = '' AND
        TRIM(order_date) = '' AND
        TRIM(customer_id) = '' AND
        TRIM(customer_name) = '' AND
        TRIM(age) = '' AND
        TRIM(gender) = '' AND
        TRIM(region) = '' AND
        TRIM(city) = '' AND
        TRIM(product_category) = '' AND
        TRIM(product_name) = '' AND
        TRIM(quantity) = '' AND
        TRIM(unit_price) = '' AND
        TRIM(discount_pct) = '' AND
        TRIM(sales_amount) = '' AND
        TRIM(profit) = '' AND
        TRIM(shipping_cost) = '' AND
        TRIM(payment_method) = '' AND
        TRIM(customer_satisfaction) = '' AND
        TRIM(return_status) = '' AND
        TRIM(order_status) = '' AND
        TRIM(days_to_ship) = ''
    ) AS total_empty_rows
FROM retail_sales_analysis;

-- Deleting the Total Empty Rows---

DELETE FROM retail_sales_analysis
Where TRIM(order_id) = '' AND
        TRIM(order_date) = '' AND
        TRIM(customer_id) = '' AND
        TRIM(customer_name) = '' AND
        TRIM(age) = '' AND
        TRIM(gender) = '' AND
        TRIM(region) = '' AND
        TRIM(city) = '' AND
        TRIM(product_category) = '' AND
        TRIM(product_name) = '' AND
        TRIM(quantity) = '' AND
        TRIM(unit_price) = '' AND
        TRIM(discount_pct) = '' AND
        TRIM(sales_amount) = '' AND
        TRIM(profit) = '' AND
        TRIM(shipping_cost) = '' AND
        TRIM(payment_method) = '' AND
        TRIM(customer_satisfaction) = '' AND
        TRIM(return_status) = '' AND
        TRIM(order_status) = '' AND
        TRIM(days_to_ship) = '';
        
-- Find the  Duplicates--

SELECT order_id, COUNT(*) AS count
FROM retail_sales_analysis
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Verify the Duplicates--
SELECT *
FROM retail_sales_analysis
WHERE order_id IN (
    SELECT order_id
    FROM (
        SELECT order_id
        FROM retail_sales_analysis
        GROUP BY order_id
        HAVING COUNT(*) > 1
    ) AS t
)
ORDER BY order_id;

-- Deleting Duplicates--

 WITH cte AS (
 SELECT order_id,
           ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS rnk
    FROM retail_sales_analysis)
    DELETE FROM retail_sales_analysis
    WHERE order_id IN
    (SELECT order_id
    FROM cte
    WHERE rnk>1);
    
  -- Checking for Outliers or Suspicious Values --
  
SELECT  *
FROM retail_sales_analysis
WHERE age=' ' OR age<13 OR age>80;

SELECT *
FROM retail_sales_analysis
WHERE quantity='' OR quantity<0 OR quantity>10;

SELECT *
FROM retail_sales_analysis
WHERE discount_pct='';

SELECT *
FROM retail_sales_analysis
WHERE customer_satisfaction='';

SELECT *
FROM retail_sales_analysis
WHERE days_to_ship='' OR days_to_ship<0 OR days_to_ship>10;

SELECT  *
FROM retail_sales_analysis
where sales_amount>1000000 ;

SELECT  *
FROM retail_sales_analysis
WHERE profit > 100000 and quantity>10;

SELECT  *
FROM retail_sales_analysis
WHERE shipping_cost <0;

-- Update the empty strings (' ')  and Outliers or Suspicious Values to NULL ---

UPDATE retail_sales_analysis
SET  age= NULL
Where age='' OR age<13 OR age>80;

UPDATE retail_sales_analysis
SET  quantity= NULL
WHERE quantity='' OR quantity<0 OR quantity>10;

UPDATE retail_sales_analysis
SET  discount_pct= NULL
where discount_pct='';

UPDATE retail_sales_analysis
SET  customer_satisfaction= NULL
where customer_satisfaction='';

UPDATE retail_sales_analysis
SET  days_to_ship= Null
WHERE days_to_ship='' OR days_to_ship<0 OR days_to_ship>10;

UPDATE retail_sales_analysis
SET  shipping_cost= Null
where shipping_cost<0;

-- Change the Data Types--

ALTER TABLE retail_sales_analysis
MODIFY COLUMN age INT;

ALTER TABLE retail_sales_analysis
MODIFY COLUMN quantity INT;

ALTER TABLE retail_sales_analysis
MODIFY COLUMN unit_price DECIMAL(10,2);

ALTER TABLE retail_sales_analysis
MODIFY COLUMN discount_pct DECIMAL(2,2);

ALTER TABLE retail_sales_analysis
MODIFY COLUMN  sales_amount DECIMAL(10,2);

ALTER TABLE retail_sales_analysis
MODIFY COLUMN  profit DECIMAL(10,2);

ALTER TABLE retail_sales_analysis
MODIFY COLUMN  shipping_cost DECIMAL(5,2);

ALTER TABLE retail_sales_analysis
MODIFY COLUMN  customer_satisfaction INT;

ALTER TABLE retail_sales_analysis
MODIFY COLUMN  days_to_ship INT;


UPDATE retail_sales_analysis
SET order_date = STR_TO_DATE(order_date, '%Y/%m/%d')
WHERE order_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$';

UPDATE retail_sales_analysis
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d')
WHERE order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

UPDATE retail_sales_analysis
SET order_date = STR_TO_DATE(order_date, '%M %d, %Y')
WHERE order_date REGEXP '^[A-Za-z]+ [0-9]{2}, [0-9]{4}$';

UPDATE retail_sales_analysis
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y')
WHERE order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$';

UPDATE retail_sales_analysis
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y')
WHERE order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$';

ALTER TABLE retail_sales_analysis
MODIFY COLUMN order_date DATE;

   -- Finding Missing Values------------
    
SELECT  
		SUM(order_id is NULL) AS o_id_is_missing,
        SUM(order_date is NULL) AS o_d_is_missing,
        SUM(customer_id is NULL) AS c_id_is_missing,
        SUM(customer_name is NULL)AS c_n_is_missing,
        SUM(age is NULL) AS age_is_missing,
        SUM(gender is NULL) AS gender_is_missing,
        SUM(region is NULL) AS r_is_missing,
        SUM(city is NULL) AS city_is_missing,
        SUM(product_category is NULL) pc_is_missing,
        SUM(product_name is NULL) pn_is_missing,
        SUM(quantity is NULL) AS quantity_is_missing,
        SUM(unit_price is NULL) AS unitprice_is_missing,
        SUM(discount_pct is NULL) AS discount_is_missing,
        SUM(sales_amount is NULL) AS sales_amount_is_missing,
        SUM(profit is NULL) AS profit_is_missing,
        SUM(shipping_cost is NULL) AS shipping_is_missing,
        SUM(payment_method is NULL) AS payment_method_is_missing,
        SUM(customer_satisfaction is NULL) AS c_satisfaction_is_missing,
        SUM(return_status is NULL)AS return_flag_is_missing,
        SUM(order_status is NULL)AS order_status_is_missing,
        SUM(days_to_ship is NULL)AS days_to_ship_is_missing
FROM retail_sales_analysis;

-- Handling the Mising Values----

-- 1.Handled missing values in age column
UPDATE retail_sales_analysis
SET age = (
    SELECT avg_age
    FROM (
        SELECT ROUND(AVG(age)) AS avg_age
        FROM retail_sales_analysis
        WHERE age IS NOT NULL
    ) AS t
)
WHERE age IS NULL;

-- 2.Handled missing value in quantity Column--

UPDATE retail_sales_analysis
SET quantity = (
    SELECT avg_qty
    FROM (
        SELECT ROUND(AVG(quantity)) AS avg_qty
        FROM retail_sales_analysis
        WHERE quantity IS NOT NULL
    ) AS t
)
WHERE quantity IS NULL;

-- 3.handled the missing value in discount_price---

UPDATE retail_sales_analysis
SET discount_pct = 0
WHERE discount_pct IS NULL;

-- 4. Handled the missing value in customer_satisfaction---
UPDATE retail_sales_analysis
SET customer_satisfaction = 5
WHERE return_status = 'False'
  AND customer_satisfaction IS NULL;

UPDATE retail_sales_analysis
SET customer_satisfaction = 1
WHERE return_status = 'True'
  AND customer_satisfaction IS NULL;

-- 5.Handled the missing value in Shipping Cost---

UPDATE retail_sales_analysis
SET shipping_cost = (
    SELECT shipping_cost_
    FROM (
        SELECT ROUND(AVG(shipping_cost)) AS shipping_cost_
        FROM retail_sales_analysis
        WHERE shipping_cost IS NOT NULL
    ) AS t
)
WHERE shipping_cost IS NULL;



-- 6.Handled missing values in days to shipping--

UPDATE retail_sales_analysis
SET days_to_ship = (
    SELECT avg_days
    FROM (
        SELECT ROUND(AVG(days_to_ship)) AS avg_days
        FROM retail_sales_analysis
        WHERE days_to_ship IS NOT NULL
    ) AS t
)
WHERE days_to_ship IS NULL;

-- Handlink the Outliers--
UPDATE retail_sales_analysis
SET sales_amount = quantity * unit_price * (1 - COALESCE(discount_pct, 0))
WHERE sales_amount > 1000000; 

UPDATE retail_sales_analysis
SET profit = sales_amount * 0.18
WHERE profit > 1000000;

SELECT *
FROM retail_sales_analysis;

/*----------------------------Exploratory Data Analysis (EDA)----------------------------*/

-- PHASE-1-- Overview Retail Sales Analysis

-- What is the total sales revenue?
SELECT SUM(sales_amount) AS total_sales_revenue
FROM retail_sales_analysis;

-- What is the total profit?
SELECT SUM(profit) AS total_profit
FROM retail_sales_analysis;

-- How many orders were placed?
SELECT count(*) AS Order_delivered
FROM retail_sales_analysis
WHERE order_status='Delivered';

-- How many unique customers are there?
SELECT COUNT(DISTINCT customer_id )AS daily_customers
FROM retail_sales_analysis;

-- What is the average order value?
SELECT 
	ROUND(SUM(sales_amount) / COUNT(DISTINCT customer_id ),2) AS avg_order_value
FROM retail_sales_analysis;

-- What is the overall return rate?
SELECT
    ROUND(
        (COUNT(CASE WHEN return_status = 'True' THEN 1 END) * 100.0)
        / COUNT(*),
        2
    ) AS return_rate
FROM retail_sales_analysis;

-- Monthly Sales Trend--
SELECT  MONTH(order_date) AS `Month`,SUM(sales_amount) AS total_sales
FROM retail_sales_analysis
GROUP BY MONTH
ORDER BY MONTH;


-- Monthly Profit Trend--
SELECT  MONTH(order_date) AS `Month`,SUM(profit) AS total_profit
FROM retail_sales_analysis
GROUP BY MONTH
ORDER BY MONTH;

-- Total Sales by Region--
SELECT region,SUM(sales_amount) as Total_sales
FROM retail_sales_analysis
GROUP BY region;

-- Sales by  Product Category--
SELECT product_category,SUM(sales_amount) AS total_sales
FROM retail_sales_analysis
GROUP BY product_category;

-- Sales by   City--
SELECT city,SUM(sales_amount) AS total_sales
FROM retail_sales_analysis
GROUP BY city
LIMIT 10;

-- Order_status Distribution--
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales_analysis), 2) AS percentage
FROM retail_sales_analysis
GROUP BY order_status
ORDER BY percentage DESC;

/* ----------PHASE -- 2 : Sales Trend Analysis--------------*/

-- Monthly Sales Analysis by year
SELECT YEAR(order_date) AS ` Year`,MONTH(order_date) AS `Month`, SUM(sales_Amount) AS total_sales
FROM retail_sales_analysis
GROUP BY year,month
ORDER BY year, MONTH ASC;

-- Monthly Profit Analysis by Year---
SELECT YEAR(order_date) AS ` Year`,MONTH(order_date) AS `Month`, SUM(profit) AS total_sales
FROM retail_sales_analysis
GROUP BY year,month
ORDER BY year, MONTH ASC;

-- Monthly Orders by year--
SELECT YEAR(order_date) AS ` Year`,MONTH(order_date) AS `Month`, count(*) AS total_orders
FROM retail_sales_analysis
GROUP BY year,month
ORDER BY year, MONTH ASC;

-- Monthly sales Growth rate--
WITH MonthlySales AS (
    SELECT 
        MONTH(order_date) AS Sales_Month,
        SUM(sales_amount) AS Current_Sales
    FROM retail_sales_analysis
    GROUP BY Sales_Month
)
SELECT 
    Sales_Month,
    Current_Sales,
    LAG(Current_Sales) OVER (ORDER BY Sales_Month) AS Previous_Sales,
    (Current_Sales - LAG(Current_Sales) OVER (ORDER BY Sales_Month)) / 
     NULLIF(LAG(Current_Sales) OVER (ORDER BY Sales_Month), 0) * 100 AS Sales_Growth_Percentage
FROM MonthlySales;

/* -----------------------------PHASE--3 ------------------------------
-----Product & Category Performance-----------*/

-- Highest Sales on Product Category--
SELECT product_category,SUM(sales_amount) AS total_sales
FROM retail_sales_analysis
GROUP BY product_category;

-- Top 10 Products --
SELECT product_name,SUM(profit)
FROM retail_sales_analysis
Group by product_name;

-- Highest return rate on Products --
SELECT product_name,
    ROUND(
        (COUNT(CASE WHEN return_status = 'True' THEN 1 END) * 100.0)
        / COUNT(*),
        2
    ) AS return_rate
FROM retail_sales_analysis
Group BY product_name
ORDER BY return_rate DESC
LIMIT 10;

/* -------------PHASE-3: Customer and Regional Analysis----------*/

-- Profit and return rate on each region --
SELECT  region,SUM(profit) AS Total_profit,  ROUND(
        (COUNT(CASE WHEN return_status = 'True' THEN 1 END) * 100.0)
        / COUNT(*),
        2
    ) AS return_rate
FROM retail_sales_analysis
GROUP BY region;

-- Profit and return rate on each city;
SELECT  city,SUM(profit) AS Total_profit,  ROUND(
        (COUNT(CASE WHEN return_status = 'True' THEN 1 END) * 100.0)
        / COUNT(*),
        2
    ) AS return_rate
FROM retail_sales_analysis
GROUP BY city;

/* ------------- PHASE-4: Regional and Customer Analysis---*/

-- Which age group has more sales--
SELECT
    CASE
		WHEN age BETWEEN 13 AND 17 THEN '13-27'
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age >= 56 THEN '56+'
        ELSE 'Unknown'
    END AS age_group,
    SUM(sales_amount) AS total_sales
FROM retail_sales_analysis
GROUP BY age_group
ORDER BY total_sales DESC;

-- Purchase behaviour by gender --
SELECT
    gender,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    ROUND(
        (SUM(sales_amount) * 100.0) / SUM(SUM(sales_amount)) OVER (),
        2
    ) AS sales_percentage
FROM retail_sales_analysis
GROUP BY gender
ORDER BY sales_percentage DESC;

/* -------- PHASE-5: Operation & Performance Analysis------------*/

-- Average shipping time by Product--
SELECT product_name,round(AVG(days_to_ship)) AS days_to_ship,ROUND(avg(customer_satisfaction))
FROM retail_sales_analysis
Where return_status='True'
GROUP BY product_name;

-- Customer  Satisfaction--
SELECT
    customer_satisfaction AS rating,
    SUM(CASE
            WHEN return_status = 'True' THEN 1
            ELSE 0
        END) AS returned_products,
    SUM(CASE
            WHEN return_status = 'False' THEN 1
            ELSE 0
        END) AS not_returned_products
FROM retail_sales_analysis
GROUP BY customer_satisfaction
ORDER BY customer_satisfaction;

-- Payment Analysis--
SELECT payment_method, count(*) AS Total_count
FROM retail_sales_analysis
GROUP BY payment_method;

-- Customer_satisfaction by shipping days--
SELECT
    customer_satisfaction,
    CASE
        WHEN days_to_ship BETWEEN 0 AND 2 THEN '0-2 Days'
        WHEN days_to_ship BETWEEN 3 AND 5 THEN '3-5 Days'
        WHEN days_to_ship BETWEEN 6 AND 7 THEN '6-7 Days'
        WHEN days_to_ship BETWEEN 8 AND 10 THEN '8-10 Days'
        ELSE 'Unknown'
    END AS shipping_bin,
    COUNT(*) AS total_customers
FROM retail_sales_analysis
GROUP BY
    customer_satisfaction,
    shipping_bin
ORDER BY
    customer_satisfaction,
    shipping_bin;
