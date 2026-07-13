package routes

import (
	"fluxio/internal/app"
	"net/http"
	"github.com/go-chi/chi/v5"
)

func NewRouter(h *app.Handlers) http.Handler {
	r := chi.NewRouter()

	r.Get("/health", h.Health.PingDatabase)
	r.Route("/income-transactions", func(r chi.Router) {
		r.Get("/", h.IncomeTransaction.GetAll)
	})

	return r
}