-- Рейтинг продуктов по приросту активов за 90 дней

WITH account_balances AS (
    SELECT
        a.account_id,
        a.product_type_id,
        COALESCE(
            (SELECT balance_after
             FROM transactions t1
             WHERE t1.account_id = a.account_id
                AND t1.transaction_date < CURRENT_DATE - INTERVAL '90 days'
             ORDER BY t1.transaction_date DESC
             LIMIT 1),
            0
        ) AS start_balance,
        COALESCE(
            (SELECT balance_after
             FROM transactions t2
             WHERE t2.account_id = a.account_id
                AND t2.transaction_date <= CURRENT_DATE
                AND t2.transaction_date >= CURRENT_DATE - INTERVAL '90 days'
             ORDER BY t2.transaction_date DESC
             LIMIT 1),
            0
        ) AS end_balance
    FROM accounts a
    WHERE a.status_id = (SELECT status_id FROM account_statuses WHERE name = 'Открыт')
),
product_growth AS (
    SELECT
        pt.name AS product_name,
        SUM(ab.end_balance - ab.start_balance) AS net_growth
    FROM account_balances ab
    JOIN product_types pt ON ab.product_type_id = pt.product_type_id
    GROUP BY pt.name
)
SELECT
    RANK() OVER (ORDER BY net_growth DESC) AS growth_rank,
    product_name,
    net_growth
FROM product_growth
ORDER BY net_growth DESC;
