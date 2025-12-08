-- Клиенты с хотя бы одним продуктом со ставкой выше указанного значения

SELECT DISTINCT
    c.customer_id,
    c.last_name || ' ' || c.first_name AS client_name,
    a.current_interest_rate AS interest_rate,
    pt.name AS product_type
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN product_types pt ON a.product_type_id = pt.product_type_id
JOIN account_statuses s ON a.status_id = s.status_id
WHERE a.current_interest_rate > 5.0
    AND s.name = 'Открыт'