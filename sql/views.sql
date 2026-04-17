CREATE VIEW churned_customers AS
SELECT *
FROM ecommerce_customer_behavior
WHERE churned = 1;

CREATE VIEW active_customers AS
SELECT *
FROM ecommerce_customer_behavior
WHERE churned = 0;