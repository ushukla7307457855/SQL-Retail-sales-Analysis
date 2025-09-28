DROP TABLE IF EXISTS Retail_sales_analysis;
--creating a new table
CREATE TABLE Retail_sales_analysis
               (
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time	TIME,
customer_id	INT,
gender VARCHAR(20),
age INT,
category VARCHAR(20),
quantiy INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale  FLOAT
);

SELECT*FROM  Retail_sales_analysis;

-- COUNTTING THE number of rows 
SELECT 
     COUNT(*)
FROM Retail_sales_analysis
-- counting the number null values in each column

--DATA CLEANING
SELECT*FROM  Retail_sales_analysis
WHERE transactions_id is NULL
       OR 
       sale_date is NULL
       OR
	   sale_time is NULL
	   OR
	   customer_id is NULL
	   OR
	   gender is NULL
	   OR
	   age is NULL
	   OR
	   quantiy is NULL
	   OR
	   price_per_unit is NULL
	   OR
	   cogs is NULL
	   OR
	   total_sale is NULL;

	  DELETE FROM Retail_sales_analysis
	   WHERE transactions_id is NULL
       OR 
       sale_date is NULL
       OR
	   sale_time is NULL
	   OR
	   customer_id is NULL
	   OR
	   gender is NULL
	   OR
	   age is NULL
	   OR
	   quantiy is NULL
	   OR
	   price_per_unit is NULL
	   OR
	   cogs is NULL
	   OR
	   total_sale is NULL;


-- DATA EXPLORATION

--how mauch total sales we have
SELECT COUNT(*) as total_sales FROM  Retail_sales_analysis  

--How much total distinct  customer id we have?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM  Retail_sales_analysis 

--HOW MANY DISTINCT CATEGORY WE HAVE?
SELECT DISTINCT category FROM Retail_sales_analysis

--how many males ?
SELECT  COUNT(*) as males_count 
 FROM Retail_sales_analysis
 WHERE gender='Male'

 -- What max price per unit and category wise in descending order?
SELECT MAX(price_per_unit) as max_price
FROM Retail_sales_analysis
GROUP BY category
ORDER BY
max_price DESC;

--Data analysis &key business problems 

--Q1 write a whole sql query to retrieve all the COLUMNNS For THE sales made on 2022-11-05?
SELECT *
FROM Retail_sales_analysis
WHERE sale_date ='2022-11-05';

--Q2 Write a SQL query to retrive all the tansanctions where  category is clothing and
--the qunatity sold is more than 4 in the month of NOV 2022

SELECT *
FROM Retail_sales_analysis
WHERE category='Clothing'
AND
quantiy >='4' 
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11'

--Q3 WRITE  A SQL QUERY TO CALCULATE TOTAL SALES (total_sales) of each category?

SELECT 
    category,
	SUM(total_sale) as net_sale,
	COUNT (*) as total_orders
	FROM Retail_sales_analysis
	GROUP BY 1
-- Q4 WRITE  A SQL QUERY TO FIND THE AVG AGE OF CUSTOMERS THAT PURHASE FROM CATEGROY  'BEAUTY'?

SELECT 
    ROUND(AVG (age),2) as avg_age_beauty
	FROM Retail_sales_analysis
	WHERE category='Beauty'

--Q5 WRITE  A SQL QUERY TO FIND ALL THE TRANSACTONS WHERE THE TOTAL SALES IS GREATER THAN 1000?
SELECT * FROM Retail_sales_analysis
   WHERE total_sale>1000

--Q6 WRITE A SQL QUERY TO FIND THE total number of TRANSACTIONS(TRANSACTOIN _ID) DONE BY EACH GENDER OF EACH CATEGORY ?
SELECT 
      category,
	  gender,
	  COUNT (*) as total_trans
	 FROM Retail_sales_analysis
	 GROUP 
	 BY 
	  category,
	  gender

--Q7 WRITE THE SQL QUERY O CALCULATE THE AVG SALES FOR EACH MONTH .FIND OUT THE BEST SELLING MONTH

SELECT * FROM 
(
SELECT 
      EXTRACT (YEAR FROM sale_date) as year,
	    EXTRACT (MONTH FROM sale_date) as month,
       AVG(total_sale) as avg_total_sales,
	   RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY  AVG(total_sale) DESC) as rank 
	   -- THIS LINE DIVIDE THE YEAR AND CREAET A RANK ORDER OF AVG SALES IN A DEESCENCNDG ORDER
FROM  Retail_sales_analysis
GROUP BY 1,2
) as t1
WHERE rank =1
--ORDER BY 1,3 DESC --DESCENDING ORDER IN ORDER A TO GET THE HIGHEST NUMBER OF SALES BY YEAR


-- Q8 WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED  ON HIGHEST SALES.
   SELECT
         customer_id,
		 SUM(total_sale) as total_cust
         FROM  retail_sales_analysis
		 GROUP BY 1 
            ORDER BY 2 DESC
		 LIMIT 5
      
--Q9 WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS IN EACH CATEGORY
    SELECT 
	 category,
	COUNT ( DISTINCT customer_id) AS cnt_unique_cus
	    FROM  Retail_sales_analysis
   GROUP BY 1


--Q10  WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS(MORNNING<=12,AFTER NOON 12-17& EVENING >=17)
WITH hourly_sales
as
(
SELECT *,
       CASE 
	       WHEN EXTRACT (HOUR FROM sale_time)<=12 THEN 'morning'
		   WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	       ELSE 'evening'
      END as shift
	 FROM Retail_sales_analysis
	 )
     SELECT  shift,
	    COUNT(*)
		 FROM hourly_sales
	   GROUP BY shift