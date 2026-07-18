package routes

import (
	"fluxio/internal/app"
	"github.com/go-chi/chi/v5"
	"net/http"
)

func NewRouter(h *app.Handlers) http.Handler {
	r := chi.NewRouter()

	r.Get("/health", h.Health.PingDatabase)
	r.Route("/income-transactions", func(r chi.Router) {
		r.Post("/", h.IncomeTransaction.Create)
		r.Get("/", h.IncomeTransaction.GetAll)
	})
	r.Route("/expense-transactions", func(r chi.Router) {
		r.Post("/", h.ExpenseTransaction.Create)
		r.Get("/", h.ExpenseTransaction.GetAll)
	})

	return r
}
