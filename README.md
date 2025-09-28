# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis
**Level**: Beginner
**Database**: `Retail_sales_analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze **retail sales data**. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

-----

## Objectives

1.  **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2.  **Data Cleaning**: Identify and remove any records with missing or null values.
3.  **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset, including counts of total sales, unique customers, and distinct categories.
4.  **Business Analysis**: Use SQL to answer specific business questions and derive insights into customer behavior and sales trends.

-----

## Project Structure

### 1\. Database Setup

  - **Database Creation**: The project starts by creating a table (assuming the database is already created or will be named after the table/project).
  - **Table Creation**: A table named `Retail_sales_analysis` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

<!-- end list -->

```sql
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
```

### 2\. Data Exploration & Cleaning

  - **Record Count**: Determine the total number of records in the dataset.
  - **Customer Count**: Find out how many unique customers are in the dataset.
  - **Category Count**: Identify all unique product categories in the dataset.
  - **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

<!-- end list -->

```sql
-- COUNTTING THE number of rows
SELECT
     COUNT(*)
FROM Retail_sales_analysis

-- DATA CLEANING: Identifying and Deleting Nulls
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
```

-----

### 3\. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1.  **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**:

<!-- end list -->

```sql
SELECT *
FROM Retail_sales_analysis
WHERE sale_date ='2022-11-05';
```

2.  **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

<!-- end list -->

```sql
SELECT *
FROM Retail_sales_analysis
WHERE category='Clothing'
AND
quantiy >='4' 
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
```

3.  **Write a SQL query to calculate the total sales (total\_sale) for each category.**:

<!-- end list -->

```sql
SELECT 
    category,
	SUM(total_sale) as net_sale,
	COUNT (*) as total_orders
	FROM Retail_sales_analysis
	GROUP BY 1
```

4.  **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:

<!-- end list -->

```sql
SELECT 
    ROUND(AVG (age),2) as avg_age_beauty
	FROM Retail_sales_analysis
	WHERE category='Beauty'
```

5.  **Write a SQL query to find all transactions where the total\_sale is greater than 1000.**:

<!-- end list -->

```sql
SELECT * FROM Retail_sales_analysis
   WHERE total_sale>1000
```

6.  **Write a SQL query to find the total number of transactions (transaction\_id) made by each gender in each category.**:

<!-- end list -->

```sql
SELECT 
      category,
	  gender,
	  COUNT (*) as total_trans
	 FROM Retail_sales_analysis
	 GROUP 
	 BY 
	  category,
	  gender
```

7.  **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

<!-- end list -->

```sql
SELECT * FROM 
(
SELECT 
      EXTRACT (YEAR FROM sale_date) as year,
	    EXTRACT (MONTH FROM sale_date) as month,
       AVG(total_sale) as avg_total_sales,
	   RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY  AVG(total_sale) DESC) as rank 
FROM  Retail_sales_analysis
GROUP BY 1,2
) as t1
WHERE rank =1
```

8.  **Write a SQL query to find the top 5 customers based on the highest total sales**:

<!-- end list -->

```sql
   SELECT
         customer_id,
		 SUM(total_sale) as total_cust
         FROM  Retail_sales_analysis
		 GROUP BY 1 
            ORDER BY 2 DESC
		 LIMIT 5
```

9.  **Write a SQL query to find the number of unique customers who purchased items from each category.**:

<!-- end list -->

```sql
    SELECT 
	 category,
	COUNT ( DISTINCT customer_id) AS cnt_unique_cus
	    FROM  Retail_sales_analysis
   GROUP BY 1
```

10. **Write a SQL query to create each shift and number of orders (Example Morning \<=12, Afternoon Between 12 & 17, Evening \>=17)**:

<!-- end list -->

```sql
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
```

-----

## Findings

  - **Customer Demographics**: The analysis includes a count of male customers and the average age of customers purchasing from the 'Beauty' category.
  - **High-Value Transactions**: The project identified transactions with a total sale amount greater than 1000, indicating premium or bulk purchases.
  - **Sales Trends**: **Window functions (RANK())** were used to identify the **best-selling month** in terms of average sales for each year, which is crucial for identifying peak seasons.
  - **Customer Insights**: The analysis identifies the **top 5-spending customers** and the unique customer count per category, helping to profile and target high-value customers.
  - **Operational Insights**: Sales are segmented by time of day (**Morning, Afternoon, Evening**) to understand peak operational load and staffing needs.

-----

## Reports

  - **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
  - **Trend Analysis**: Insights into sales trends across different months and shifts.
  - **Customer Insights**: Reports on top customers and unique customer counts per category.

-----

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance across different categories and time periods.

## How to Use

1.  **Clone the Repository**: Clone this project repository from GitHub.
2.  **Set Up the Database**: Run the SQL scripts provided in the `RETAIL SALES SQL ANALYSIS PROJECT.sql` file to create the table and run the analysis.
3.  **Run the Queries**: Use the SQL queries provided in the file to perform your analysis.
4.  **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

