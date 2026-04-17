--Uniques countries 
SELECT DISTINCT(country)
FROM ecommerce_customer_behavior;

--The country with the highest average spending 
SELECT country, AVG(lifetime_value)
FROM ecommerce_customer_behavior
GROUP BY country
ORDER BY AVG(lifetime_value) DESC;

--Average session duration by gender
SELECT gender, ROUND(AVG(session_duration_avg)::numeric,2)
FROM ecommerce_customer_behavior
GROUP BY gender; 

--Number of churned customers
SELECT COUNT(*)
FROM ecommerce_customer_behavior
WHERE churned = 1;

--Number of churned customers by country
SELECT country, COUNT(*) as churned_customers
FROM ecommerce_customer_behavior
WHERE churned = 1
GROUP BY country;

--avg login_fequency of churned customers
SELECT ROUND(AVG(login_frequency)::numeric,2) as average_login_frequency, ROUND(AVG(membership_years)::numeric,2) as average_membership_years
FROM ecommerce_customer_behavior
WHERE churned = 1;

--avg days since last purchase for churned customers 
SELECT ROUND(AVG(days_since_last_purchase)::numeric,2) as average_days_since_last_purchase
FROM ecommerce_customer_behavior
WHERE churned = 1;


--cart_abandonment_rate of churned users 
SELECT ROUND(AVG(cart_abandonment_rate)::numeric,2) as average_cart_abandonment_rate
FROM ecommerce_customer_behavior
WHERE churned = 1;

--disount_usage_rate of churned users 
SELECT ROUND(AVG(discount_usage_rate)::numeric,2) as average_discount_usage_rate
FROM ecommerce_customer_behavior
WHERE churned = 1;

--customer_service_calls of churned users
SELECT ROUND(AVG(customer_service_calls)::numeric,2) as average_customer_service_calls
FROM ecommerce_customer_behavior
WHERE churned = 1;