package handlers

import (
	"encoding/json"
	"fluxio/internal/service"
	"net/http"
)

type ExpenseTransactionHandler struct {
	service *service.ExpenseTransactionService
}

func NewExpenseTransactionHandler(service *service.ExpenseTransactionService) *ExpenseTransactionHandler {
	return &ExpenseTransactionHandler { service: service }
}

func (h *ExpenseTransactionHandler) GetAll(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	expenseTransactions, err := h.service.GetAll(ctx)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(expenseTransactions)
}