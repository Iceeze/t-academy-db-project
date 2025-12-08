-- Для каждого клиента определить наиболее прибыльный продукт

WITH client_product_profit AS (
    SELECT
        c.customer_id,
        pt.name AS product_name,
        SUM(t.amount) AS total_profit
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN product_types pt ON a.product_type_id = pt.product_type_id
    JOIN transactions t ON a.account_id = t.account_id
    JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id
    WHERE tt.name = 'Начисление процентов'
    GROUP BY c.customer_id, pt.name
),
ranked_products AS (
    SELECT
        customer_id,
        product_name,
        total_profit,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_profit DESC) AS rank
    FROM client_product_profit
)
SELECT
    c.customer_id,
    c.last_name || ' ' || c.first_name AS client_name,
    rp.product_name AS most_profitable_product,
    rp.total_profit
FROM ranked_products rp
JOIN customers c ON rp.customer_id = c.customer_id
WHERE rp.rank = 1