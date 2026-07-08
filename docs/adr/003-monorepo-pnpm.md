# ADR-003: pnpm workspaces como gerenciador do monorepo

**Status:** Aceito  
**Data:** 2026-07

## Contexto

O projeto possui múltiplas apps (API, Web) e pacotes compartilhados (types, config). Precisávamos de uma solução para gerenciar dependências e builds de forma eficiente.

## Decisão

Manter **pnpm workspaces** como gerenciador do monorepo, adicionando `apps/*` e `packages/*` à configuração existente.

## Consequências

**Positivas:**
- `@workspace/types` compartilhado entre API (CommonJS) e Web (ESM) sem duplicação
- `catalog:` no `pnpm-workspace.yaml` pina versões críticas (react, zod, typescript)
- `minimumReleaseAge: 1440` protege contra supply-chain attacks
- Sem necessidade de ferramentas externas (Turborepo, Nx) para este escopo

**Negativas:**
- NestJS (CommonJS) e Next.js/lib (ESM) têm tsconfigs separados — não pode usar o base para NestJS
- Paths `@workspace/*` em `tsconfig.json` precisam ser duplicados por pacote
