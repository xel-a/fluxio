package app

import (
	"fluxio/internal/handlers"
	"fluxio/internal/repository"
	"fluxio/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Handlers struct {
	Health *handlers.HealthHandler
	IncomeTransaction *handlers.IncomeTransactionHandler
}

func Initialize(db *pgxpool.Pool) *Handlers {
	incomeTransacationRepo := repository.NewIncomeTransactionRepository(db)
	incomeTransacationService := service.NewIncomeTransactionService(incomeTransacationRepo)
	incomeTransactionHandler := handlers.NewIncomeTransactionHandler(incomeTransacationService)

	healthHandler := handlers.NewHealthHandler(db)

	return &Handlers{
		Health: healthHandler,
		IncomeTransaction: incomeTransactionHandler,
	}
}