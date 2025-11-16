-- 06_incremental_gold.sql
-- Atualiza a GOLD.fact_subscriptions usando MERGE


-- 1) SOURCE


CREATE OR REPLACE TABLE gold.staging_fact AS
WITH base AS (
    SELECT
        s.subscription_id,
        s.user_id,
        s.plan_id,
        s.start_date,
        s.status,
        COALESCE(p.total_revenue, 0)          AS total_revenue,
        p.num_payments,
        p.first_payment_date,
        p.last_payment_date,
        c.cancel_date,
        cust.full_name,
        cust.gender,
        cust.birth_date,
        cust.state,
        cust.city,
        cust.region,
        cust.signup_date,
        cust.monthly_income
    FROM silver.subscriptions s
    LEFT JOIN gold.agg_payments p USING (subscription_id)
    LEFT JOIN gold.agg_cancel c USING (subscription_id)
    LEFT JOIN silver.customers cust ON s.user_id = cust.user_id
),
calc AS (
    SELECT
        *,
        COALESCE(cancel_date, DATE '2024-12-31') AS end_date,
        CASE WHEN cancel_date IS NULL AND status = 'active'
            THEN TRUE ELSE FALSE END AS is_active,
        CASE WHEN LOWER(status) = 'cancelled'
            THEN TRUE ELSE FALSE END AS is_churned,
        date_diff('day', start_date, 
            COALESCE(cancel_date, DATE '2024-12-31')) AS duration_days
    FROM base
)
SELECT
    subscription_id,
    user_id,
    full_name,
    gender,
    birth_date,
    date_diff('day', birth_date, DATE '2024-12-31') / 365.25 AS age_years,
    state,
    city,
    region,
    monthly_income,
    signup_date,
    plan_id,
    start_date,
    end_date,
    status,
    is_active,
    is_churned,
    total_revenue,
    COALESCE(num_payments, 0) AS num_payments,
    first_payment_date,
    last_payment_date,
    duration_days,
    duration_days / 30.0 AS duration_months,
    total_revenue AS ltv,
    CASE WHEN duration_days > 0
        THEN total_revenue / (duration_days / 30.0)
        ELSE 0 END AS mrr
FROM calc;

-- 2) MERGE

MERGE INTO gold.fact_subscriptions AS t
USING gold.staging_fact AS s
ON t.subscription_id = s.subscription_id

WHEN MATCHED THEN UPDATE SET
    user_id = s.user_id,
    full_name = s.full_name,
    gender = s.gender,
    birth_date = s.birth_date,
    age_years = s.age_years,
    state = s.state,
    city = s.city,
    region = s.region,
    monthly_income = s.monthly_income,
    signup_date = s.signup_date,
    plan_id = s.plan_id,
    start_date = s.start_date,
    end_date = s.end_date,
    status = s.status,
    is_active = s.is_active,
    is_churned = s.is_churned,
    total_revenue = s.total_revenue,
    num_payments = s.num_payments,
    first_payment_date = s.first_payment_date,
    last_payment_date = s.last_payment_date,
    duration_days = s.duration_days,
    duration_months = s.duration_months,
    ltv = s.ltv,
    mrr = s.mrr

WHEN NOT MATCHED THEN INSERT (
    subscription_id,
    user_id,
    full_name,
    gender,
    birth_date,
    age_years,
    state,
    city,
    region,
    monthly_income,
    signup_date,
    plan_id,
    start_date,
    end_date,
    status,
    is_active,
    is_churned,
    total_revenue,
    num_payments,
    first_payment_date,
    last_payment_date,
    duration_days,
    duration_months,
    ltv,
    mrr
)
VALUES (
    s.subscription_id,
    s.user_id,
    s.full_name,
    s.gender,
    s.birth_date,
    s.age_years,
    s.state,
    s.city,
    s.region,
    s.monthly_income,
    s.signup_date,
    s.plan_id,
    s.start_date,
    s.end_date,
    s.status,
    s.is_active,
    s.is_churned,
    s.total_revenue,
    s.num_payments,
    s.first_payment_date,
    s.last_payment_date,
    s.duration_days,
    s.duration_months,
    s.ltv,
    s.mrr
);
DROP TABLE IF EXISTS gold.staging_fact;
