---
name: Next.js route groups vs URL path for auth routes
description: (auth) route group remove o segmento da URL; páginas ficam em /login não /auth/login.
---

## Regra
Se todos os links apontam para `/auth/login` e `/auth/register`, criar os arquivos em `app/auth/login/page.tsx` e `app/auth/register/page.tsx`, **não** em `app/(auth)/login/page.tsx`.

**Why:** Parênteses em route groups (`(auth)`) são removidos do URL pelo Next.js. `app/(auth)/login/page.tsx` → `/login`. `app/auth/login/page.tsx` → `/auth/login`. Misturar os dois cria 404s silenciosos.

## Como aplicar
- Estrutura correta para rotas `/auth/*`:
  - `app/auth/login/page.tsx`
  - `app/auth/register/page.tsx`
  - `app/auth/callback/route.ts`
  - `app/auth/signout/route.ts`
- Middleware deve proteger `/auth/callback` e `/auth/signout` para não redirecionar usuários autenticados nessas rotas especiais.
