-- Счета с подозрительно большим числом операций за короткий период

WITH suspicious_activity AS (
    SELECT
        account_id,
        DATE_TRUNC('hour', transaction_date) AS hour_window,
        COUNT(*) AS operations_count
    FROM transactions
    GROUP BY account_id, DATE_TRUNC('hour', transaction_date)
    HAVING COUNT(*) > 5
)
SELECT
    a.account_id,
    pt.name AS product_name,
    sa.hour_window,
    sa.operations_count
FROM suspicious_activity sa
JOIN accounts a ON sa.account_id = a.account_id
JOIN product_types pt ON a.product_type_id = pt.product_type_id
ORDER BY sa.operations_count DESC;
