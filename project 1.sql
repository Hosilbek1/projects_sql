-- Created database and uploaded the the table in ssms 
-- going to start with data exploration and cleaning 
--1. just have a look at the dataset 
SELECT * FROM retail_sales;

--2. identify total number of the records in the dataset 
SELECT COUNT(*) FROM retail_sales;

--3. identify how many unique customers are in the dataset 
SELECT COUNT(DISTINCT customer_id) FROM retail_sales

--4. identify all the unique categories 
SELECT DISTINCT category FROM retail_sales;

--5.check the null values in the dataset
SELECT * FROM retail_sales
where 
      sale_date IS NULL OR 
	  sale_time IS NULL OR 
	  customer_id IS NULL OR 
	  gender IS NULL OR 
	  age IS NULL OR 
	  category IS NULL OR 
	  quantiy IS NULL OR 
	  price_per_unit IS NULL OR 
	  cogs IS NULL;
--6. dealing with the null values 
-- using average age instead of null values but as for other parts i am going to delete them 
WITH avg_age as ( 
   SELECT avg(age) as avg_age1
   FROM 
   retail_sales
)
 UPDATE retail_sales
 SET age=(SELECT avg_age1 FROM avg_age) 
 where age IS NULL;

 DELETE FROM retail_sales
 where 
          sale_date IS NULL OR 
	  sale_time IS NULL OR 
	  customer_id IS NULL OR 
	  gender IS NULL OR 
	  age IS NULL OR 
	  category IS NULL OR 
	  quantiy IS NULL OR 
	  price_per_unit IS NULL OR 
	  cogs IS NULL;

--7. we have cleaned the dataset and now we are going to answer some business questions 
--Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';

--Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retail_sales
WHERE category='Clothing' AND 
      sale_date BETWEEN '2022-11-01' AND '2022-11-30'
	  AND quantiy>=4;

--Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category, avg(age) FROM 
retail_sales
where category='Beauty'
group by category;

--Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale>1000;

--Q6 Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category
SELECT gender, count(transactions_id)
from retail_sales
group by gender

--Q6 Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year:
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    YEAR (sale_date) as year,
    MONTH (sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY YEAR (sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year(sale_date), month(sale_date)
) as t1
WHERE rank = 1

--Q7 **Write a SQL query to find the top 5 customers based on the highest total sales **:
select Top 10 customer_id, sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc 


-- Q8 Write a SQL query to find 
-- the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--Q9 Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;







