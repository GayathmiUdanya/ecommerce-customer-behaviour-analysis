--Overall churn rate 
SELECT 
    (SELECT COUNT(*) FROM churned_customers) * 100.0 / (SELECT COUNT(*) FROM ecommerce_customer_behavior) AS churn_rate_percentage;

--Churn rate by country 
SELECT 
    country,
    COUNT(*) AS total_customers,
    SUM(churned) AS churned_customers,
    (SUM(churned) * 100.0 / COUNT(*)) AS churn_rate_percentage
FROM ecommerce_customer_behavior
GROUP BY country
ORDER BY churn_rate_percentage DESC;

--Churn rate by age group
SELECT 
    CASE 
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(churned) AS churned_customers,
    (SUM(churned) * 100.0 / COUNT(*)) AS churn_rate_percentage
FROM ecommerce_customer_behavior
GROUP BY age_group
ORDER BY churn_rate_percentage DESC;

--avg behavior
SELECT 
    CASE WHEN churned = 1 THEN 'Churned' ELSE 'Active' END AS customer_status,
    ROUND(AVG(login_frequency)::numeric,2) AS avg_logins,
    ROUND(AVG(session_duration_avg)::numeric,2) AS avg_session_duration,
    ROUND(AVG(cart_abandonment_rate)::numeric,2) AS avg_cart_abandonment_rate,
    ROUND(AVG(email_open_rate)::numeric,2) AS avg_email_open_rate,
    ROUND(AVG(mobile_app_usage)::numeric,2) AS avg_mobile_app_usage
FROM ecommerce_customer_behavior
GROUP BY customer_status;

-- Do more customer service calls predict churn?
SELECT
    CASE WHEN churned = 1 THEN 'Churned' ELSE 'Active' END AS segment,
    ROUND(AVG(customer_service_calls)::numeric, 2) AS avg_support_calls,
    ROUND(AVG(returns_rate)::numeric, 2) AS avg_returns
FROM ecommerce_customer_behavior
GROUP BY churned;


-- LTV comparison: churned vs active
SELECT
    CASE WHEN churned = 1 THEN 'Churned' ELSE 'Active' END AS segment,
    ROUND(AVG(lifetime_value)::numeric, 2) AS avg_ltv,
    ROUND(AVG(average_order_value)::numeric, 2) AS avg_order_value,
    ROUND(AVG(total_purchases)::numeric, 2) AS avg_purchases
FROM ecommerce_customer_behavior
GROUP BY churned;

-- High value customers who still churned (at risk segment)
SELECT
    age_group,
    COUNT(*) AS total,
    ROUND(100.0 * SUM(churned) / COUNT(*)::numeric, 2) AS churn_rate_pct
FROM (
    SELECT
        churned,
        CASE
            WHEN age < 25 THEN 'Under 25'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group
    FROM ecommerce_customer_behavior
) AS age_segments
GROUP BY age_group
ORDER BY churn_rate_pct DESC;


-- Did discounts prevent churn?
SELECT
    CASE WHEN churned = 1 THEN 'Churned' ELSE 'Active' END AS segment,
    ROUND(AVG(discount_usage_rate)::numeric, 2) AS avg_discount_usage,
    ROUND(AVG(membership_years)::numeric, 2) AS avg_membership_years
FROM ecommerce_customer_behavior
GROUP BY churned;


-- Rank customers by LTV within each country
SELECT
    customer_id,
    country,
    city,
    lifetime_value,
    RANK() OVER (PARTITION BY country ORDER BY lifetime_value DESC) AS ltv_rank
FROM ecommerce_customer_behavior;

-- Flag customers whose days_since_last_purchase is above country average
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