# Usar .PHONY para declarar objetivos que no son archivos.
.PHONY: help setup up down stop start restart recreate logs inspect ip clean
# Makefile for n8n project

# Variables
ENV_FILE := .env
EXAMPLE_ENV_FILE := example.env
DOCKER_CONTAINER := n8n

# Default command
.DEFAULT_GOAL := help

# Help command to list all available commands
help:
	@echo "Usage: make [command]"
	@echo ""
	@echo "Commands:"
	@echo "  help\t\tShow this help message"
	@echo "  setup\t\tPrepara el entorno (crea el directorio local-files y el archivo .env)"
	@echo "  up\t\tInicia los servicios en segundo plano"
	@echo "  down\t\tDetiene los servicios y elimina los volúmenes"
	@echo "  stop\t\tDetiene los servicios sin eliminar los contenedores"
	@echo "  start\t\tInicia los servicios previamente detenidos"
	@echo "  restart\tReinicia los servicios"
	@echo "  recreate\tRecrea los servicios (útil para aplicar cambios de configuración)"
	@echo "  logs\t\tMuestra los logs del contenedor de n8n"
	@echo "  inspect\tInspect the container"
	@echo "  ip\t\tShow container IP and port"
	@echo "  clean\t\tClean up all generated files"

# Create local-files directory and .env file
setup:
	@if [ ! -f $(ENV_FILE) ]; then \
		cp $(EXAMPLE_ENV_FILE) $(ENV_FILE); \
		echo "Created .env file from $(EXAMPLE_ENV_FILE)"; \
	else \
		echo ".env file already exists"; \
	fi
	mkdir -p local-files

# Start services
up: setup
	@echo "Starting services..."
	@docker-compose up -d

# Stop services and remove volumes
down:
	docker-compose down -v

# Stop services
stop:
	docker-compose stop

# Start services
start:
	docker-compose start

# Restart services
restart:
	@echo "Restarting services..."
	@docker-compose restart

# Recreate services (down and up)
recreate:
	@echo "Recreating services..."
	docker-compose down -v
	docker-compose up -d

# View logs
logs:
	docker-compose logs -f $(DOCKER_CONTAINER)
# Inspect the container
inspect:
	@docker inspect $$(docker-compose ps -q $(DOCKER_CONTAINER)) | grep "Source"

# Show container IP and port
ip:
	@if [ -n "$$(docker-compose ps -q $(DOCKER_CONTAINER))" ]; then \
		echo "n8n is accessible at http://localhost:5678 (forwarded from $$(docker-compose port $(DOCKER_CONTAINER) 5678))"; \
	else \
		echo "Container not running. Please start the container and try again."; \
	fi

# Clean up all generated files
clean:
	docker-compose down -v --rmi all
	rm -rf local-files