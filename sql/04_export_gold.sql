-- 04_export_gold.sql
-- EXPORT TO POWER BI

COPY gold.fact_subscriptions
TO 'data/gold/fact_subscriptions_gold.csv'
WITH (HEADER, DELIMITER ',');
