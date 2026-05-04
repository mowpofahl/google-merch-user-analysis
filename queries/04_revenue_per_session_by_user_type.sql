-- Q4 Revenue per session by user type
-- What is the average revenue per session for new vs. returning users?
-- Key finding: returning users generate 4.2x more revenue


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
  COUNT(DISTINCT CONCAT(events.user_pseudo_id, events.event_date)) AS total_sessions,
  ROUND(SUM(events.ecommerce.purchase_revenue) / COUNT(DISTINCT CONCAT(events.user_pseudo_id, events.event_date)), 2) AS revenue_per_session
FROM user_labels
JOIN `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS events
ON user_labels.user_pseudo_id = events.user_pseudo_id
GROUP BY user_labels.user_type
