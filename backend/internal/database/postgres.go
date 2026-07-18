package database

import (
	"context"
	"github.com/jackc/pgx/v5/pgxpool"
)

func New(databaseURL string, ctx context.Context) (*pgxpool.Pool, error) {
	return pgxpool.New(ctx, databaseURL)
}
