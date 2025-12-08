-- Клиенты с более чем одним вкладом или счётом

SELECT
    c.customer_id,
    c.last_name || ' ' || c.first_name AS client_name,
    COUNT(a.account_id) AS total_accounts
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN account_statuses s ON a.status_id = s.status_id
WHERE s.name = 'Открыт'
GROUP BY c.customer_id, c.last_name, c.first_name
HAVING COUNT(a.account_id) > 1
