-- Пять клиентов с наибольшим оборотом операций за период

SELECT
    c.customer_id,
    c.last_name || ' ' || c.first_name AS client_name,
    SUM(t.amount) AS total_turnover
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_date BETWEEN '2025-01-01' AND '2025-03-31'
GROUP BY c.customer_id, c.last_name, c.first_name
ORDER BY total_turnover DESC
LIMIT 5;
