-- sql retail sales analysis

select * from retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or 
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or 
total_sale is null

-- how many sales do we have?
select count(*) as total_sale from retail_sales

-- how many unique customers do we have?
select count(distinct customer_id) as total_sale from retail_sales

-- category of goods present
select distinct category from retail_sales

-- business key questions and answers

-- 1. retriving all columns for sales on 2022/11/05

select * from retail_sales 
where sale_date = '2022-11-05';

-- 2. retrive all transactions where category os clothing and the quantity sold is more than 10 in the month of november in 2022

select 
* 
from retail_sales 
where 
category = 'Clothing' 
and 
format(sale_date, 'yyyy-MM') = '2022-11' 
and
quantiy >=4

-- 3. total sales for each category

select category, 
sum(total_sale) as net_sale, 
count(*) as total_orders
from retail_sales
group by category

-- 4. average age of customers who purchased items from the beauty category

select 
avg(age) as avg_age
from retail_sales
where category = 'Beauty'

-- 5. all transactions where total_sales is greater than 1000

select *
from retail_sales
where total_sale > 1000

-- 6. total number of transactions made by each gender in each category

select category,
gender,
count(*) as Totaltransactions
from retail_sales
group by category, gender
order by 1

-- 7. average sale for each month in each year. finding best selling month in each year

with sales_agg as(
select 
year (sale_date) as Years,
month (sale_date) as Months,
avg(total_sale) as avg_sale
from retail_sales 
group by year(sale_date), month(sale_date)
),

ranked_sales as(
select *,
rank() over (partition by Years order by avg_sale desc) as rank_in_year
from sales_agg
)
select *
from ranked_sales
where rank_in_year = 1
order by Years;

-- 8. top 5 customers based on the highest total sales

select top 5
customer_id, 
sum(total_sale) as total_sales
from retail_sales 
group by customer_id
order by total_sales desc;

-- 9. number of unique customers who purchased items from each category

select category, 
count(distinct(customer_id)) as unique_customer
from retail_sales
group by category

-- 10. each shift and number of orders (for morning less than 12 o clock, afternoon betwenn 12 and 17, evening at greater than 17)

with hourly_sale
as
(
select *,
case
when datepart(hour, sale_time) <12 then  'morning'
when datepart(hour, sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift
from retail_sales
)

select 
shift,
count(*) as total_orders
from hourly_sale
group by shift


