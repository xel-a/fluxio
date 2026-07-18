package handlers

import (
	"encoding/json"
	"fluxio/internal/dto"
	"fluxio/internal/service"
	"net/http"
)

type ExpenseTransactionHandler struct {
	service *service.ExpenseTransactionService
}

func NewExpenseTransactionHandler(service *service.ExpenseTransactionService) *ExpenseTransactionHandler {
	return &ExpenseTransactionHandler{service: service}
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

func (h *ExpenseTransactionHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req dto.CreateExpenseTransactionRequest

	err := json.NewDecoder(r.Body).Decode(&req)

	if err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	id, err := h.service.Create(r.Context(), req)

	if err != nil {
		http.Error(w, "failed to create expense transaction", http.StatusInternalServerError)
		return
	}

	response := map[string]any{
		"id": id,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)

	json.NewEncoder(w).Encode(response)
}
