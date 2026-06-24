---
titulo: "Despacho — fix-freeze-meta-deref: freeze-gate trata proposta SELADA como resolvida"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md
readback_alvo: 0088-fix-freeze-meta-deref
created_at: "2026-06-21T11:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - guards/freeze-gate.sh
  - core/freeze-gate-spec.md
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho fix-freeze-meta-deref

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T11:30:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T11:30:00-03:00 readback_ativo=.hbn/readbacks/0088-fix-freeze-meta-deref.json; FIX-FREEZE-METADEREF PROPOSTO; main intocada 4db6928; HEAD 9bb01f1.
PRÓXIMA AÇÃO: cross-audit do fix-freeze-meta-deref (readback 0088)
SITUACAO: o meta-deref-propostas do freeze-gate (4c) veta qualquer readback PROPOSED, mas a selagem cria um readback NOVO vigente e nunca rebaixa o status do original — 13 propostas ja seladas/superadas ficam PROPOSED e vetariam o W-FREEZE indevidamente. Fix: so vetar proposta NAO resolvida.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- Gate Mauricio: resolver pelo ledger. Uma proposta PROPOSED NNNN e RESOLVIDA se (a) existe readback vigente com seals_proposal==NNNN, OU (b) o `protocolo` do STATE marca "NNNN selado e vigente" ou "NNNN ... SUPERAD". So veta as NAO resolvidas. Cobre novos (seals_proposal), legados 0064/0066/0067 (protocolo) e superados 0080/0081 (protocolo).
- Implementacao (NAO selagem): regenerar atestacao same-fp; parar para cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: 9bb01f1. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md, guards/hbn-guards-runner.sh.

READBACK A CRIAR: .hbn/readbacks/0088-fix-freeze-meta-deref.json (0088 = proximo monotonico apos 0087).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Bug (reproduza)
O freeze-gate (guards/freeze-gate.sh, meta-deref-propostas ~linha 69) veta se QUALQUER readback tem activation_status==PROPOSED_UNTIL_CROSS_AUDIT (ou status==implemented_pending_cross_audit). Mas a selagem cria readback novo vigente e NAO rebaixa o status do original. Logo 13 propostas ja seladas/superadas (0064,0066,0067,0070,0072,0074,0076,0078,0080,0081,0082,0083,0086) ainda sao PROPOSED e o freeze-gate as trata como pendentes -> vetaria o W-FREEZE indevidamente.

