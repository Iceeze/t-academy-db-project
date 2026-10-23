-- Сумма начисленных процентов на конкретный счёт за период

SELECT SUM(t.amount) AS total_interest
FROM transactions t
JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id
WHERE t.account_id = 1
    AND tt.name = 'Начисление процентов'
    AND t.transaction_date BETWEEN '2025-01-01' AND '2025-01-31';