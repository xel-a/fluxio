package database

import (
	"github.com/jackc/pgx/v5/pgxpool"
	"context"
)

func New(databaseURL string, ctx context.Context) (*pgxpool.Pool, error) {
	return pgxpool.New(ctx, databaseURL)
}