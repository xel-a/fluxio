package service

import (
	"context"
	"fluxio/internal/dto"
	"fluxio/internal/models"
	"fluxio/internal/repository"
)

type IncomeTransactionService struct {
	repo *repository.IncomeTransactionRepository
}

func NewIncomeTransactionService(repo *repository.IncomeTransactionRepository) *IncomeTransactionService {
	return &IncomeTransactionService{repo: repo}
}

func (s *IncomeTransactionService) GetAll(ctx context.Context) ([]models.IncomeTransaction, error) {
	return s.repo.GetAll(ctx)
}

func (s *IncomeTransactionService) Create(ctx context.Context, req dto.CreateIncomeTransactionRequest) (int, error) {
	return s.repo.Create(ctx, req)
}
