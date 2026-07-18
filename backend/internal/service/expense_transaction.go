package service

import (
	"context"
	"fluxio/internal/dto"
	"fluxio/internal/models"
	"fluxio/internal/repository"
)

type ExpenseTransactionService struct {
	repo *repository.ExpenseTransactionRepository
}

func NewExpenseTransactionService(repo *repository.ExpenseTransactionRepository) *ExpenseTransactionService {
	return &ExpenseTransactionService{repo: repo}
}

func (s *ExpenseTransactionService) GetAll(ctx context.Context) ([]models.ExpenseTransaction, error) {
	return s.repo.GetAll(ctx)
}

func (s *ExpenseTransactionService) Create(ctx context.Context, req dto.CreateExpenseTransactionRequest) (int, error) {
	return s.repo.Create(ctx, req)
}
