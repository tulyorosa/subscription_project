-- 01_bronze.sql
-- Cria esquema bronze e carrega os CSVs

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE OR REPLACE TABLE bronze.customers AS
SELECT *
FROM read_csv_auto('data/raw/customers.csv', HEADER=TRUE);

CREATE OR REPLACE TABLE bronze.subscriptions AS
SELECT *
FROM read_csv_auto('data/raw/subscriptions.csv', HEADER=TRUE);

CREATE OR REPLACE TABLE bronze.payments AS
SELECT *
FROM read_csv_auto('data/raw/payments.csv', HEADER=TRUE);

CREATE OR REPLACE TABLE bronze.events AS
SELECT *
FROM read_csv_auto('data/raw/subscription_events.csv', HEADER=TRUE);
