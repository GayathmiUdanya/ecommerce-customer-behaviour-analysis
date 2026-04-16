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