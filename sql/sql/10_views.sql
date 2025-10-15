-- KPIs journaliers (Looker-ready)
CREATE OR REPLACE VIEW `demo.v_events_metrics` AS
SELECT
  date,
  COUNT(*) AS nb_events,
  COUNTIF(status='Success') AS nb_success,
  SAFE_DIVIDE(COUNTIF(status='Success'), COUNT(*)) AS conversion_rate,
  SUM(amount) AS gmv,
  SAFE_DIVIDE(SUM(amount), NULLIF(COUNT(DISTINCT customer_id),0)) AS avg_ticket
FROM `demo.v_events`
GROUP BY date;

-- Détails (table pour filtres et analyses)
CREATE OR REPLACE VIEW `demo.v_events_details` AS
SELECT
  date,
  region,
  segment,
  channel,
  status,
  amount,
  customer_id,
  event_id
FROM `demo.v_events`;
