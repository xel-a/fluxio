package repository

import (
	"context"
	"fluxio/internal/dto"
	"fluxio/internal/models"
	"fluxio/internal/sql/income_transaction"

	"github.com/jackc/pgx/v5/pgxpool"
)

type IncomeTransactionRepository struct {
	db *pgxpool.Pool
}

func NewIncomeTransactionRepository(db *pgxpool.Pool) *IncomeTransactionRepository {
	return &IncomeTransactionRepository{db: db}
}

func (r *IncomeTransactionRepository) GetAll(ctx context.Context) ([]models.IncomeTransaction, error) {
		rows, err := r.db.Query(ctx, income_transaction.GetAll)

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

func (r *IncomeTransactionRepository) Create(ctx context.Context, req dto.CreateIncomeTransactionRequest) (int, error) {
	var id int

	err := r.db.QueryRow(
		ctx,
		income_transaction.Create,
		req.Date,
		req.Description,
		req.Source,
		req.Amount,
	).Scan(&id)

	return id, err
}