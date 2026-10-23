-- Хронологическая история изменений процентной ставки для продуктов с активными счетами

SELECT
    pt.name AS product_name,
    ir.start_date,
    ir.end_date,
    ir.interest_rate_value
FROM interest_rates ir
JOIN product_types pt ON ir.product_type_id = pt.product_type_id
WHERE ir.product_type_id IN (
    SELECT DISTINCT a.product_type_id
    FROM accounts a
    JOIN account_statuses s ON a.status_id = s.status_id
    WHERE s.name = 'Открыт'
)
ORDER BY pt.name, ir.start_date DESC;
