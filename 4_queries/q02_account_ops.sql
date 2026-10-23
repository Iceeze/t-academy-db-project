-- Все операции по выбранному счёту за период с названием продукта

SELECT
    tt.name AS transaction_name,
    pt.name AS product_name,
    t.account_id,
    t.amount,
    t.transaction_date
FROM transactions t
JOIN accounts a ON a.account_id = t.account_id
JOIN product_types pt ON a.product_type_id = pt.product_type_id
JOIN transaction_types tt ON tt.transaction_type_id = t.transaction_type_id
WHERE a.account_id = 2
    AND t.transaction_date BETWEEN '2025-01-01' AND '2025-02-19'
