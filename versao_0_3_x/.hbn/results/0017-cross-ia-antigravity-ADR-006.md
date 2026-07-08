# Parecer Antigravity — ADR-006 Sinais HBN multi-repo

**Auditor:** antigravity (Gemini 3.1)
**Session role:** cross-ia-review-usehbn
**Reviewed at:** 2026-05-09

## Veredito conceitual

`APROVADO_SEM_RESSALVA`

## Coerência com P1-P13

| Princípio | Apoiado | Em tensão | Comentário |
|---|---|---|---|
| P8 (Protocolo > Ferramenta) | sim | não | Convenções baseadas em texto/emoji agnósticas a ferramenta. |

## Comparação com precedentes externos

Sistemas operacionais de larga escala usam primitivas visuais para transmitir lock de estado (ex: badges de CI do GitHub, semáforos, *gitmoji*).

## Tensões filosóficas detectadas

A proliferação de símbolos visuais. Saltamos para ~15 sinais. Existe um risco inerente de os marcadores passarem de "ajudantes de clareza" para "hieróglifos esotéricos" que exigem consulta a um glossário a cada turno.

## Risco antropológico/cultural

Fadiga cognitiva. Os IAs processam 15 emojis perfeitamente, mas o operador humano começará a filtrá-los mentalmente (cegueira atencional).

## Recomendação para humano

`RATIFICAR`

## Comentário livre

Conceitualmente, os sinais são as "syscalls" do ecossistema HBN. Eles formalizam lock `🌐`, dependência `⛓️` e deriva `🪞`. O ADR resolve um problema operacional urgente. Apenas recomendo (como ajuste futuro, não bloqueante para este ADR) condensar a exibição para que apenas os 3 mais relevantes apareçam ativamente nos headers de chat, reduzindo ruído visual. Defiro a viabilidade das regexes destes sinais ao Codex.

> **Nota da consolidação cross-IA:** Codex achou colisão visual: 🟠 já é usado para `HBN SOURCE DRIFT` (sinal antigo), e ADR-006 propõe 🟠 para `HBN BILLING WINDOW DRIFT`. Esta colisão precisa resolução antes de ACCEPTED — ver `0007-cross-ia-codex-ADR-006.json` e consolidação 05.
