---
titulo: "Despacho — W-ORQ-4d-fix-2: redesenho CI entrypoint igualdade-exata + G-CI-BATTERY"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260621-070000-opus-4-8-despacho-w-orq-4d-fix2-ci-entry.md
readback_alvo: 0082-w-orq-4d-fix2-ci-entry
created_at: "2026-06-21T07:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .github/workflows/hbn-shield.yml
  - guards/assert-ci-battery.sh
  - .hbn/results/20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081.md
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-ORQ-4d-fix-2 / CI entrypoint igualdade-exata

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T07:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T07:00:00-03:00 readback_ativo=.hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json; W-ORQ-4d-FIX2 PROPOSTO; main intocada 4db6928; HEAD be18335.
PRÓXIMA AÇÃO: cross-audit do W-ORQ-4d-fix-2 (readback 0082)
SITUACAO: o 0081 foi reprovado por antigravity E grok — burla heredoc-data (parser estatico nao distingue invocacao de string literal). Gate Mauricio escolheu redesenho por IGUALDADE EXATA: workflow chama um unico entrypoint guards/ci-entry.sh; qualquer embedding (heredoc/echo/comentario) deixa o scalar != exato e nao cola.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- Redesenho (gate Mauricio): o workflow tem UM step `run: bash guards/ci-entry.sh` (igualdade exata do scalar, NAO substring); ci-entry.sh (guardado) roda runner+suite+bateria. G-CI-BATTERY verifica igualdade exata + invocacoes reais (heredoc-aware) no ci-entry.sh.
- Implementacao (NAO selagem): regenerar atestacao same-fp; parar para re-cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: be18335. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve bash/yaml (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md, guards/hbn-guards-runner.sh (G-CI-BATTERY ja esta no runner).

READBACK A CRIAR: .hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json (0082 = proximo monotonico apos 0081).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para re-cross-audit != OpenAI. NAO selar.

## Intencao
Os auditores (antigravity+grok) provaram que um parser estatico de texto nao distingue invocacao de string literal (burla heredoc). Redesenhar por IGUALDADE EXATA: reduzir o que o guard precisa reconhecer a um unico comando canonico, cuja presenca exata nao pode ser forjada por embedding.

## Comportamento exigido (voce escreve bash + yaml — §2.10)
1. CRIAR guards/ci-entry.sh (entrypoint de CI, guardado) com EXATAMENTE:
#!/usr/bin/env bash
set -euo pipefail
bash guards/hbn-guards-runner.sh
bash guards/tests/run-guard-tests.sh
bash guards/tests/adversarial-battery.sh
   (chmod +x se o repo versiona modo executavel; mantenha simples — so estes comandos.)
2. EDITAR .github/workflows/hbn-shield.yml: substitua os passos que rodam runner/suite/bateria por UM unico passo cujo `run:` seja EXATAMENTE `bash guards/ci-entry.sh` (mantendo o env HBN_DIFF_BASE existente nesse passo). Nao deixe outros passos rodando os scripts diretamente.
3. REDESENHAR guards/assert-ci-battery.sh (G-CI-BATTERY), invariante (le indice/HEAD), com DUAS checagens fail-closed (use python3):
   (A) IGUALDADE EXATA NO WORKFLOW: parseie .github/workflows/hbn-shield.yml; colete os comandos dos passos `run:` (inline `run: <cmd>` e bloco `run: |` — o corpo do bloco). Exija que EXISTA um passo cujo comando, normalizado (trim de espacos), seja EXATAMENTE a string `bash guards/ci-entry.sh` (e SO isso; um bloco run: | so conta se o corpo for exatamente essa unica linha). Substring/embedding/heredoc/echo NAO satisfazem. Se nenhum => guard_fail.
   (B) ENTRYPOINT REAL: guards/ci-entry.sh deve existir no indice/HEAD e invocar de verdade os tres: hbn-guards-runner.sh, tests/run-guard-tests.sh, tests/adversarial-battery.sh. Parse HEREDOC-AWARE: ignore corpos de heredoc (regioes entre `<<MARKER`/`<<'MARKER'`/`<<-MARKER` e a linha `MARKER`) e comentarios; exija linhas que, fora de heredoc e apos trim, COMECEM com `bash guards/hbn-guards-runner.sh`, `bash guards/tests/run-guard-tests.sh`, `bash guards/tests/adversarial-battery.sh`. Exija tambem `set -e` (ou `set -euo pipefail`). Se faltar qualquer um => guard_fail.
   Preserve guard_check_bypass.

## STATE
- onda_atual: "W-ORQ-4d-FIX2 PROPOSTO — readback 0082; CI por entrypoint de igualdade exata (guards/ci-entry.sh) + G-CI-BATTERY redesenhado, aguardando re-cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; W-ORQ-4d-fix-2 0082 entregue/proposto"
- proxima_acao: "cross-audit do W-ORQ-4d-fix-2 (readback 0082)"
- ultima_atualizacao: "2026-06-21T07:00:00-03:00"
- readback_ativo: ".hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json"
- handoff_mais_recente: ".hbn/messages/20260621-070000-opus-4-8-despacho-w-orq-4d-fix2-ci-entry.md"
- proximo_ponto (G-NEXT):
  proximo_ponto:
    passo: "cross-audit do W-ORQ-4d-fix-2 (readback 0082)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-070000-opus-4-8-despacho-w-orq-4d-fix2-ci-entry.md
    status: pendente

## Testes exigidos (voce escreve fixtures/casos — secao G-CI-BATTERY)
- run-guard-tests.sh: caso BOM (workflow com `run: bash guards/ci-entry.sh` exato + ci-entry.sh com os 3 comandos reais + set -e => passa). RUINS BLOQUEADOS:
   (i) workflow SEM o step exato (ex.: rodando os 3 scripts em steps separados, sem entrypoint) => bloqueia.
   (ii) workflow com `run: echo "bash guards/ci-entry.sh"` (echo) => bloqueia (nao e igualdade exata).
   (iii) workflow com heredoc/`cat <<EOF` contendo `bash guards/ci-entry.sh` como dado => bloqueia.
   (iv) ci-entry.sh faltando uma das 3 invocacoes => bloqueia.
   (v) ci-entry.sh com a invocacao DENTRO de heredoc/echo (nao executada) => bloqueia.
- adversarial-battery.sh: mantenha/atualize B85 (comentario), B86 (echo) e ADICIONE B87 (heredoc-data) — todos BLOQUEIAM.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- bash guards/ci-entry.sh -> roda os 3 e termina verde (sanity).
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- .github/workflows/hbn-shield.yml
- guards/ci-entry.sh
- guards/assert-ci-battery.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-070000-opus-4-8-despacho-w-orq-4d-fix2-ci-entry.md
- .hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh.

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (assert-ci-battery.sh e hbn-shield.yml MODIFICADOS => sem linha): guards/ci-entry.sh, o despacho 20260621-070000 e o readback 0082.

## C6 — GERAR a atestacao (NAO a mao). Salve /tmp/gen_orq.py e rode `python3 /tmp/gen_orq.py` APOS stage de STATE+despacho+readback:
import hashlib, json, subprocess, re, pathlib
TOKEN_FP="34a7f2f9"; STATE_PATH=".hbn/relay/STATE.md"; READLIST="core/read-list-canonica.txt"
ALGORITHM="orq-entrada.v2/extractive-lines"; ATT=f".hbn/attestations/{TOKEN_FP}-orq-entrada.json"
def gb(*a): return subprocess.check_output(["git",*a])
def oid(p): return gb("rev-parse",f":{p}").decode().strip()
def content(p): return gb("cat-file","-p",f":{p}")
def s256t(s): return hashlib.sha256(s.encode("utf-8")).hexdigest()
def s256b(b): return hashlib.sha256(b).hexdigest()
def cjson(v): return json.dumps(v,ensure_ascii=False,sort_keys=True,separators=(",",":"))
def sv(text,key):
    pat=re.compile(rf"^\s*{re.escape(key)}:")
    for line in text.splitlines():
        if not pat.search(line): continue
        v=line.split(":",1)[1]; v=re.sub(r"\s+#.*$","",v).strip()
        if len(v)>=2 and v[0]==v[-1] and v[0] in ("'",'"'): v=v[1:-1]
        return v
    return ""
state_text=content(STATE_PATH).decode("utf-8")
HANDOFF=sv(state_text,"handoff_mais_recente"); READBACK=sv(state_text,"readback_ativo")
items=[]
for raw in pathlib.Path(READLIST).read_text(encoding="utf-8").splitlines():
    if not raw.strip() or raw.lstrip().startswith("#"): continue
    m=re.match(r"^DYNAMIC\s+(\S+)$",raw.strip())
    if m:
        f=m.group(1); items.append(HANDOFF if f=="handoff_mais_recente" else READBACK if f=="readback_ativo" else None)
    else:
        parts=raw.split(None,1); items.append(parts[1].strip() if len(parts)>1 else raw.strip())
manifest=[]; cbp={}
for p in items:
    o=oid(p); c=content(p); t=c.decode("utf-8")
    ne=[(i,l) for i,l in enumerate(t.splitlines(),1) if l.strip()]
    cbp[p]=(c,t,ne); manifest.append({"path":p,"blob_oid":o,"sha256":s256b(c),"bytes":len(c),"nonempty_lines":len(ne)})
manifest_sha=s256t(cjson(manifest))
exec_id=json.loads(content(READBACK).decode("utf-8")).get("execution_id","")
seed=s256t(f"orq-entrada.v2\n{exec_id}\n{TOKEN_FP}\n{manifest_sha}")
lr=[]
for p in [STATE_PATH,READBACK,"core/orchestrator-profile-spec.md"]:
    rec=next(r for r in manifest if r["path"]==p)
    ch=s256t(f"{seed}\n{p}\n{rec['blob_oid']}"); idx=int(ch[:8],16)%rec["nonempty_lines"]
    ln,lt=cbp[p][2][idx]; lr.append({"path":p,"line_no":ln,"line_text":lt,"line_sha256":s256t(lt)})
fr=[{"path":STATE_PATH,"field":"readback_ativo","value":READBACK},
    {"path":STATE_PATH,"field":"proxima_acao","value":sv(state_text,"proxima_acao")}]
att={"papel":"orquestrador","identidade":"opus-4-8","proprietario_bastao":sv(state_text,"proprietario_bastao"),
     "bastao_token_fp":TOKEN_FP,"algorithm":ALGORITHM,"execution_id":exec_id,
     "read_list_ref":"core/read-list-canonica.txt","atestado_por":"opus-4-8",
     "atestado_em":sv(state_text,"ultima_atualizacao"),"manifest_sha256":manifest_sha,
     "challenge":{"seed_sha256":seed,"line_responses":lr,"field_responses":fr}}
pathlib.Path(ATT).write_text(json.dumps(att,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
print("WROTE",ATT,"seed",seed[:12])
# depois: git add .hbn/attestations/34a7f2f9-orq-entrada.json ; bash guards/assert-orq-entrada.sh (verde)

## scaffold — .hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json
{
  "readback_id": "0082-w-orq-4d-fix2-ci-entry",
  "execution_id": "w-orq-4d-fix2-ci-entry-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-070000-opus-4-8-despacho-w-orq-4d-fix2-ci-entry.md",
  "understanding": "Redesenhar a integracao CI por IGUALDADE EXATA apos duas reprovacoes (heredoc-data). Criar guards/ci-entry.sh (runner+suite+bateria); workflow tem UM step run == exatamente 'bash guards/ci-entry.sh'; G-CI-BATTERY verifica igualdade exata no workflow + invocacoes reais heredoc-aware no ci-entry.sh. Testes B85/B86/B87 bloqueiam. Implementacao: regenerar atestacao same-fp, parar para re-cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Gate Mauricio escolheu redesenho entrypoint igualdade-exata apos reprovacoes em .hbn/results/20260621-063000-antigravity-cross-ia-w-orq-4d-fix-0081.md e .hbn/results/20260621-064000-grok-cross-ia-w-orq-4d-fix-0081.md. Despacho de 2026-06-21T07:00:00-03:00 sob token_fp 34a7f2f9; parar para re-cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      ".github/workflows/hbn-shield.yml",
      "guards/ci-entry.sh",
      "guards/assert-ci-battery.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-070000-opus-4-8-despacho-w-orq-4d-fix2-ci-entry.md",
      ".hbn/readbacks/0082-w-orq-4d-fix2-ci-entry.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh"]
  },
  "stop_condition": "Entrega 0082 (W-ORQ-4d-fix-2) em commit unico; parar para re-cross-audit != OpenAI. NAO selar. NAO iniciar Despromocao-P6/W-FREEZE.",
  "HBN-Readback": "0082",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T07:00:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0082
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0082 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para re-cross-audit != OpenAI. NAO selar. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
