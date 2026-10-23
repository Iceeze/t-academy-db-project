-- Список всех активных вкладов или накопительных счетов конкретного клиента с названием продукта

SELECT
    a.account_id,
    pt.name AS product_name,
    a.open_date,
    a.current_interest_rate,
    c.code AS currency_code
FROM accounts a
JOIN product_types pt ON a.product_type_id = pt.product_type_id
JOIN currencies c ON a.currency_id = c.currency_id
JOIN account_statuses s ON a.status_id = s.status_id
WHERE a.customer_id = 2 AND s.name = 'Открыт'