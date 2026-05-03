-- Q2: New vs. Returning User Volume
-- How are new and returning users split across sessions and revenue?
-- Uses CTE to correctly classify users before analyzing their events
-- Key finding: new users generate more total revenue ($274,867 vs $87,298)
-- but returning users are far more engaged per person (1.7 sessions vs 1.15)
-- Only 5% of users ever return -- suggesting a retention opportunity

WITH user_labels AS (
  SELECT
    user_pseudo_id,
    CASE
      WHEN COUNTIF(event_name = 'first_visit') > 0 THEN 'new_user'
      ELSE 'returning_user'
    END AS user_type
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
)

SELECT user_labels.user_type,
  COUNT(DISTINCT events.user_pseudo_id) AS unique_users,
  COUNT(DISTINCT CONCAT(events.user_pseudo_id, events.event_date)) AS total_sessions,
  SUM(events.ecommerce.purchase_revenue) AS total_revenue
FROM user_labels
JOIN `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS events
ON user_labels.user_pseudo_id = events.user_pseudo_id
GROUP BY user_type

LIMIT 10



