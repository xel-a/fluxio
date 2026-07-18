package repository

import (
	"context"
	"fluxio/internal/dto"
	"fluxio/internal/models"
	"fluxio/internal/sql/expense_transaction"

	"github.com/jackc/pgx/v5/pgxpool"
)

type ExpenseTransactionRepository struct {
	db *pgxpool.Pool
}

func NewExpenseTransactionRepository(db *pgxpool.Pool) *ExpenseTransactionRepository {
	return &ExpenseTransactionRepository{db: db}
}

func (r *ExpenseTransactionRepository) GetAll(ctx context.Context) ([]models.ExpenseTransaction, error) {
	rows, err := r.db.Query(ctx, expense_transaction.GetAll)

	if err != nil {
		return nil, err
	}

	defer rows.Close()

	expenses := make([]models.ExpenseTransaction, 0)

	for rows.Next() {
		var expense models.ExpenseTransaction

		err := rows.Scan(
			&expense.ID,
			&expense.Date,
			&expense.Amount,
			&expense.ExpenseCategoryId,
			&expense.TransactionTypeId,
			&expense.Description,
			&expense.CategoryGroupId,
		)

		if err != nil {
			return nil, err
		}

		expenses = append(expenses, expense)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return expenses, nil
}

func (r *ExpenseTransactionRepository) Create(ctx context.Context, req dto.CreateExpenseTransactionRequest) (int, error) {
	var id int

	err := r.db.QueryRow(
		ctx,
		expense_transaction.Create,
		req.Date,
		req.Amount,
		req.ExpenseCategoryId,
		req.TransactionTypeId,
		req.Description,
		req.CategoryGroupId,
	).Scan(&id)

	return id, err
}
