INSERT INTO expense_transaction (date, amount, expense_category_id, transaction_type_id, description, category_group_id)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING ID;