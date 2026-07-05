---
titulo: "Despacho — fix-gexc-sigpipe: G-EXC falso-negativo sob pipefail (SIGPIPE do grep -q)"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md
readback_alvo: 0083-fix-gexc-sigpipe
created_at: "2026-06-21T07:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - guards/assert-exception-traceable.sh
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho fix-gexc-sigpipe

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T07:30:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T07:30:00-03:00 readback_ativo=.hbn/readbacks/0083-fix-gexc-sigpipe.json; FIX-GEXC PROPOSTO; main intocada 4db6928; HEAD 7932f55.
PRÓXIMA AÇÃO: cross-audit do fix-gexc-sigpipe (readback 0083)
SITUACAO: o runner ficou vermelho por bug latente do G-EXC: `state_content | ... | grep -q 'exce'` sob set -o pipefail — grep -q fecha o pipe, git show leva SIGPIPE(141), pipefail reporta falha = falso 'Sinal (d) AUSENTE'. Determinístico agora que o STATE tem ~85KB. Bug do guard, NAO do STATE (o 🔴 de excecao existe).
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- Provado: sem pipefail rc=0; com pipefail rc=141 (5/5). O sinal (d) esta presente (3 linhas 🔴 com 'exce'); o guard e que da falso-negativo. Corrigir SO o guard (e teste de regressao). Desvio necessario antes de retomar o cross-audit do 0082.
- Implementacao (NAO selagem): regenerar atestacao same-fp; parar para cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: 7932f55. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md, guards/hbn-guards-runner.sh.

READBACK A CRIAR: .hbn/readbacks/0083-fix-gexc-sigpipe.json (0083 = proximo monotonico apos 0082). [Havera duas propostas abertas em paralelo: 0082 (W-ORQ-4d-fix-2, aguardando cross-audit) e 0083 (este fix). OK.]
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Bug (reproduza primeiro)
bash guards/hbn-guards-runner.sh -> FALHA em assert-exception-traceable: "Sinal (d) AUSENTE", apesar de existirem linhas `  - "🔴 ... excecao ..."` no STATE. Causa: em guards/assert-exception-traceable.sh, as checagens do sinal (d) usam pipelines terminadas em `grep -q` (e `grep -q 'PROPOSED_UNTIL_CROSS_AUDIT'`) cuja cabeca e `state_content` (git show). Sob `set -euo pipefail`, o `grep -q` sai cedo, o git show leva SIGPIPE (141) e o pipefail reporta a pipeline como falha mesmo havendo match. Repro: `set -o pipefail; state_content | grep ... | grep -qiE 'exce'; echo $?` => 141; `set +o pipefail` => 0.

## Comportamento exigido (voce escreve o bash — §2.10)
1. Em guards/assert-exception-traceable.sh, CORRIJA as checagens do sinal (d) (e quaisquer outras checagens que terminem um pipe iniciado por state_content/rb_content/git show com `grep -q`) para NAO sofrer SIGPIPE sob pipefail.
   ATENCAO: `grep -q` SAI no primeiro match e fecha o pipe -> a cabeca do pipe (git show, ou ate printf de variavel) leva SIGPIPE(141) -> pipefail reporta falha. NAO basta capturar em variavel se ainda houver um pipe terminado em `grep -q` (PROVADO: `printf '%s\n' "$var" | grep ... | grep -qiE exce` AINDA da rc=141).
   USE UMA DESTAS DUAS FORMAS PROVADAS (rc correto sob pipefail):
   (FORMA A — contagem, le toda a entrada, sem -q):
     d_cnt="$(state_content | grep -E '^[[:space:]]*-' | grep '🔴' | grep -ciE 'exce' || true)"
     if [[ "${d_cnt:-0}" -eq 0 ]]; then ...   # rc=0, d_cnt=3 no STATE atual
   (FORMA B — here-string: a substituicao completa ANTES do grep -q ler; o here-string nao e um pipe vivo):
     if ! grep -qiE 'exce' <<< "$(state_content | grep -E '^[[:space:]]*-' | grep '🔴')"; then ...
   Aplique o MESMO conserto (FORMA A ou B) a checagem de `PROPOSED_UNTIL_CROSS_AUDIT` (ex.: `p_cnt="$(state_content | grep -c 'PROPOSED_UNTIL_CROSS_AUDIT' || true)"; if [[ "${p_cnt:-0}" -eq 0 ]]`). NAO mude a SEMANTICA (mesmos criterios; so elimine o falso-negativo por SIGPIPE).
