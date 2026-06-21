---
titulo: "Despacho — W-ORQ-4b: endurecer G-ORQ-REF (gatear despachos em .hbn/messages)"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md
readback_alvo: 0076-w-orq-4b-orqref
created_at: "2026-06-21T02:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - guards/assert-orq-entrada-ref.sh
  - guards/hbn-guards-runner.sh
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-ORQ-4b / endurecer G-ORQ-REF

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T02:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T02:00:00-03:00 readback_ativo=.hbn/readbacks/0076-w-orq-4b-orqref.json; W-ORQ-4b PROPOSTO; main intocada 4db6928; HEAD ed29627.
PRÓXIMA AÇÃO: cross-audit do W-ORQ-4b (readback 0076)
SITUACAO: faceta 2/4 do W-ORQ-4. G-ORQ-REF so gateia despacho em .hbn/dispatch/*.md (assert-orq-entrada-ref.sh:220), mas TODOS os nossos despachos vivem em .hbn/messages/*.md — um despacho-ato-de-autoridade ali pode omitir orq_entrada_ref sem ser pego. 4b fecha esse buraco.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- 4b ENDURECE um guard existente (assert-orq-entrada-ref.sh), nao cria novo: estende o gatilho de despacho para .hbn/messages/*.md com tipo: despacho, preservando todo o comportamento atual (.hbn/dispatch, freeze, readbacks vigentes).
- Implementacao (NAO selagem): regenerar atestacao same-fp; parar para cross-audit != OpenAI. O proprio commit dogfooda: este despacho (.hbn/messages, tipo despacho) ja carrega orq_entrada_ref e deve passar sob o guard endurecido.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: ed29627. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt nem guards/data/**.

READBACK A CRIAR: .hbn/readbacks/0076-w-orq-4b-orqref.json (0076 = proximo monotonico apos 0075).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Intencao
Endurecer G-ORQ-REF (guards/assert-orq-entrada-ref.sh): hoje so trata como despacho os .hbn/dispatch/*.md (linha ~220, regex ^\.hbn/dispatch/.*\.md$). Como TODOS os despachos do projeto vivem em .hbn/messages/*.md, um despacho-ato-de-autoridade ali NAO e gateado por orq_entrada_ref (so e pego se houver readback vigente no mesmo commit). Fechar: gatear tambem .hbn/messages/*.md cujo front-matter declare tipo: despacho.

## Comportamento exigido (voce escreve o bash — §2.10)
1. Em guards/assert-orq-entrada-ref.sh, ESTENDA o gatilho de despacho: alem de ^\.hbn/dispatch/.*\.md$, trate como despacho tambem ^\.hbn/messages/.*\.md$ QUANDO o front-matter YAML do blob staged declarar `tipo: despacho`. Demais .hbn/messages/*.md (tipo: handoff, prompt, entrada, etc.) NAO sao gateados (preserva o fluxo atual de handoffs/prompts/entrada). Para esses despachos de .hbn/messages, aplique a MESMA exigencia ja vigente: dispatch_readback_path (readback_id/readback_alvo presente) e orq_entrada_ref apontando para a atestacao vigente (mesma logica do ramo .hbn/dispatch).
2. PRESERVE todo o comportamento existente: .hbn/dispatch/*.md, .hbn/freeze/*.json, readbacks vigentes/selagem continuam exatamente como hoje. Nao reavalie commits passados (forward-only via guard_diff_files). fail-closed.
3. Atualize o cabecalho-comentario do escopo do guard para refletir .hbn/messages/*.md (tipo: despacho).

## Ativacao
G-ORQ-REF ja esta no runner (nada a adicionar). O proprio commit 0076 stage este despacho (.hbn/messages, tipo: despacho, COM orq_entrada_ref) — deve PASSAR sob o guard endurecido (dogfood). Bootstrap do proximo_ponto em STATE.md:
  proximo_ponto:
    passo: "cross-audit do W-ORQ-4b (readback 0076)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md
    status: pendente

## STATE (alem do proximo_ponto)
- onda_atual: "W-ORQ-4b PROPOSTO — readback 0076; G-ORQ-REF endurecido para gatear despachos em .hbn/messages (tipo: despacho), aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; W-ORQ-4b 0076 entregue/proposto"
- proxima_acao: "cross-audit do W-ORQ-4b (readback 0076)"
- ultima_atualizacao: "2026-06-21T02:00:00-03:00"
- readback_ativo: ".hbn/readbacks/0076-w-orq-4b-orqref.json"
- handoff_mais_recente: ".hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md"

## Testes exigidos (voce escreve fixtures/casos seguindo os padroes existentes)
- run-guard-tests.sh: caso BOM (despacho em .hbn/messages com tipo: despacho + orq_entrada_ref valido + readback_alvo => passa) + RUINS BLOQUEADOS: (i) despacho em .hbn/messages tipo: despacho SEM orq_entrada_ref; (ii) tipo: despacho com orq_entrada_ref divergente do esperado. NEUTRO: .hbn/messages com tipo: handoff/prompt/entrada SEM orq_entrada_ref => passa (nao gateado). Regressao: os casos existentes de .hbn/dispatch e readbacks vigentes continuam passando/bloqueando como antes.
- adversarial-battery.sh: B79+ para as burlas (i)-(ii) acima.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/assert-orq-entrada-ref.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md
- .hbn/readbacks/0076-w-orq-4b-orqref.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh (G-ORQ-REF ja esta no runner; nao precisa mexer).

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (assert-orq-entrada-ref.sh e MODIFICADO, nao novo => NAO precisa de linha): o despacho 20260621-020000 e o readback 0076.

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

## scaffold — .hbn/readbacks/0076-w-orq-4b-orqref.json
{
  "readback_id": "0076-w-orq-4b-orqref",
  "execution_id": "w-orq-4b-orqref-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0076-w-orq-4b-orqref.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md",
  "understanding": "Endurecer G-ORQ-REF (assert-orq-entrada-ref.sh) para gatear tambem despachos em .hbn/messages/*.md com tipo: despacho (exigindo orq_entrada_ref + readback_alvo), fechando o buraco do gatilho restrito a .hbn/dispatch. Preservar todo o comportamento existente (.hbn/dispatch, freeze, readbacks vigentes), forward-only, fail-closed. Adicionar testes (run-guard-tests + adversarial B79+). Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho W-ORQ-4b de 2026-06-21T02:00:00-03:00 sob token_fp 34a7f2f9; endurecer guard+testes+STATE+REGISTRY+atestacao dentro do files_allowed; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/assert-orq-entrada-ref.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-020000-opus-4-8-despacho-w-orq-4b-orqref.md",
      ".hbn/readbacks/0076-w-orq-4b-orqref.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh"]
  },
  "stop_condition": "Entrega 0076 (W-ORQ-4b) em commit unico; parar para cross-audit != OpenAI. NAO selar. NAO iniciar 4c/4d nem W-FREEZE.",
  "HBN-Readback": "0076",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T02:00:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0076
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0076 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. NAO iniciar 4c/4d/W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
