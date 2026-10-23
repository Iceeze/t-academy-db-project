-- Клиенты с суммой снятий свыше 1000000 руб. за месяц

WITH client_withdrawals AS (
    SELECT
        c.customer_id,
        SUM(t.amount) AS total_withdrawals,
        SUM(CASE WHEN t.amount > 100000 THEN 1 ELSE 0 END) AS large_withdrawals_count
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN product_types pt ON a.product_type_id = pt.product_type_id
    JOIN transactions t ON a.account_id = t.account_id
    JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id
    WHERE pt.name = 'Накопительный счет'
        AND tt.name = 'Снятие'
        AND a.currency_id = (SELECT currency_id FROM currencies WHERE code = 'RUB')
        AND t.transaction_date >= CURRENT_DATE - INTERVAL '1 month'
        AND t.transaction_date < CURRENT_DATE
    GROUP BY c.customer_id
    HAVING SUM(t.amount) > 1000000
)
SELECT
    customer_id,
    total_withdrawals,
    large_withdrawals_count
FROM client_withdrawals
ORDER BY total_withdrawals DESC;
