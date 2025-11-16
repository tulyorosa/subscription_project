-- 03_gold.sql
-- Cria a camada GOLD de assinaturas

-- 1) Garante o schema gold
CREATE SCHEMA IF NOT EXISTS gold;

-- 2) Agregação de pagamentos por assinatura
CREATE OR REPLACE TABLE gold.agg_payments AS
SELECT
    subscription_id,
    SUM(amount)                     AS total_revenue,
    COUNT(*)                        AS num_payments,
    MIN(payment_date)               AS first_payment_date,
    MAX(payment_date)               AS last_payment_date
FROM silver.payments
GROUP BY subscription_id;

-- 3) Data de cancelamento por assinatura (se existir)
CREATE OR REPLACE TABLE gold.agg_cancel AS
SELECT
    subscription_id,
    MIN(event_date)                 AS cancel_date
FROM silver.events
WHERE event_type = 'cancelled'
GROUP BY subscription_id;

-- 4) Base de assinaturas juntando subscriptions + pagamentos + cancel
CREATE OR REPLACE TABLE gold.base_subscriptions AS
SELECT
    s.subscription_id,
    s.user_id,
    s.plan_id,
    s.start_date,
    s.status,
    p.total_revenue,
    p.num_payments,
    p.first_payment_date,
    p.last_payment_date,
    c.cancel_date
FROM silver.subscriptions s
LEFT JOIN gold.agg_payments p
       ON s.subscription_id = p.subscription_id
LEFT JOIN gold.agg_cancel c
       ON s.subscription_id = c.subscription_id;

-- 5) Fact final com dados de cliente e métricas
CREATE OR REPLACE TABLE gold.fact_subscriptions AS
WITH base AS (
    SELECT
        b.subscription_id,
        b.user_id,
        b.plan_id,
        b.start_date,
        b.status,
        COALESCE(b.total_revenue, 0)          AS total_revenue,
        b.num_payments,
        b.first_payment_date,
        b.last_payment_date,
        b.cancel_date,
        c.full_name,
        c.gender,
        c.birth_date,
        c.state,
        c.city,
        c.region,
        c.signup_date,
        c.monthly_income
    FROM gold.base_subscriptions b
    LEFT JOIN silver.customers c
      ON b.user_id = c.user_id
),
calc AS (
    SELECT
        *,
        COALESCE(cancel_date, DATE '2024-12-31')          AS end_date,
        CASE 
            WHEN cancel_date IS NULL AND status = 'active'
            THEN TRUE ELSE FALSE
        END                                               AS is_active,
        CASE WHEN LOWER(status) = 'cancelled'
            THEN TRUE ELSE FALSE
        END                                               AS is_churned,
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
    COALESCE(num_payments, 0)                               AS num_payments,
    first_payment_date,
    last_payment_date,
    duration_days,
    duration_days / 30.0                                    AS duration_months,
    total_revenue                                           AS ltv,
    CASE 
        WHEN duration_days > 0 
        THEN total_revenue / (duration_days / 30.0)
        ELSE 0
    END                                                     AS mrr
FROM calc;
