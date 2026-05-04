-- Q6 Acquisition channel by user type
-- How do new versus returning users find the site?
-- Key finding: Paid ads almost exclusively bring in new users


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


SELECT user_labels.user_type, events.traffic_source.medium,
  COUNT(DISTINCT CONCAT(events.user_pseudo_id, events.event_date)) AS sessions
FROM user_labels
JOIN `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` as events
ON user_labels.user_pseudo_id = events.user_pseudo_id
GROUP BY events.traffic_source.medium, user_labels.user_type

