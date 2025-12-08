-- Продукты, по которым ставка изменялась хотя бы раз за последний год

WITH rate_changes AS (
    SELECT
        product_type_id,
        COUNT(DISTINCT interest_rate_value) AS rate_versions
    FROM interest_rates
    WHERE start_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY product_type_id
    HAVING COUNT(DISTINCT interest_rate_value) > 1
)
SELECT
    pt.name AS product_name,
    rc.rate_versions AS changes_count
FROM product_types pt
JOIN rate_changes rc ON pt.product_type_id = rc.product_type_id
