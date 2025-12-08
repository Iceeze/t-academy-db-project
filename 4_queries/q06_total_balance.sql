-- Общий объём средств на счетах определённого типа

WITH last_balance AS (
    SELECT
        account_id,
        balance_after,
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY transaction_date DESC) AS row_number
    FROM transactions
)
SELECT
    pt.name AS product_type,
    SUM(lb.balance_after) AS total_balance
FROM accounts a
JOIN product_types pt ON a.product_type_id = pt.product_type_id
JOIN last_balance lb ON a.account_id = lb.account_id AND lb.row_number = 1
WHERE pt.name = 'Накопительный счет'
    AND a.status_id = (SELECT status_id FROM account_statuses WHERE name = 'Открыт')
GROUP BY pt.name;