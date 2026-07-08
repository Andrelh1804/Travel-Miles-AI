# TravelMiles AI

Plataforma SaaS para pesquisa de passagens aéreas, comparação por milhas, alertas de preço e planejamento de viagens com inteligência artificial.

## Run & Operate

### NestJS API
- `pnpm --filter @workspace/api run dev` — API NestJS (porta 8080)
- `pnpm --filter @workspace/api run build` — build de produção
- Workflow: **TravelMiles API (NestJS)**

### Next.js Web
- `pnpm --filter @workspace/web run dev` — frontend Next.js (porta 3000)
- `pnpm --filter @workspace/web run build` — build de produção
- Workflow: **TravelMiles Web (Next.js)**

### Workspace
- `pnpm install` — instalar dependências
- `pnpm run typecheck` — typecheck completo (libs + artifacts)
- `pnpm run build` — build de todos os pacotes

### Banco de dados (Supabase)
1. Acesse o SQL Editor do seu projeto no Supabase
2. Execute em ordem: `infrastructure/database/migrations/001_initial_schema.sql`
3. Execute: `infrastructure/database/migrations/002_indexes.sql`
4. Execute: `infrastructure/database/migrations/003_triggers_and_rls.sql`
5. (Opcional) Execute seeds em `infrastructure/database/seeds/`

## Stack

- **Backend:** NestJS 10, Express, TypeScript (CommonJS)
- **Frontend:** Next.js 15, React 19, Tailwind CSS, Supabase SSR
- **Banco:** PostgreSQL (Supabase) com Row Level Security
- **Auth:** Supabase Auth (email, OAuth Google/Apple, MFA)
- **Monorepo:** pnpm workspaces, Node.js 24, TypeScript 5.9

## Onde ficam as coisas

| Caminho | Descrição |
|---|---|
| `apps/api/` | API NestJS — módulos, guards, filtros, interceptors |
| `apps/api/src/modules/` | Módulos de negócio (auth, users, health…) |
| `apps/web/` | Frontend Next.js com App Router |
| `packages/types/` | Tipos TypeScript compartilhados entre apps |
| `packages/config/` | Schema Zod de variáveis de ambiente |
| `infrastructure/database/migrations/` | SQL das migrações (executar no Supabase) |
| `infrastructure/database/seeds/` | Dados iniciais (aeroportos, cias, milhas) |
| `docs/architecture.md` | Arquitetura completa |
| `docs/adr/` | Architecture Decision Records |

## Variáveis de Ambiente Necessárias

Copie `.env.example` e preencha:

### API (`apps/api`)
- `SUPABASE_URL` — URL do projeto Supabase
- `SUPABASE_ANON_KEY` — chave pública (anon)
- `SUPABASE_SERVICE_ROLE_KEY` — chave privada (service role) — nunca expor ao cliente
- `SUPABASE_JWT_SECRET` — segredo JWT do projeto
- `SESSION_SECRET` — string aleatória ≥32 caracteres

### Web (`apps/web`)
- `NEXT_PUBLIC_SUPABASE_URL` — igual ao SUPABASE_URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — igual ao SUPABASE_ANON_KEY

## Arquitetura Resumida

```
apps/api (NestJS)
  └── auth      → registro, login, OAuth, refresh token
  └── users     → perfil, soft delete (LGPD)
  └── health    → GET /api/v1/health
  └── database  → SupabaseService (global)

apps/web (Next.js)
  └── / → landing page
  └── /auth/login, /auth/register
  └── /dashboard → painel do usuário
  └── /auth/callback → OAuth callback
```

## Fases do Projeto

| Fase | Módulo | Status |
|------|--------|--------|
| 1 | Fundação: auth, schema, segurança, monorepo | ✅ Completa |
| 2 | Pesquisa de passagens e comparador | 📋 Próxima |
| 3 | Alertas, milhas e planejamento | 📋 Pendente |
| 4 | Pagamentos (Stripe + Mercado Pago) e admin | 📋 Pendente |
| 5 | Assistente IA e previsão de preços | 📋 Pendente |

## User preferences

- Stack definida: NestJS (backend) + Next.js (frontend) + Supabase
- Idioma da documentação e comentários: Português (Brasil)
- Desenvolver por fases — aguardar autorização antes de iniciar próxima fase

## Gotchas

- NestJS usa CommonJS (`apps/api/tsconfig.json`) — **não** estende `tsconfig.base.json` (que usa ESM)
- `SUPABASE_SERVICE_ROLE_KEY` é usada apenas no backend (`SupabaseService.admin`) — nunca no cliente
- Execute as migrations no Supabase **antes** de iniciar a API em produção
- `onlyBuiltDependencies` em `pnpm-workspace.yaml` inclui `@nestjs/core` e `sharp`
- Porta 8080 → API NestJS | Porta 3000 → Next.js web
