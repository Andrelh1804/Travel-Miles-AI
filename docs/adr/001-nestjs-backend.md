# ADR-001: NestJS como framework do backend

**Status:** Aceito  
**Data:** 2026-07

## Contexto

O backend da plataforma precisava de um framework Node.js que suportasse:
- Arquitetura modular escalável (Clean Architecture + DDD)
- Injeção de dependências nativa
- Suporte a decorators (Guards, Interceptors, Filters)
- Documentação automática (Swagger/OpenAPI)
- Testabilidade (módulos isoláveis, mocking simples)

## Decisão

Adotar **NestJS v10** como framework do backend, substituindo Express puro.

## Consequências

**Positivas:**
- Estrutura modular que força separação de responsabilidades
- DI nativa elimina acoplamento manual
- `@nestjs/swagger` gera docs OpenAPI automaticamente a partir dos DTOs
- Ecossistema maduro: `@nestjs/throttler`, `@nestjs/config`, `@nestjs/testing`
- Facilita crescimento para microservices (NestJS suporta múltiplos transportes)

**Negativas:**
- tsconfig próprio (CommonJS, `emitDecoratorMetadata`) — não compartilha base com packages ESM
- Build mais lento que esbuild puro (compensa com `--watch` em dev)
- Curva de aprendizado maior para desenvolvedores vindos de Express puro
