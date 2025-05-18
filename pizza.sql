
-- First of all, create a New Database name pizza_sales

create database pizza_sales
use pizza_sales;

-- Import data into the database using "Table Data Import Wizard"

-- Preview the Data

select 
	* 
	from pizza_sales 
limit 10;

-- Total Revenue

select 
	round(sum(total_price)) as Total_Revenue 
from pizza_sales;

-- Avg order value

select 
	round(sum(total_price)/ count(distinct order_id),2) as Avg_order_value 
from pizza_sales;

-- total Pizza sold

select 
	sum(quantity) as Total_Pizza_Sold 
from pizza_sales;

-- total orders

select 
	count(distinct order_id) as Total_Orders 
from pizza_sales;

-- Avg pizza per order

select 
	round(sum(quantity)/ count(distinct order_id),2) as Avg_Pizza_per_order 
from pizza_sales;

-- Daily trend for total orders

select 
  dayname(
    case
      when order_date like '%/%' then str_to_date(order_date, '%d/%m/%y')
      when order_date like '%-%' then str_to_date(order_date, '%d-%m-%y')
      else null
    end
  ) as Day_Name,
  count(distinct order_id) as total_orders
from pizza_sales
group by 1 
order by 2 desc;

-- Monthly trend for total orders

select 
  monthname(
    case
      when order_date like '%/%' then str_to_date(order_date, '%d/%m/%y')
      when order_date like '%-%' then str_to_date(order_date, '%d-%m-%y')
      else null
    end
  ) as Month_Name,
  count(distinct order_id) as total_orders
from pizza_sales
group by 1 
order by 2 desc;

-- % of sales by pizza category

select
Pizza_category as Category,
	round(sum(total_price)) as Total_Revenue,
	round(sum(total_price)*100/ (select sum(total_price) from pizza_sales),2) as PCT
from pizza_sales
group by 1;

-- % of sales by pizza size

select
Pizza_size as Size,
	round(sum(total_price)) as Total_Revenue,
	round(sum(total_price)*100/ (select sum(total_price) from pizza_sales),2) as PCT
from pizza_sales
group by 1;


-- total pizza sold by pizza category

select
	pizza_category as Category,
    sum(quantity) as total_quantity_sold
from pizza_sales
group by 1;

-- top 5 pizza by revenue

select 
	pizza_name,
    round(sum(total_price)) as total_revenue
from pizza_sales
group by 1
order by 2 desc
limit 5;

-- Bottom 5 pizza by revenue

select 
	pizza_name,
    round(sum(total_price)) as total_revenue
from pizza_sales
group by 1
order by 2
limit 5;

-- top 5 pizza by quantity using window function

select
	pizza_name,
    sum(quantity) as Toatl_Pizza_Sold,
    rank() over ( order by sum(quantity) desc) as rank_no
from pizza_sales
group by 1
limit 5;

-- Bottom 5 pizza by quantity using window function and CTE

with ranked_pizzas as
(
select
	pizza_name,
    sum(quantity) as Toatl_Pizza_Sold,
    rank() over ( order by sum(quantity) asc) as rank_no
from pizza_sales
group by 1)

select * from ranked_pizzas
where rank_no <= 5;

-- top 5 pizza by total orders using window function and CTE

with ranked_pizzas as
(
select
	pizza_name,
    count(distinct order_id) as Toatl_Orders,
    rank() over ( order by count(distinct order_id) desc) as rank_no
from pizza_sales
group by 1)

select * from ranked_pizzas
where rank_no <= 5;

-- Bottom 5 pizza by total orders using window function and CTE

with ranked_pizzas as
(
select
	pizza_name,
    count(distinct order_id) as Toatl_Orders,
    row_number() over ( order by count(distinct order_id) asc) as rank_no
from pizza_sales
group by 1)

select * from ranked_pizzas
where rank_no <= 5;