package handlers

import (
	"encoding/json"
	"fluxio/internal/dto"
	"fluxio/internal/service"
	"net/http"
)

type IncomeTransactionHandler struct {
	service *service.IncomeTransactionService
}

func NewIncomeTransactionHandler(service *service.IncomeTransactionService) *IncomeTransactionHandler {
	return &IncomeTransactionHandler{service: service}
}

func (h *IncomeTransactionHandler) GetAll(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	incomeTransactions, err := h.service.GetAll(ctx)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(incomeTransactions)
}

func (h *IncomeTransactionHandler) Create(w http.ResponseWriter, r *http.Request) {
	var req dto.CreateIncomeTransactionRequest

	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	id, err := h.service.Create(r.Context(), req)
	if err != nil {
		http.Error(w, "failed to create income transaction", http.StatusInternalServerError)
		return
	}

	response := map[string]any{
		"id": id,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)

	json.NewEncoder(w).Encode(response)
}
