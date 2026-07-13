package repository

import (
	"context"
	"fluxio/internal/models"
	"github.com/jackc/pgx/v5/pgxpool"
)

type IncomeTransactionRepository struct {
	db *pgxpool.Pool
}

func NewIncomeTransactionRepository(db *pgxpool.Pool) *IncomeTransactionRepository {
	return &IncomeTransactionRepository{db: db}
}

func (r *IncomeTransactionRepository) GetAll(ctx context.Context) ([]models.IncomeTransaction, error) {
	const query = `
		SELECT id, date, description, source, amount
		FROM income_transaction
		ORDER BY date DESC, id DESC 
	`
	rows, err := r.db.Query(ctx, query)

	if err != nil {
		return nil, err
	}
	
	defer rows.Close()

	incomes := make([]models.IncomeTransaction, 0)

	for rows.Next() {
		var income models.IncomeTransaction

		err := rows.Scan(
			&income.ID,
			&income.Date,
			&income.Description,
			&income.Source,
			&income.Amount,
		)
		
		if err != nil {
			return nil, err
		}

		incomes = append(incomes, income)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return incomes, nil
}