package service

import (
	"context"
	"fluxio/internal/models"
	"fluxio/internal/repository"
)

type IncomeTransactionService struct {
	repo *repository.IncomeTransactionRepository
}

func NewIncomeTransactionService(repo *repository.IncomeTransactionRepository) *IncomeTransactionService {
	return &IncomeTransactionService {repo: repo}
}

func (s *IncomeTransactionService) GetAll(ctx context.Context,) ([]models.IncomeTransaction, error) {
	return s.repo.GetAll(ctx)
}