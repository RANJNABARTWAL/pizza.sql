-- calculate the total revenue generated from pizza sales
select
 sum(order_details.quantity * pizzas.price) as total_sales 
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id ;

-- idenitfy the highest priced pizza
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1; 

-- identify the most common pizza size ordered
select pizzas.size, count( order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

-- list 5 most ordered pizzas types along with their qty

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity DESC limit 5;

-- join the necessary tables to find the total qty of each pizza categpry ordered
select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category order by quantity desc;

-- distribution based on hours 
select hour(order_time),
count(order_id) from orders 
group by hour(order_time);

--  join the relevant table for category wise distribution 
select pizza_types.category,
count(name) from pizza_types
group by category;

-- group the order by date and calculate the avg no. of pizza ordered in a day 
select avg (quantity) as avg_pizza_per_day from
(select orders.order_date,
sum(order_details.quantity) as quantity from 
orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;

-- calculate the top 5 most ordered pizza ordered as per revenue
select pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
  on order_details.pizza_id = pizzas.pizza_id
  group by pizza_types.name
  order by revenue 
  desc limit 5;
  
  -- calculate the percentage contribution of each pizza types to total revenue 
  select pizza_types.category, 
  round(sum(order_details.quantity*pizzas.price)/
  (select sum( order_details.quantity*pizzas.price)
  from order_details
  join pizzas on pizzas.pizza_id = order_details.pizza_id)*100,2) as revenue
 from pizza_types join pizzas
 on pizzas.pizza_type_id = pizza_types.pizza_type_id
  join order_details
  on order_details.pizza_id = pizzas.pizza_id
  group by pizza_types.category order by revenue desc;
  
  -- analyze the cumulative revenue generated overtime 
 select order_date,
 sum(revenue) over(order by order_date) as cum_revenue
 from 
 (select orders.order_date, 
  sum(order_details.quantity*pizzas.price) as revenue 
  from order_details join pizzas
  on order_details.pizza_id = pizzas.pizza_id
  join orders
 on orders.order_id = order_details.order_id
 group by orders.order_date)  as sales;
 
 
  