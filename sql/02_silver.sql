
-- 02_silver.sql
-- SCHEMAS SILVER + DATA MODELING

CREATE SCHEMA IF NOT EXISTS silver;

-- Customers
CREATE OR REPLACE TABLE silver.customers AS
SELECT
    CAST(user_id AS INTEGER)              AS user_id,
    full_name,
    gender,
    CAST(birth_date AS DATE)              AS birth_date,
    state,
    city,
    region,
    CAST(signup_date AS DATE)             AS signup_date,
    CAST(monthly_income AS DOUBLE)        AS monthly_income
FROM bronze.customers;

-- Subscriptions
CREATE OR REPLACE TABLE silver.subscriptions AS
SELECT
    subscription_id,
    CAST(user_id AS INTEGER)              AS user_id,
    CAST(plan_id AS INTEGER)              AS plan_id,
    CAST(start_date AS DATE)              AS start_date,
    status
FROM bronze.subscriptions;

-- Payments
CREATE OR REPLACE TABLE silver.payments AS
SELECT
    subscription_id,
    CAST(payment_date AS DATE)            AS payment_date,
    CAST(amount AS DOUBLE)                AS amount,
    CAST(plan_id AS INTEGER)              AS plan_id
FROM bronze.payments;

-- Events
CREATE OR REPLACE TABLE silver.events AS
SELECT
    subscription_id,
    event_type,
    CAST(event_date AS DATE)              AS event_date
FROM bronze.events;
