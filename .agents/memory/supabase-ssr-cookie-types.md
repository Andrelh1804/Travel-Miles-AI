---
name: @supabase/ssr cookie handler types
description: Tipos corretos para os callbacks getAll/setAll do createServerClient em Next.js App Router.
---

## Regra
Importar `CookieOptions` (não `CookieOptionsWithName`) de `@supabase/ssr`. O parâmetro de `setAll` é `{ name: string; value: string; options: CookieOptions }[]`.

**Why:** `CookieOptionsWithName` nessa versão é `{ getAll, setAll }` (métodos), não `{ name, value }`. O tipo real do callback é `SetAllCookies = (cookies: { name, value, options }[]) => void`.

## Como aplicar
```typescript
import type { CookieOptions } from "@supabase/ssr";

// server.ts
setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
  try {
    cookiesToSet.forEach(({ name, value, options }) => cookieStore.set(name, value, options));
  } catch {}
}

// middleware.ts
setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
  cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
  supabaseResponse = NextResponse.next({ request });
  cookiesToSet.forEach(({ name, value, options }) => supabaseResponse.cookies.set(name, value, options));
}
```
