.PHONY: help setup up down stop start restart logs inspect ip clean

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
	@echo "  setup\t\tCreate local-files directory and .env file"
	@echo "  up\t\tStart services"
	@echo "  down\t\tStop services and remove volumes"
	@echo "  stop\t\tStop services"
	@echo "  start\t\tStart services"
	@echo "  restart\tRestart services"
	@echo "  logs\t\tView logs"
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
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "WARNING: .env file does not exist! 'example.env' copied to '.env'. Please update the configurations in the .env file before running this target."; \
		exit 1; \
	fi
	docker-compose up -d

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
	docker-compose down -v
	sleep 5
	docker-compose up -d

# View logs
logs:
	docker-compose logs -f $(DOCKER_CONTAINER)

# Inspect the container
inspect:
	docker inspect $(DOCKER_CONTAINER) | grep "Source"

# Show container IP and port
ip:
	@if [[ "$$(docker ps -q -f name=${DOCKER_CONTAINER})" ]]; then \
		echo "Container ${DOCKER_CONTAINER} running! Forwarding connections from $$(docker port ${DOCKER_CONTAINER})"; \
	else \
		echo "Container not running. Please start the container and try again."; \
	fi

# Clean up all generated files
clean:
	docker-compose down -v --rmi all
	rm -rf local-files