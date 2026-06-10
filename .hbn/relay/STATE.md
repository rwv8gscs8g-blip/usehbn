---
state_version: 1
projeto: usehbn (canônico)
protocolo: "HBN 0.3.0 (bump 0.3.1 adiado — nota 20260610-34)"
onda_atual: "corrente E — fechamento Blocos 3-6 adotado (ADR-021/022/023 + G-SLF/G-HRB/G-REG + suite 33) por readback 0003"
proprietario_bastao: claude-fable-5
papel_bastao: arquiteto (bastão devolvido após consolidação Codex do fechamento E)
papeis:
  arquiteto: "claude-fable-5 — implementou a corrente E inteira (50% + fechamento); por ADR-018 NÃO a audita"
  auditor_validador_fixo: "claude-opus-4-8 (Cowork) — validador fixo EM PROSA; fora do campo mecânico `auditores` até o hearback 0002 ser confirmado (correção F-04)"
  gate_humano: "Maurício — confirmou o readback 0003; mantém F-05 por revisão visual do diff de .hbn/hearbacks/ (ADR-023 Decisão 1c)"
proxima_acao: "claude-fable-5: retomar o bastão após a adoção do fechamento E; planejar a próxima onda sem ativar guards no runner antes dos testes negativos dos 5 guards legados"
sinais_abertos:
  - "🟢 HBN CHECKPOINT CLEAN — fechamento E adotado por readback 0003; suíte 33/33 verde no commit de adoção"
  - "🔵 HBN HANDOFF READY — bastão devolvido a claude-fable-5 após adoção Codex"
  - "🟢 DOGFOOD: G-SLF/G-REG corrigidos validam STAGED local e HEAD em CI; 0029 removeu E-FECH-01/02"
  - "🟡 guards novos/endurecidos continuam fora do runner; ativação futura exige testes negativos dos 5 guards legados"
  - "🟡 hearback 0002 (exceção fable×opus) DRAFT pendente de assinatura — até lá opus-4-8 fora do campo mecânico auditores"
  - "🟡 hearback em lote H1–H6 da corrente D PENDENTE — pareceres 0021/0022 entregues"
  - "🟡 bump 0.3.1 adiado para onda de auditoria __version__×PROTOCOL_VERSION (nota 20260610-34)"
  - "🟡 inbox/credenciamento com 2 propostas não consolidadas (20260610-01-0017-parametrica, 20260610-44-freeze-gate-v206)"
  - "🟡 backlog: assinatura GPG/SSH de hearbacks (eleva aviso de autor do G-HRB a bloqueio — ADR-023 Decisão 4); testes negativos dos 5 guards legados (onda de ativação do runner); F-05 renumeração da faxina 36 antes de H2; F-07 semântica de proprietario_bastao quando próxima ação é humana; 0022/F-05 G-FAM cruzar STATE completo (bastao×chapeu); gate script versionado do dual-run (0021/F-06); decidir versionamento de .hbn/readbacks/; resolver colisão de numeração readback 0002 × hearback 0002"
readback_ativo: ".hbn/readbacks/0003-adocao-corrente-e-fechamento.json (adoção fechamento E — confirmado)"
handoff_mais_recente: ".hbn/messages/20260610-05-fix-staged-skew-fable5.md"
ancora_rollback: "5f0aea3 (checkpoint fix staged-skew antes da adoção fechamento E)"
ancora_estavel: "9a9cb11 (release 0.3.0 — C1-C7 ratificados)"
ciclo_ativo: "corrente E: 50% adotada (e876060) + fechamento adotado por readback 0003; corrente D segue pendente nos itens H1-H6"
ultima_atualizacao: "2026-06-10T20:12:24-03:00"
atualizado_por: codex
atribuicao:
  chapeu_atual: consolidador
  implementador: codex
  auditores: [codex, gemini-3-5]
  gravada_em: "2026-06-10T20:12:24-03:00"
  hearback_ref: ".hbn/readbacks/0003-adocao-corrente-e-fechamento.json"
---

Nota da onda (adoção fechamento E, readback 0003): a re-auditoria 0027
(Codex) vetou o fechamento pre-fix com 2 bloqueadores reais — G-SLF e G-REG
validavam a working tree enquanto o commit leva o staged. O fix cirúrgico
foi entregue em 5f0aea3: G-SLF lê o blob staged (git show :path; HEAD:path
em CI) e G-REG grepa o REGISTRY staged (git show :REGISTRY.md). A
re-auditoria 0029 derrubou o veto no escopo E-FECH-01/02: suíte 33/33,
prova adversarial 4/4 e caminho CI validado. E-FECH-03 ("mesmo autor") não
entra: ADR-023 mantém como AVISO + revisão humana do diff de hearbacks +
GPG/SSH no backlog. Maurício confirmou o readback 0003; ADR-021/022/023,
G-SLF/G-HRB, hardening G-REG, suíte 33, templates e freeze-gate-spec §2.2
foram adotados sem ativar guards no runner. Bastão devolvido a
claude-fable-5.

Nota da onda anterior: o fechamento da corrente E entregou os Blocos 3-6.
Bloco 3 (ADR-021 + G-SLF): todo artefato novo declara `path:`; guard bloqueia
auto-localização mentirosa e artefato governado mudo; templates atualizados.
Bloco 4 (ADR-022): parecer de auditoria é markdown legível (veredito,
findings por severidade com evidência, recomendação por hearback, resumo
≤10 linhas); JSON é anexo de máquina; todo ciclo termina listando caminhos.
Bloco 5 (ADR-023 + G-HRB): hearback só vale commitado pelo humano em commit
puro ANTERIOR à mudança; G-HRB bloqueia auto-assinatura (mesmo commit),
commit impuro e hearback não commitado; critério de autor rebaixado a AVISO
com justificativa explícita enquanto a identidade git for única (limite
honesto, ADR-023 Decisão 3); elevação GPG/SSH no backlog. Bloco 6: G-REG com
diff-filter=AR (0026/F-01) e órfãos em docs/**+methodology/** (0026/F-04);
negativos de models/workflows adicionados (0025/E-RE-01); freeze-gate-spec
§2.2 explicitado (0025/E-RE-02); o F-02 da 0026 NÃO procede (case bash cruza
"/") e virou teste que PROVA a cobertura. Suíte 15→29, 29/29 verde em
sandbox. Dogfood: artefatos novos nascem com `path:` e o G-SLF foi rodado
contra o próprio diff deste fechamento (verde). NENHUM guard ativado no
runner (ADR-020 Decisão 2). Incidente confessado: a janela rodou `git add`
no sandbox contra a doutrina do knowledge 0003 e deixou index.lock órfão —
antídoto e instruções de commit no handoff 20260610-04. O commit do
checkpoint é do humano no Terminal; depois, re-auditoria cruzada + hearback
do lote EF1-EF4.