## Comportamento exigido (voce escreve o bash — §2.10)
Em guards/freeze-gate.sh, AJUSTE o meta-deref-propostas: uma proposta com NNNN (os 4 digitos iniciais do readback_id) so e PENDENTE/DANGLING se NAO estiver RESOLVIDA. RESOLVIDA = (a) OU (b):
   (a) existe ALGUM readback .hbn/readbacks/*.json (tracked) com status "vigente" e campo "seals_proposal" == NNNN;
   (b) OU alguma LINHA do STATE (.hbn/relay/STATE.md, blob staged/HEAD) — seja uma clausula do campo `protocolo` (separe por "; ") OU um item de `sinais_abertos` — contem o numero NNNN E uma marca de resolucao: "selado e vigente"|"selada e vigente"|"SUPERAD" (case-insensitive). [Nota: o marcador de selagem dos legados (0064/0066/0067) esta no protocolo; o de SUPERADOS (0080/0081) esta em sinais_abertos; 0072 resolve por (a) seals_proposal. NAO conte como resolucao a propria linha 🔴 PROPOSED_UNTIL_CROSS_AUDIT.]
So mantenha o VETO para readbacks PROPOSED que NAO sejam resolvidos por (a) nem (b). PRESERVE meta-deref-atestacao e todo o resto (criterios, bloqueadores, na+hearback). fail-closed (se nao conseguir ler STATE/readbacks, veta). Use python3.

## STATE + spec
- Atualize core/freeze-gate-spec.md: documente que o criterio meta-deref-propostas considera RESOLVIDA a proposta selada (seals_proposal) ou marcada no protocolo (selado e vigente / SUPERAD), vetando so as efetivamente pendentes.
- onda_atual: "FIX-FREEZE-METADEREF PROPOSTO — readback 0088; freeze-gate trata proposta selada/superada como resolvida (ledger), vetando so as pendentes; aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; fix-freeze-meta-deref 0088 entregue/proposto"
- proxima_acao: "cross-audit do fix-freeze-meta-deref (readback 0088)"
- ultima_atualizacao: "2026-06-21T11:30:00-03:00"
- readback_ativo: ".hbn/readbacks/0088-fix-freeze-meta-deref.json"
- handoff_mais_recente: ".hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md"
- ACRESCENTE em sinais_abertos (no topo): "🔴 EXCEÇÃO F-01 / fix-freeze-meta-deref PROPOSED_UNTIL_CROSS_AUDIT — readback 0088 safe_track, implementador=codex, autorizacao humana Mauricio, orq_entrada_ref presente; aguarda cross-audit != OpenAI + hearback antes de selagem."
- proximo_ponto (G-NEXT):
  proximo_ponto:
    passo: "cross-audit do fix-freeze-meta-deref (readback 0088)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md
    status: pendente

## Testes exigidos (secao G-FRZ)
- run-guard-tests.sh: caso BOM (fixture com readback PROPOSED NNNN + readback vigente com seals_proposal==NNNN => meta-deref-propostas NAO veta) + (fixture com PROPOSED NNNN + protocolo do STATE marcando 'NNNN selado e vigente' => NAO veta) + RUIM (fixture com PROPOSED NNNN sem seal nem marca no protocolo => VETA). Use fixtures descartaveis com checklist valido.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- SANITY (cite a saida): construa um checklist minimo valido para esta versao e rode `bash guards/freeze-gate.sh <checklist>` contra o REPO REAL; o criterio meta-deref-propostas deve PASSAR agora (as 13 propostas estao resolvidas por seals_proposal/protocolo). Se o gate ainda vetar por propostas, PARE e relate qual NNNN.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/freeze-gate.sh
- core/freeze-gate-spec.md
- guards/tests/run-guard-tests.sh
- .hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md
- .hbn/readbacks/0088-fix-freeze-meta-deref.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/read-list-canonica.txt, core/orchestrator-profile-spec.md, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh.

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (freeze-gate.sh e freeze-gate-spec.md MODIFICADOS => sem linha): o despacho 20260621-113000 e o readback 0088.

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

## scaffold — .hbn/readbacks/0088-fix-freeze-meta-deref.json
{
  "readback_id": "0088-fix-freeze-meta-deref",
  "execution_id": "fix-freeze-meta-deref-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0088-fix-freeze-meta-deref.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md",
  "understanding": "Corrigir o meta-deref-propostas do freeze-gate (4c): so vetar proposta PROPOSED se NAO resolvida. RESOLVIDA = readback vigente com seals_proposal==NNNN OU protocolo do STATE marcando 'NNNN selado e vigente' / 'NNNN ... SUPERAD'. Preserva meta-deref-atestacao e criterios. Atualizar spec. Sanity contra o repo real (as 13 propostas resolvidas). Testes G-FRZ. Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Bug detectado pelo orquestrador no disco (freeze-gate vetaria W-FREEZE por 13 propostas ja seladas mas com status PROPOSED). Gate Mauricio escolheu resolver pelo ledger (protocolo + seals_proposal). Despacho de 2026-06-21T11:30:00-03:00 sob token_fp 34a7f2f9; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/freeze-gate.sh",
      "core/freeze-gate-spec.md",
      "guards/tests/run-guard-tests.sh",
      ".hbn/messages/20260621-113000-opus-4-8-despacho-fix-freeze-meta-deref.md",
      ".hbn/readbacks/0088-fix-freeze-meta-deref.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/read-list-canonica.txt","core/orchestrator-profile-spec.md","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh"]
  },
  "stop_condition": "Entrega 0088 (fix-freeze-meta-deref) em commit unico; parar para cross-audit != OpenAI. NAO selar. Apos selagem do 0088, retomar o W-FREEZE.",
  "HBN-Readback": "0088",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T11:30:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0088
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0088 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
