# Especificações de Migração: Projeto Horta 🌿

Este documento detalha o plano de migração do Horta (originalmente em React/Firebase) para uma arquitetura robusta utilizando **Flutter** no frontend e **Microserviços em Go (Golang)** no backend.

---

## 🏗️ Arquitetura Alvo

- **Frontend:** Flutter (Web & Mobile)
- **Backend:** Go Microservices
- **Orquestração de Microserviços:** Dapr (Distributed Application Runtime)
- **Mensageria/Eventos:** Dapr Pub/Sub (Redis)
- **Banco de Dados:** 
  - **Firestore (Main DB):** Persistência de Usuários, Pesquisas, Respostas e Chat em tempo real.
  - **Redis:** Cache e gerenciamento de estado Dapr.
- **Infraestrutura:** Docker Compose (Local) / Kubernetes (Cloud).
- **CI/CD:** GitHub Actions.

---

## 💎 Estratégia de Economia de Tokens (Token Save)

Para otimizar o uso da API Gemini e reduzir custos operacionais:

1. **Cache de Análises:** As respostas geradas pela IA para cada pesquisa são salvas no Firestore na coleção `survey_analyses`.
2. **Reutilização Inteligente:** Quando um usuário acessa uma pesquisa, o sistema primeiro verifica se já existe uma análise para aquele `surveyId`, `idioma` e `filtro de país`.
3. **Trigger de Atualização:** A análise só é regenerada automaticamente se o número de respostas (`responseCount`) tiver aumentado desde a última análise salva, ou se um administrador solicitar a atualização manual ("Recalculate").
4. **Formato Dual:** Salva-se o `summary` (Markdown) para exibição imediata e `insights` (JSON) para processamento programático futuro.

---

## 📱 SPEC 01 — Flutter Frontend Setup

### Core Checks
- [ ] **Ambiente:** Flutter SDK ^3.24.0.
- [ ] **Plataformas:** Web, Android, iOS.
- [ ] **Stack:**
  - `flutter_bloc`: Gerenciamento de estado (Bloc/Cubit).
  - `get_it`: Service Locator para DI.
  - `go_router`: Navegação declarativa.
  - `dio`: Cliente HTTP para API Go.
  - `cloud_firestore`: Integração direta para recursos de tempo real (opcional / se necessário).
  - `firebase_auth`: Autenticação social.
  - `google_fonts`: Inter e Space Grotesk.

### Design System (Horta DNA)
- [ ] **ThemeData:** Dark mode obrigatório (`#020402`).
- [ ] **Cores:** Primary `Emerald-500` (`#10b981`), Surface `white.withOpacity(0.05)`.
- [ ] **Widgets:** 
  - `BentoCard`: Custom widget com `borderRadius: 40.0`, backdrop blur e bordas sutis.
  - `PlantProgressBar`: Indicador de "Gotas" com gradiente esmeralda.

### Estrutura de Pastas
```
lib/
├── app/
│   ├── core/           # Interfaces, DI, Network, Theme
│   ├── data/           # Models (DTOs), API Clients
│   ├── domain/         # Repositories, Entities, UseCases
│   └── modules/        # Bloc, Widgets, Screens
│       ├── garden/     # Gamificação e Perfil
│       ├── nursery/    # Listagem de Pesquisas
│       └── lab/        # Insights IA e Chat
└── main.dart
```

---

## ⚙️ SPEC 02 — Go Backend Service (Survey Service)

### Requisitos Técnicos
- [ ] **Language:** Go 1.22+.
- [ ] **Framework:** Gin-Gonic ou Echo (HTTP).
- [ ] **Firebase Admin SDK:** `firebase.google.com/go/v4` para integração com Firestore.
- [ ] **Dapr Integration:** SDK Go para Dapr (State management & Pub/Sub).

### Microserviços Identificados
1. **Survey Service:** Gerencia CRUD de pesquisas e validações via Firestore.
2. **Response Service:** Processa respostas e dispara eventos de gamificação.
3. **Gamification Service:** Calcula XP ("Drops") e Níveis via triggers ou Dapr Pub/Sub.
4. **AI Gateway:** Proxy para a API Gemini 1.5 Flash.

---

## 💾 SPEC 03 — Estrutura Firestore (Current State)

O backend em Go deve manter a estrutura NoSQL atual para garantir compatibilidade com os dados existentes:

### Coleção `users` (Documento p/ UID)
- `email`: string
- `xp`: integer
- `level`: integer
- `isAdmin`: boolean

### Coleção `surveys`
- `title`: map { en, pt, es }
- `questions`: array of objects
- `active`: boolean

### Coleção `responses`
- `surveyId`: string
- `respondentId`: string
- `answers`: map
- `createdAt`: serverTimestamp

---

## 🛠️ SPEC 04 — Infraestrutura Docker Compose

```yaml
services:
  survey-api:
    build: ./services/survey
    environment:
      - GOOGLE_APPLICATION_CREDENTIALS=/app/firebase-key.json
    depends_on:
      - redis
      - dapr-sidecar

  dapr-sidecar:
    image: "daprio/daprd:latest"
    command: ["./daprd", "-app-id", "survey-api", "-app-port", "8080"]

  redis:
    image: redis:7
```

---
*Este documento é a especificação técnica para a migração total do ecossistema Horta.*
