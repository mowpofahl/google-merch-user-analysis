-- Q5a: Acquisition Channel Exploration
-- Identifying what traffic source mediums exist in the dataset
-- before building the full breakdown by user type
-- Note: <Other> and (data deleted) are obfuscation artifacts


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

SELECT
  traffic_source.medium,
  COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY traffic_source.medium
ORDER BY event_count DESC
