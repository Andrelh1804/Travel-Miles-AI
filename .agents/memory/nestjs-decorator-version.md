---
name: NestJS @Version decorator with TypeScript 5
description: @Version() como decorator de classe separado causa erro TS1238 no TypeScript 5; solução é inline no @Controller().
---

## Regra
Nunca usar `@Version("1")` como decorator separado em um controller NestJS com TypeScript 5+.

## Por que falha
TypeScript 5 introduziu tipagem estrita de decorators. `@Version()` do NestJS é tipado como `MethodDecorator`, e aplicá-lo a uma classe gera TS1238 ("The runtime will invoke the decorator with 1 argument, but the decorator expects 3").

## Como aplicar
```typescript
// ❌ Quebra com TS5
@Controller("auth")
@Version("1")
export class AuthController {}

// ✅ Correto
@Controller({ path: "auth", version: "1" })
export class AuthController {}
```

**Why:** TypeScript 5 strict decorator typing resolve o tipo do decorator pelo contexto de aplicação (classe vs método); `@Version` só é compatível inline no `@Controller`.
