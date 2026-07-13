package handlers

import (
	"encoding/json"
	"net/http"
	"time"
	"github.com/jackc/pgx/v5/pgxpool"
)

type HealthHandler struct {
	db *pgxpool.Pool
}

func NewHealthHandler(db *pgxpool.Pool) *HealthHandler {
	return &HealthHandler { db: db}
}

func (h *HealthHandler) PingDatabase(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	if err := h.db.Ping(ctx); err != nil {
		http.Error(w, err.Error(), http.StatusRequestTimeout)
		return
	}

	type HealthResponse struct {
		Status    string `json:"status"`
		Version   string `json:"version"`
		Timestamp string `json:"timestamp"`
	}

	resp := HealthResponse{
			Status:    "ok",
			Version:   "v1",
			Timestamp: time.Now().UTC().Format(time.RFC3339),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}