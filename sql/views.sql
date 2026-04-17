CREATE VIEW churned_customers AS
SELECT *
FROM ecommerce_customer_behavior
WHERE churned = 1;

CREATE VIEW active_customers AS
SELECT *
FROM ecommerce_customer_behavior
WHERE churned = 0;

-- Flag customers whose days_since_last_purchase is above country average
CREATE VIEW high_risk_customers AS
SELECT
    customer_id,
    country,
    days_since_last_purchase,
    ROUND(AVG(days_since_last_purchase) OVER (PARTITION BY country)::numeric, 2) AS country_avg,
    CASE
        WHEN days_since_last_purchase > AVG(days_since_last_purchase)
        OVER (PARTITION BY country) THEN 'At Risk'
        ELSE 'Normal'
    END AS risk_flag
FROM ecommerce_customer_behavior;