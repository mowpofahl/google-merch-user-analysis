-- Q3: Conversion Rate by User Type
-- What percentage of sessions result in a purchase for new vs returning users?
-- Key finding: returning users convert at 4.66% vs 1.26% for new users
-- Returning users are 3.5x more likely to make a purchase per session

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
  COUNT(DISTINCT 
    CASE 
      WHEN event_name = 'purchase' THEN CONCAT(events.user_pseudo_id, events.event_date)
    END) AS converted_sessions,
  ROUND(COUNT(DISTINCT
    CASE
      WHEN event_name = 'purchase' THEN CONCAT (events.user_pseudo_id, events.event_date)
    END) * 100.0 / COUNT(DISTINCT CONCAT(events.user_pseudo_id, events.event_date)), 2) AS conversions_rate
FROM user_labels
JOIN `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS events
ON user_labels.user_pseudo_id = events.user_pseudo_id
GROUP BY user_labels.user_type


