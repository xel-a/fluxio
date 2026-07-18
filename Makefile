DEV=docker-compose.yaml -f docker-compose.dev.yaml
PROD=docker-compose.yaml -f docker-compose.prod.yaml

help:
	@echo "Development:"
	@echo "  make dev-build"
	@echo "  make dev-up"
	@echo "  make dev-start"
	@echo "  make dev-stop"
	@echo "  make dev-down"
	@echo "  make dev-downv (include volumes)"
	@echo "  make restart"
	@echo ""
	@echo "Production:"
	@echo "  make prod-build"
	@echo "  make prod-up"
	@echo "  make prod-down"
	@echo ""
	@echo "Logging:"
	@echo "  make api-log"
	@echo ""
	@echo "Formatting"
	@echo "  make api-format"

dev-build:
	docker compose -f ${DEV} up --build -d

dev-up:
	docker compose -f $(DEV) up -d

dev-start:
	docker compose -f $(DEV) start

dev-stop:
	docker compose -f $(DEV) stop

dev-down:
	docker compose -f $(DEV) down

dev-downv:
	docker compose -f $(DEV) down -v

restart:
	docker compose -f $(DEV) restart

prod-build:
	docker compose -f $(PROD) build -d

prod-up:
	docker compose -f $(PROD) up -d

prod-down:
	docker compose -f $(PROD) down

api-log:
	docker logs --follow api_ctr

api-format:
	(cd backend && go fmt ./...)