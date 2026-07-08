---
name: PostgreSQL audit trigger TG_OP vs enum case
description: TG_OP retorna maiúsculas (INSERT/UPDATE/DELETE); cast direto para enum minúsculo quebra silenciosamente.
---

## Regra
Nunca fazer cast direto `TG_OP::audit_action` se o enum usa minúsculas. Sempre usar CASE explícito.

**Why:** `TG_OP` em PostgreSQL sempre retorna `'INSERT'`, `'UPDATE'`, `'DELETE'` (maiúsculas). Um enum definido como `'create','update','delete'` (minúsculas) causará erro de cast em produção, quebrando writes auditados (signup, pagamentos).

## Como aplicar
```sql
DECLARE v_action audit_action;
BEGIN
  v_action := CASE TG_OP
    WHEN 'INSERT' THEN 'create'::audit_action
    WHEN 'UPDATE' THEN 'update'::audit_action
    WHEN 'DELETE' THEN 'delete'::audit_action
  END;
```
