-- Клиенты с прибылью выше 250000 руб. и сумма налога 13%

WITH client_profit AS (
    SELECT
        c.customer_id,
        SUM(t.amount) AS total_profit
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id
    WHERE tt.name = 'Начисление процентов'
        AND t.transaction_date BETWEEN '2025-01-01' AND '2025-10-31'
        AND a.currency_id = (SELECT currency_id FROM currencies WHERE code = 'RUB')
    GROUP BY c.customer_id
    HAVING SUM(t.amount) > 250000
)
SELECT
    customer_id,
    ROUND((total_profit - 250000) * 0.13, 2) AS tax_amount
FROM client_profit
