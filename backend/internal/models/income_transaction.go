package models

import (
	"time"
	"github.com/shopspring/decimal"
)

type IncomeTransaction struct {
	ID int `json:"id"`
	Date time.Time `json:"date"`
	Description string `json:"description"`
	Source string `json:"source"`
	Amount decimal.Decimal `json:"amount"`
}