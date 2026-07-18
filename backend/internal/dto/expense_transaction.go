package dto

import (
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/shopspring/decimal"
)

type CreateExpenseTransactionRequest struct {
	Date              pgtype.Date     `json:"date"`
	Amount            decimal.Decimal `json:"amount"`
	ExpenseCategoryId int             `json:"expense_category_id"`
	TransactionTypeId int             `json:"transaction_type_id"`
	Description       string          `json:"description"`
	CategoryGroupId   int             `json:"category_group_id"`
}
