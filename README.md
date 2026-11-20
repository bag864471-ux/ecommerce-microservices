<div align="center">

# 🛒 E-Commerce Microservices Platform

### Scalable, cloud-native e-commerce platform with microservices architecture

![Go](https://img.shields.io/badge/Go-1.21-blue.svg)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-blue.svg)
![Kafka](https://img.shields.io/badge/Kafka-3.6-black.svg)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)
![Redis](https://img.shields.io/badge/Redis-7-red.svg)
![gRPC](https://img.shields.io/badge/gRPC-1.60-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

[Architecture](#-architecture) • [Services](#-services) • [Installation](#-installation) • [API Docs](#-api-documentation)

</div>

---

## 🏗️ Architecture

### Microservices

```
┌─────────────────────────────────────────────────────────────┐
│                        API Gateway                          │
│                   (Kong / Ambassador)                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
   ┌────▼────┐  ┌──────────┐  ┌───────▼────┐
   │  Auth   │  │  Order   │  │  Product  │
   │ Service │  │ Service  │  │  Service  │
   │  (Go)   │  │  (Go)    │  │   (Go)    │
   └────┬────┘  └────┬─────┘  └─────┬─────┘
        │            │              │
        └────────────┼──────────────┘
                     │
        ┌────────────┴──────────────┐
        │      Event Bus (Kafka)    │
        └────────────┬──────────────┘
                     │
        ┌────────────┼──────────────┐
        │            │              │
   ┌────▼────┐  ┌────▼─────┐  ┌────▼─────┐
   │Payment  │  │Inventory │  │ Shipping │
   │Service  │  │ Service  │  │ Service  │
   │(Go)     │  │  (Go)    │  │  (Go)    │
   └─────────┘  └──────────┘  └──────────┘
```

### Event-Driven Communication

- **Order Created** → Payment, Inventory, Notification services
- **Payment Completed** → Order, Shipping services
- **Inventory Updated** → Product, Analytics services

---

## 🛠️ Services

### 1. **API Gateway** (Port: 8000)
- Request routing
- Authentication
- Rate limiting
- Request/response transformation

### 2. **Auth Service** (Port: 8001)
- User registration/login
- JWT token generation
- Role-based access control
- OAuth2 integration

### 3. **Product Service** (Port: 8002)
- Product catalog management
- Search and filtering
- Inventory tracking
- Pricing management

### 4. **Order Service** (Port: 8003)
- Order creation and management
- Order history
- Order status tracking
- Shopping cart

### 5. **Payment Service** (Port: 8004)
- Payment processing
- Multiple payment methods
- Transaction history
- Refund handling

### 6. **Inventory Service** (Port: 8005)
- Stock management
- Warehouse tracking
- Low stock alerts
- Automatic reordering

### 7. **Notification Service** (Port: 8006)
- Email notifications
- SMS notifications
- Push notifications
- Order updates

### 8. **Shipping Service** (Port: 8007)
- Shipping calculation
- Tracking integration
- Delivery management
- Carrier integration

---

## 🚀 Installation

### Prerequisites
- Go 1.21+
- Docker & Docker Compose
- Kubernetes (optional)
- Make

### Quick Start with Docker Compose

```bash
# Clone repository
git clone https://github.com/bag864471-ux/ecommerce-microservices.git
cd ecommerce-microservices

# Start all services
docker-compose up -d

# Check service health
make health-check

# Access API Gateway
open http://localhost:8000
```

### Local Development

```bash
# Install dependencies
make install

# Run individual service
cd services/order-service
go run main.go

# Run all services
make run-all
```

### Kubernetes Deployment

```bash
# Build and push images
make build-push

# Deploy to Kubernetes
kubectl apply -f k8s/

# Check status
kubectl get pods -n ecommerce
```

---

## 📚 API Documentation

### Authentication

```bash
# Register
POST /api/v1/auth/register
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}

# Login
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Products

```bash
# List products
GET /api/v1/products?page=1&limit=20&category=electronics

# Get product details
GET /api/v1/products/{product_id}

# Create product (admin only)
POST /api/v1/products
{
  "name": "Wireless Headphones",
  "description": "High-quality audio",
  "price": 99.99,
  "category": "electronics",
  "stock": 100
}
```

### Orders

```bash
# Create order
POST /api/v1/orders
{
  "items": [
    {
      "product_id": "prod_123",
      "quantity": 2
    }
  ],
  "shipping_address": {
    "street": "123 Main St",
    "city": "New York",
    "zip": "10001"
  }
}

# Get order details
GET /api/v1/orders/{order_id}

# List user orders
GET /api/v1/orders/my-orders
```

---

## 📁 Project Structure

```
ecommerce-microservices/
├── services/
│   ├── api-gateway/
│   │   ├── main.go
│   │   ├── handlers/
│   │   ├── middleware/
│   │   └── Dockerfile
│   ├── auth-service/
│   │   ├── main.go
│   │   ├── models/
│   │   ├── handlers/
│   │   ├── repository/
│   │   └── Dockerfile
│   ├── product-service/
│   │   ├── main.go
│   │   ├── models/
│   │   ├── handlers/
│   │   ├── repository/
│   │   └── Dockerfile
│   ├── order-service/
│   │   ├── main.go
│   │   ├── models/
│   │   ├── handlers/
│   │   ├── events/
│   │   └── Dockerfile
│   ├── payment-service/
│   │   ├── main.go
│   │   └── Dockerfile
│   ├── inventory-service/
│   │   ├── main.go
│   │   └── Dockerfile
│   ├── notification-service/
│   │   ├── main.go
│   │   └── Dockerfile
│   └── shipping-service/
│       ├── main.go
│       └── Dockerfile
├── pkg/
│   ├── events/              # Event definitions
│   ├── models/              # Shared models
│   ├── utils/               # Utility functions
│   └── middleware/          # Shared middleware
├── proto/                   # Protocol Buffer definitions
├── k8s/                     # Kubernetes manifests
├── docker-compose.yml
├── Makefile
├── go.mod
└── README.md
```

---

## 🔄 Event Flow

### Order Processing Flow

```
1. User creates order
   ↓
2. Order Service → "order.created" event
   ↓
3. Payment Service processes payment
   ↓
4. Payment Service → "payment.completed" event
   ↓
5. Inventory Service reserves stock
   ↓
6. Inventory Service → "inventory.reserved" event
   ↓
7. Shipping Service creates shipment
   ↓
8. Notification Service sends confirmation
```

---

## 🧪 Testing

```bash
# Unit tests
make test

# Integration tests
make test-integration

# Load testing
make load-test

# Test coverage
make coverage
```

---

## 📊 Monitoring

- **Metrics:** Prometheus + Grafana
- **Tracing:** Jaeger
- **Logging:** ELK Stack
- **Alerting:** AlertManager

---

## 🔒 Security

- **Authentication:** JWT tokens
- **Authorization:** Role-based access
- **Encryption:** TLS 1.3
- **Secrets:** HashiCorp Vault
- **API Security:** Rate limiting, input validation

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## 📝 License

MIT License - see [LICENSE](./LICENSE)

---

<div align="center">

**Built with ❤️ by [bag864471-ux](https://github.com/bag864471-ux)**

⭐ Star this repo if you find it helpful!

</div>
