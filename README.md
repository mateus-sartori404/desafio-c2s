# 🚗 Desafio C2S - Sistema de Web Scraping de Veículos

Sistema de web scraping de anúncios de veículos da Webmotors, construído com arquitetura de microsserviços em Ruby on Rails.

## 📊 Arquitetura do Sistema

![Arquitetura dos Microsserviços](docs/architecture.png)

### Fluxo de Dados

![Fluxo de Sequência](docs/flow-sequence.png)

### Infraestrutura Docker

![Infraestrutura](docs/infrastructure.png)

---

## 🏗️ Visão Geral dos Serviços

| Serviço | Porta | Responsabilidade |
|---------|-------|------------------|
| **webscraping-manager** | 3000 | Frontend (Vue.js) + Orquestração de tarefas |
| **auth-service** | 3001 | Autenticação JWT + Gestão de usuários |
| **notification-service** | 3002 | WebSockets (Action Cable) + Notificações |
| **scraping-processor** | 3003 | Processamento de scraping com Sidekiq |

---

## 🛠️ Stack Tecnológica

### Backend
- **Ruby** 3.4.1
- **Rails** 8.0.2
- **PostgreSQL** 15
- **Redis** 7
- **Sidekiq** (jobs assíncronos)

### Frontend
- **Vue.js 3** + Vuetify 3
- **Inertia.js** (SPA sem API)
- **Vite** (build tool)

### Web Scraping
- **Ferrum** (Chrome headless)
- **Nokogiri** (parsing HTML)

### Infraestrutura
- **Docker** + Docker Compose
- **Action Cable** (WebSockets)

---

## 🚀 Como Executar

### Pré-requisitos
- Docker 20+
- Docker Compose 2+

### Subir o ambiente

```bash
# Clonar o repositório
git clone https://github.com/mateus-sartori404/desafio-c2s.git
cd desafio-c2s

# Subir todos os serviços
docker-compose up --build
```

### Acessar os serviços

| Serviço | URL |
|---------|-----|
| Aplicação Principal | http://localhost:3000 |
| Auth Service | http://localhost:3001 |
| Notification Service | http://localhost:3002 |
| Scraping Processor | http://localhost:3003 |
| Sidekiq Dashboard | http://localhost:3003/sidekiq |

---

## 📡 Endpoints da API

### Auth Service (porta 3001)

#### Registro de Usuário
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "user": {
    "email": "usuario@email.com",
    "password": "senha123",
    "password_confirmation": "senha123"
  }
}
```

#### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "user": {
    "email": "usuario@email.com",
    "password": "senha123"
  }
}
```

**Resposta:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "usuario@email.com"
  }
}
```

### Notification Service (porta 3002)

#### Criar Notificação
```http
POST /api/v1/notifications
Content-Type: application/json

{
  "notification": {
    "event_type": "task_completed",
    "task_id": 1,
    "user": { "id": 1, "email": "user@email.com" },
    "data": { "brand": "BMW", "model": "X2", "price": "R$ 350.000" }
  }
}
```

### Scraping Processor (porta 3003)

#### Iniciar Scraping
```http
POST /api/v1/scraping_tasks
Content-Type: application/json

{
  "task_id": 1,
  "url": "https://www.webmotors.com.br/comprar/bmw/x2/..."
}
```

---

## 🔔 Eventos de Notificação

O sistema emite 3 tipos de eventos via WebSocket:

| Evento | Quando |
|--------|--------|
| `task_created` | Tarefa criada pelo usuário |
| `task_completed` | Scraping finalizado com sucesso |
| `task_failed` | Scraping falhou |

---

## 🗄️ Estrutura do Banco de Dados

### webscraping-manager (tasks)
```
┌─────────────────────────────────────┐
│ tasks                               │
├─────────────────────────────────────┤
│ id            │ bigint (PK)         │
│ title         │ string              │
│ url           │ string              │
│ status        │ integer (enum)      │
│ result        │ jsonb               │
│ error_message │ text                │
│ user_id       │ bigint              │
│ created_at    │ timestamp           │
│ updated_at    │ timestamp           │
└─────────────────────────────────────┘
```

### auth-service (users)
```
┌─────────────────────────────────────┐
│ users                               │
├─────────────────────────────────────┤
│ id              │ bigint (PK)       │
│ email           │ string (unique)   │
│ password_digest │ string            │
│ created_at      │ timestamp         │
│ updated_at      │ timestamp         │
└─────────────────────────────────────┘
```

### notification-service (notifications)
```
┌─────────────────────────────────────┐
│ notifications                       │
├─────────────────────────────────────┤
│ id         │ bigint (PK)            │
│ event_type │ string                 │
│ task_id    │ bigint                 │
│ user_data  │ jsonb                  │
│ data       │ jsonb                  │
│ created_at │ timestamp              │
│ updated_at │ timestamp              │
└─────────────────────────────────────┘
```

---

## 📁 Estrutura de Pastas

```
desafio-c2s/
├── auth-service/              # Microsserviço de autenticação
│   ├── app/
│   │   ├── controllers/api/v1/
│   │   ├── models/
│   │   └── services/
│   └── Dockerfile
│
├── notification-service/      # Microsserviço de notificações
│   ├── app/
│   │   ├── channels/
│   │   ├── controllers/api/v1/
│   │   └── models/
│   └── Dockerfile
│
├── scraping-processor/        # Microsserviço de scraping
│   ├── app/
│   │   ├── controllers/api/v1/
│   │   ├── jobs/
│   │   └── services/
│   └── Dockerfile
│
├── webscraping-manager/       # Aplicação principal (frontend)
│   ├── app/
│   │   ├── clients/
│   │   ├── controllers/
│   │   ├── javascript/
│   │   │   ├── components/
│   │   │   ├── Layouts/
│   │   │   └── pages/
│   │   ├── models/
│   │   └── repository/
│   └── Dockerfile
│
├── docs/                      # Documentação e diagramas
│   ├── architecture.png
│   ├── flow-sequence.png
│   └── infrastructure.png
│
├── docker-compose.yml         # Orquestração dos containers
└── README.md                  # Este arquivo
```

---

## ⚙️ Variáveis de Ambiente

| Variável | Serviço | Descrição |
|----------|---------|-----------|
| `DATABASE_URL` | Todos | URL de conexão PostgreSQL |
| `REDIS_URL` | scraping-processor | URL de conexão Redis |
| `JWT_SECRET_KEY` | auth-service, webscraping-manager | Chave secreta para JWT |
| `AUTH_SERVICE_URL` | webscraping-manager | URL do serviço de auth |
| `NOTIFICATION_SERVICE_URL` | webscraping-manager, scraping-processor | URL do serviço de notificações |
| `SCRAPING_PROCESSOR_URL` | webscraping-manager | URL do processador de scraping |

---

## 👤 Autor

**Seu Nome**
- GitHub: [@mateus-sartori404](https://github.com/mateus-sartori404)
- Email: mateus-sartori404@gmail.com