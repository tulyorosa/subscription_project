-- Exporta todas as tabelas do schema gold

COPY gold.agg_payments
TO 'data/gold/agg_payments.csv'
WITH (HEADER, DELIMITER ',');

COPY gold.agg_cancel
TO 'data/gold/agg_cancel.csv'
WITH (HEADER, DELIMITER ',');

COPY gold.base_subscriptions
TO 'data/gold/base_subscriptions.csv'
WITH (HEADER, DELIMITER ',');

COPY gold.fact_subscriptions
TO 'data/gold/fact_subscriptions.csv'
WITH (HEADER, DELIMITER ',');
