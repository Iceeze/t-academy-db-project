-- Количество операций за последний месяц по каждому клиенту

SELECT
    c.customer_id,
    c.last_name || ' ' || c.first_name AS client_name,
    COUNT(t.transaction_id) AS operations_count
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
    AND t.transaction_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY c.customer_id, c.last_name, c.first_name
