package handlers

import (
	"encoding/json"
	"fluxio/internal/service"
	"net/http"
)

type IncomeTransactionHandler struct {
	service *service.IncomeTransactionService
}

func NewIncomeTransactionHandler(service *service.IncomeTransactionService) *IncomeTransactionHandler {
	return &IncomeTransactionHandler {service: service}
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