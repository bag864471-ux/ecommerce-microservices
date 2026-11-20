.PHONY: build run test clean docker-build docker-up docker-down

# Build all services
build:
	@echo "Building all services..."
	@for service in services/*/; do \
		echo "Building $$service..."; \
		cd $$service && go build -o bin/main main.go && cd ../..; \
	done

# Run all services locally
run:
	@echo "Running all services..."
	@for service in services/*/; do \
		echo "Starting $$service..."; \
		cd $$service && go run main.go & cd ../..; \
	done

# Run tests
test:
	@echo "Running tests..."
	@go test -v ./...

# Run integration tests
test-integration:
	@echo "Running integration tests..."
	@go test -v -tags=integration ./...

# Generate coverage report
coverage:
	@go test -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out

# Build Docker images
docker-build:
	@echo "Building Docker images..."
	@docker-compose build

# Start all services with Docker Compose
docker-up:
	@echo "Starting services..."
	@docker-compose up -d

# Stop all services
docker-down:
	@echo "Stopping services..."
	@docker-compose down

# View logs
logs:
	@docker-compose logs -f

# Health check
health-check:
	@echo "Checking service health..."
	@curl -f http://localhost:8000/health || echo "API Gateway: DOWN"
	@curl -f http://localhost:8001/health || echo "Auth Service: DOWN"
	@curl -f http://localhost:8002/health || echo "Product Service: DOWN"

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -rf services/*/bin
	@docker-compose down -v
	@docker system prune -f

# Install dependencies
install:
	@go mod download
	@go mod tidy

# Format code
fmt:
	@gofmt -w .

# Lint code
lint:
	@golangci-lint run

# Generate protobuf files
proto:
	@protoc --go_out=. --go-grpc_out=. proto/*.proto
