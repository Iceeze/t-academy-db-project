-- Счета без операций дольше указанного количества дней

WITH last_operations AS (
    SELECT
        account_id,
        MAX(transaction_date) AS last_operation_date,
        CURRENT_DATE - MAX(transaction_date::DATE) AS days_inactive
    FROM transactions
    GROUP BY account_id
)
SELECT
    a.account_id,
    pt.name AS product_type,
    lo.last_operation_date,
    lo.days_inactive
FROM accounts a
JOIN product_types pt ON a.product_type_id = pt.product_type_id
JOIN account_statuses s ON a.status_id = s.status_id
JOIN last_operations lo ON a.account_id = lo.account_id
WHERE s.name = 'Открыт'
    AND lo.days_inactive > 300
ORDER BY lo.days_inactive DESC;
