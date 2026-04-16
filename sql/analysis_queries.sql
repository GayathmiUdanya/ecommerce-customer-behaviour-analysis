SELECT age, login_frequency
FROM ecommerce_customer_behavior
WHERE age < 25
ORDER BY login_frequency ASC;