package models

import (
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/shopspring/decimal"
)

type IncomeTransaction struct {
	ID int `json:"id"`
	Date pgtype.Date `json:"date"`
	Description string `json:"description"`
	Source string `json:"source"`
	Amount decimal.Decimal `json:"amount"`
}