package dto

import (
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/shopspring/decimal"
)

type CreateIncomeTransactionRequest struct {
	Date        pgtype.Date `json:"date"`
	Description string    `json:"description"`
	Source      string    `json:"source"`
	Amount      decimal.Decimal   `json:"amount"`
}