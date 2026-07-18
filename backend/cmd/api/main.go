package main

import (
	"context"
	"fluxio/internal/app"
	"fluxio/internal/config"
	"fluxio/internal/database"
	"fluxio/internal/routes"
	"log"
	"net/http"
)

func main() {
	cfg := config.Load()
	db, err := database.New(cfg.DatabaseURL, context.Background())

	if err != nil {
		log.Fatal("Unable to connect to database:", err)
	}

	handlers := app.Initialize(db)
	router := routes.NewRouter(handlers)

	log.Println("Server listening on Port: ", cfg.Port)

	if err := http.ListenAndServe(":"+cfg.Port, router); err != nil {
		log.Fatal(err)
	}
}
