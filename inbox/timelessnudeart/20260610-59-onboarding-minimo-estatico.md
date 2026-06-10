---
titulo: Onboarding mínimo para site estático — timelessnudeart-com
projeto: timelessnudeart
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: proposed
temperatura: quente
tipo-sugerido: knowledge
evidencia: timelessnudeart-com/ (index.html + timeless-site-corrigido/); achados análogos na cópia em timelessphoto.art/public/timeless-site/
---

# Proposta — cerimônia mínima, proporcional a HTML estático

## Contexto

Site estático (HTML + embeds). Diagnóstico INICIAL e por analogia: a cópia
irmã dentro de timelessphoto.art/public/ usa embed Prodibi sem SRI
(index.html:86 da cópia) e forms JotForm hardcoded. **Este repo em si não
foi verificado a fundo** — fica dito com todas as letras.

## O que entra (mínimo)

1. **Checklist estático no deploy** (não guard automatizado): SRI nos
   scripts third-party, links de form verificados, nenhum dado de modelo
   (release, contato) commitado.
2. SEM `.hbn/` por ora — projeto de baixa mudança não paga cerimônia.
   Reavaliar se ganhar backend.

Item segue quente até consolidação + hearback.
