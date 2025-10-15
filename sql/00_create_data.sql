-- Dataset conseillé : demo
-- Tables : dim_customer, fact_events, fact_events_part (partitionnée)
-- Vue intermédiaire v_events

-- 1) Customers (synthétique)
CREATE OR REPLACE TABLE `demo.dim_customer` AS
SELECT
  c AS customer_id,
  CASE WHEN RAND() < 0.5 THEN 'FR' ELSE 'EU' END AS region,
  CASE WHEN RAND() < 0.6 THEN 'Retail' ELSE 'Corporate' END AS segment,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(ROUND(RAND()*365) AS INT64) DAY) AS signup_date
FROM UNNEST(GENERATE_ARRAY(1, 5000)) AS c;

-- 2) Events bruts (synthetic)
CREATE OR REPLACE TABLE `demo.fact_events` AS
WITH dates AS (
  SELECT d AS dt
  FROM UNNEST(GENERATE_DATE_ARRAY(DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY), CURRENT_DATE())) d
),
base AS (
  SELECT
    dt,
    CAST(100000 + ROW_NUMBER() OVER() AS INT64) AS event_id,
    CAST(1 + CAST(RAND()*5000 AS INT64) AS INT64) AS customer_id,
    CASE WHEN RAND() < 0.7 THEN 'Card' ELSE 'Transfer' END AS channel,
    CASE
      WHEN RAND() < 0.88 THEN 'Success'
      WHEN RAND() < 0.95 THEN 'Pending'
      ELSE 'Failed'
    END AS status,
    ROUND(5 + RAND()*195, 2) AS amount
  FROM dates, UNNEST(GENERATE_ARRAY(1, 600)) AS n -- ~600 events/jour
)
SELECT * FROM base;

-- 3) Table partitionnée par date (bonnes pratiques BQ)
CREATE OR REPLACE TABLE `demo.fact_events_part`
PARTITION BY DATE(event_ts) AS
SELECT
  TIMESTAMP(DATETIME(
    dt,
    TIME(
      CAST(FLOOR(RAND()*24) AS INT64),
      CAST(FLOOR(RAND()*60) AS INT64),
      0
    )
  )) AS event_ts,
  * EXCEPT(dt)
FROM `demo.fact_events`;

-- 4) Vue de conso (jointure customer → dimensions prêtes pour Looker)
CREATE OR REPLACE VIEW `demo.v_events` AS
SELECT
  DATE(event_ts) AS date,
  e.event_id,
  e.customer_id,
  c.region,
  c.segment,
  e.channel,
  e.status,
  e.amount
FROM `demo.fact_events_part` e
LEFT JOIN `demo.dim_customer` c USING (customer_id);