2. PRESERVE todo o resto do guard (sinais a/b/c, divisao pre-commit/commit-msg/CI, etc.).
3. Confirme: bash guards/hbn-guards-runner.sh -> "Todos os guards passaram" (G-EXC agora verde com o sinal (d) presente).

## STATE
- onda_atual: "FIX-GEXC PROPOSTO — readback 0083; corrige falso-negativo do G-EXC (SIGPIPE do grep -q sob pipefail), aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; fix-gexc-sigpipe 0083 entregue/proposto"
- proxima_acao: "cross-audit do fix-gexc-sigpipe (readback 0083)"
- ultima_atualizacao: "2026-06-21T07:30:00-03:00"
- readback_ativo: ".hbn/readbacks/0083-fix-gexc-sigpipe.json"
- handoff_mais_recente: ".hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md"
- ACRESCENTE em sinais_abertos (no topo) este 🔴 (contem 'EXCEÇÃO' para o sinal (d)):
  - "🔴 EXCEÇÃO F-01 / fix-gexc-sigpipe PROPOSED_UNTIL_CROSS_AUDIT — readback 0083 safe_track, implementador=codex, autorizacao humana Mauricio, orq_entrada_ref presente; corrige falso-negativo do G-EXC; aguarda cross-audit != OpenAI + hearback antes de selagem."
- proximo_ponto (G-NEXT):
  proximo_ponto:
    passo: "cross-audit do fix-gexc-sigpipe (readback 0083)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md
    status: pendente

## Testes exigidos
- run-guard-tests.sh (secao G-EXC): caso de REGRESSAO — um STATE de fixture GRANDE (>= ~80KB, com muitos itens) que CONTENHA a linha 🔴 de excecao + PROPOSED_UNTIL_CROSS_AUDIT e readback com agent_id==implementador => G-EXC deve PASSAR (antes do fix, falharia por SIGPIPE). Mantenha os casos negativos existentes (sem 🔴 de excecao => bloqueia; sem PROPOSED_UNTIL_CROSS_AUDIT => bloqueia).
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/assert-exception-traceable.sh
- guards/tests/run-guard-tests.sh
- .hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md
- .hbn/readbacks/0083-fix-gexc-sigpipe.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh, .github/workflows/**, guards/assert-ci-battery.sh, guards/tests/adversarial-battery.sh.

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (assert-exception-traceable.sh MODIFICADO => sem linha): o despacho 20260621-073000 e o readback 0083.

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

## scaffold — .hbn/readbacks/0083-fix-gexc-sigpipe.json
{
  "readback_id": "0083-fix-gexc-sigpipe",
  "execution_id": "fix-gexc-sigpipe-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0083-fix-gexc-sigpipe.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md",
  "understanding": "Corrigir falso-negativo do G-EXC (assert-exception-traceable.sh): sob set -o pipefail, as checagens do sinal (d) terminadas em grep -q causam SIGPIPE no git show a montante (rc 141) e o pipefail reporta falha apesar do match. Capturar o conteudo em variavel / usar contagem que le toda a entrada, sem mudar a semantica. Teste de regressao com STATE grande. Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Bug detectado pelo orquestrador no disco (runner vermelho apesar de RETURN verde); set +o pipefail rc=0 vs set -o pipefail rc=141. Despacho de 2026-06-21T07:30:00-03:00 sob token_fp 34a7f2f9; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/assert-exception-traceable.sh",
      "guards/tests/run-guard-tests.sh",
      ".hbn/messages/20260621-073000-opus-4-8-despacho-fix-gexc-sigpipe.md",
      ".hbn/readbacks/0083-fix-gexc-sigpipe.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh",".github/workflows/**","guards/assert-ci-battery.sh","guards/tests/adversarial-battery.sh"]
  },
  "stop_condition": "Entrega 0083 (fix-gexc-sigpipe) em commit unico; parar para cross-audit != OpenAI. NAO selar. Apos selagem do 0083, retomar o cross-audit do W-ORQ-4d-fix-2 (0082).",
  "HBN-Readback": "0083",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T07:30:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0083
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0083 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
