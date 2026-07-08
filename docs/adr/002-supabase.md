# ADR-002: Supabase como plataforma de banco de dados e autenticação

**Status:** Aceito  
**Data:** 2026-07

## Contexto

A plataforma precisava de:
- PostgreSQL gerenciado com Row Level Security
- Autenticação completa (email, OAuth, MFA) sem implementar do zero
- Storage para avatares e assets
- Realtime para futuras notificações push

## Decisão

Adotar **Supabase** como solução completa de backend-as-a-service para banco de dados, autenticação e storage.

## Consequências

**Positivas:**
- RLS no banco garante segurança por design — dados de um usuário nunca vazam para outro
- Auth completa com OAuth (Google, Apple) e MFA sem manter infraestrutura
- `@supabase/ssr` simplifica auth em Next.js App Router (server/client components)
- Dashboard do Supabase permite inspecionar dados em produção com segurança
- Trigger automático `handle_new_user()` sincroniza `auth.users` → `public.users`

**Negativas:**
- Dependência de serviço externo — mitigada por PostgreSQL padrão (portável)
- Supabase service role key precisa ser protegida no backend (nunca exposta ao cliente)
- Limites de plano gratuito podem exigir upgrade conforme escala
