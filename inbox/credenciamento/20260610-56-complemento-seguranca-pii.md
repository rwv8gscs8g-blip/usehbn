---
titulo: Complemento de segurança — PII em planilhas e higiene do legado VBA
projeto: credenciamento
data: 2026-06-10
autoria: claude-fable-5 (arquiteto useHBN, corrente segurança+onboarding)
status: proposed
temperatura: quente
tipo-sugerido: guard + knowledge
evidencia: backup_bateria_oficial/ e historico/ (100+ .xlsm, 2026-03-25 a 2026-05-03); local-ai/vba_import/000-MANIFESTO-...-TOKEN.txt
---

# Proposta — projeto mais maduro no protocolo ganha o guard que falta

## Contexto

VBA/Excel + local-ai, v12 em estabilização pós-GATE-A4. ÚNICO projeto com
useHBN ativo de fato (`.hbn/`, `usehbn/`, inbox com 2 itens). Sem exposição
web. Diagnóstico foi INICIAL (não exaustivo): macros não auditadas linha a
linha.

## O que entra (complemento, não onboarding do zero)

1. **Guard de PII em artefato binário** — `.xlsm` com dados reais de
   empresas/CPF/CNPJ em `backup_bateria_oficial/` e backups versionáveis.
   Regra: planilha com dado real não entra em git; backup cifrado fora da
   árvore.
2. **forbid-env estendido a TXT de import** — o manifesto
   `local-ai/vba_import/000-MANIFESTO-V3-...-TOKEN.txt` menciona TOKEN em
   nome/conteúdo (natureza: pinagem de artefato; valor não verificado) —
   guard deve varrer `local-ai/vba_import/` também.

## Não verificado a fundo (honesto)

Auditoria de macros (Importador_V3.bas, Audit_Log.bas, forms de
credenciamento), criptografia de backups, controle de quem abre o xlsm.
Fica como onda futura de diagnóstico dedicado.

Item segue quente até consolidação + hearback.
