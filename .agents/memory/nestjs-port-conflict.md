---
name: NestJS API port — conflict with artifacts/api-server
description: artifacts/api-server ocupa porta 8080; NestJS (apps/api) deve usar 8000.
---

## Regra
NestJS (`apps/api`) usa **porta 8000**. O artifact legado `artifacts/api-server` está fixo em **8080**.

**Why:** Ambos os workflows são iniciados no mesmo container. Não modificar a porta do artifact para evitar quebrar o proxy do Replit.

## Como aplicar
Workflow configurado como: `PORT=8000 pnpm --filter @workspace/api run dev`
