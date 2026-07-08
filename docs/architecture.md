# TravelMiles AI — Arquitetura Técnica

## Visão Geral

TravelMiles AI é uma plataforma SaaS full-stack para pesquisa de passagens aéreas, comparação por milhas, alertas de preço e planejamento de viagens com IA.

## Estrutura do Monorepo

```
travelmiles-ai/
├── apps/
│   ├── api/            # NestJS — API REST v1, autenticação, lógica de negócio
│   └── web/            # Next.js 15 — frontend com App Router e SSR
├── packages/
│   ├── types/          # Tipos TypeScript compartilhados entre apps
│   └── config/         # Esquema de variáveis de ambiente (Zod)
├── infrastructure/
│   └── database/
│       ├── migrations/ # SQL puro (Supabase SQL Editor ou CLI)
│       └── seeds/      # Dados iniciais (aeroportos, cias, programas)
├── docs/
│   ├── architecture.md # Este arquivo
│   └── adr/            # Architecture Decision Records
└── artifacts/          # Apps legados / mockups Replit
```

## Stack Tecnológica

| Camada         | Tecnologia                         |
|----------------|------------------------------------|
| Frontend       | Next.js 15, React 19, Tailwind CSS |
| Backend        | NestJS 10, Express, TypeScript     |
| Banco de Dados | PostgreSQL (Supabase)              |
| Autenticação   | Supabase Auth (JWT, OAuth, MFA)    |
| Cache          | Redis (Fase 2)                     |
| Pagamentos     | Stripe + Mercado Pago (Fase 4)     |
| IA             | OpenAI / Gemini (Fase 5)           |
| Monorepo       | pnpm workspaces                    |

## Arquitetura da API (NestJS)

```
src/
├── main.ts                     # Bootstrap: segurança, Swagger, validação global
├── app.module.ts               # Módulo raiz
└── modules/
    ├── health/                 # GET /api/v1/health
    ├── database/               # SupabaseService (global)
    ├── auth/                   # POST /api/v1/auth/*
    ├── users/                  # GET/PATCH/DELETE /api/v1/users/me
    ├── flights/                # (Fase 2) Pesquisa e comparação
    ├── alerts/                 # (Fase 3) Sistema de alertas
    ├── loyalty/                # (Fase 3) Milhas e programas
    ├── trips/                  # (Fase 3) Planejamento
    ├── payments/               # (Fase 4) Stripe / Mercado Pago
    └── admin/                  # (Fase 4) Painel administrativo
```

### Padrões Implementados

- **Clean Architecture**: separação em módulos independentes com responsabilidades únicas
- **Repository Pattern**: acesso ao Supabase encapsulado em services/repositories
- **SOLID**: cada módulo tem responsabilidade única, aberto para extensão
- **Guards globais**: `SupabaseAuthGuard` + `RolesGuard` aplicados em toda a API
- **Interceptors**: `LoggingInterceptor` (correlação por requestId) + `TransformInterceptor` (envelope `{ success, data, timestamp }`)
- **Filters**: `AllExceptionsFilter` com formato de erro padronizado e sem vazamento de stack trace em produção

## Arquitetura do Banco de Dados

### Entidades Principais

```
users ──── alerts ──── notifications
  │          │
  ├── miles_accounts ── loyalty_programs ── airlines
  ├── trips ─── trip_segments ─── flights
  ├── favorites ─────────────────── │
  ├── search_history                │
  └── subscriptions ── payments   airports
```

### Segurança de Dados

- **Row Level Security (RLS)**: habilitado em todas as tabelas de usuários
- **Audit Log**: trigger automático para `users`, `subscriptions` e `payments`
- **Soft Delete**: `deleted_at` em `users` para conformidade com LGPD
- **Trigger de signup**: `handle_new_user()` sincroniza `auth.users` → `public.users`

## Autenticação

```
Cliente → [Supabase Auth]
              │
              ├── Email/senha
              ├── OAuth (Google, Apple)
              └── MFA (TOTP)
              │
              ↓ JWT
API (NestJS) → [SupabaseAuthGuard]
                    │ verifica JWT via supabase.auth.getUser(token)
                    ↓
              [RolesGuard] → autorização por role (user | admin | super_admin)
```

## Segurança

| Medida                | Implementação                         |
|-----------------------|---------------------------------------|
| Headers de segurança  | `helmet` em `main.ts`                 |
| CORS                  | origins explícitos por env            |
| Rate Limiting         | `@nestjs/throttler` (3 camadas)       |
| Validação de entrada  | `class-validator` + ValidationPipe    |
| RLS no banco          | Políticas Supabase por usuário        |
| Env validation        | Zod na inicialização da API           |
| Audit trail           | `audit_logs` via trigger automático   |
| LGPD                  | Soft delete + direito ao esquecimento |

## Variáveis de Ambiente Necessárias

```bash
# API (apps/api)
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
SUPABASE_JWT_SECRET=
SESSION_SECRET=           # min 32 chars
ALLOWED_ORIGINS=          # CSV de origens permitidas
PORT=8080

# Web (apps/web)
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
NEXT_PUBLIC_API_URL=
NEXT_PUBLIC_APP_URL=
```

## Fases de Desenvolvimento

| Fase | Descrição                                     | Status      |
|------|-----------------------------------------------|-------------|
| 1    | Fundação: auth, schema, segurança, monorepo   | ✅ Completa |
| 2    | Pesquisa de passagens e comparador            | 📋 Pendente |
| 3    | Alertas, milhas e planejamento                | 📋 Pendente |
| 4    | Pagamentos, assinaturas, painel admin         | 📋 Pendente |
| 5    | Assistente IA, previsão de preços             | 📋 Pendente |
