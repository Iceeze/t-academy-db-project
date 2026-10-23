-- Клиенты с переводами, значительно превышающими средние значения по системе

WITH transaction_stats AS (
    SELECT
        AVG(t.amount) AS avg_amount,
        STDDEV(t.amount) AS stddev_amount
    FROM transactions t
    JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id
    WHERE tt.name IN ('Пополнение', 'Снятие')
),
client_transactions AS (
    SELECT
        c.customer_id,
        c.last_name || ' ' || c.first_name AS client_name,
        AVG(t.amount) AS client_avg_amount  -- Ищем по среднему значению всех переводов
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id
    WHERE tt.name IN ('Пополнение', 'Снятие')
    GROUP BY c.customer_id, c.last_name, c.first_name
)
SELECT
    ct.customer_id,
    ct.client_name,
    ct.client_avg_amount,
    ts.avg_amount AS all_avg_amount
FROM client_transactions ct
CROSS JOIN transaction_stats ts
WHERE ct.client_avg_amount > ts.avg_amount + (ts.stddev_amount * 2)  -- Выше среднего на 2 стандартных отклонения
ORDER BY ct.client_avg_amount DESC;
