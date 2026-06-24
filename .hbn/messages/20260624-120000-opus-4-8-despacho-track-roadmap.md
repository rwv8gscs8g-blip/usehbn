---
titulo: "Despacho — Track ROADMAP-macro-pos-blindagem-5-passos"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md
readback_alvo: 0090-track-roadmap-5-passos
created_at: "2026-06-24T12:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho Track Roadmap 5 Passos

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-24T12:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador (zelador das regras pelo exemplo — k-0029).
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-24T12:00:00-03:00 readback_ativo=.hbn/readbacks/0090-track-roadmap-5-passos.json; main intocada 4db6928; HEAD 11fa9d0.
PRÓXIMA AÇÃO: W-FREEZE (freeze-gate.sh exit 0 pelo humano; tag v1-estavel)
BASTÃO: opus-4-8 (Anthropic), atestacao v2 valida (34a7f2f9). Ato de autoridade sob G-ORQ-REF (Exit A').

## Decisões informais (cápsula)
- Track 0090 rastreia SO o ROADMAP-macro-pos-blindagem-5-passos (zona-livre curada por Mauricio); handoff pos-roadmap fica como contexto de entrada, nao rastreado. NAO e selagem (status entregue, sem seals_proposal). Atestacao 34a7f2f9 regenerada same-fp, readback_ativo->0090; proxima_acao permanece W-FREEZE.

⟦HBN-COPY dest=codex⟧ BEGIN
PARA: codex (implementador · OpenAI). SOB: bastao token_fp 34a7f2f9. ORQUESTRADOR: opus-4-8 · Anthropic. TRACK: safe_track.
CONTEXTO: a 1a tentativa do track 0090 foi STAGED mas NAO commitada (HEAD segue 11fa9d0; bem feito ter parado no bloqueio do G-RLT, sem burlar). Esta versao CORRIGE e rastreia SO o roadmap (decisao de Mauricio). HEAD esperado: 11fa9d0. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
OBJETIVO: rastrear sob rito somente o ROADMAP-macro-pos-blindagem-5-passos ja curado por Mauricio e ancorar o STATE no roadmap. O handoff 20260621-140000 fica como contexto de entrada e NAO sera rastreado nesta janela. NAO e selagem (sem seals_proposal, sem quorum). NAO iniciar W-FREEZE (gate humano).
LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne.

C1. NAO criar conteudo novo do roadmap — ele ja existe na working tree, apenas untracked. O handoff 20260621-140000 NAO sera rastreado nesta janela: deixe-o untracked (nao stage).

C2. SALVAR ESTE DESPACHO como arquivo (conteudo = a mensagem inteira do despacho, do front-matter ao FIM DO DESPACHO) em:
   .hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md

C3. CRIAR .hbn/readbacks/0090-track-roadmap-5-passos.json com EXATAMENTE o scaffold do fim deste bloco (status "entregue"; SEM seals_proposal; zona_livre_curada true; sem o handoff em files_allowed).

C4. EDITAR .hbn/relay/STATE.md (front-matter), trocando EXATAMENTE (resto intacto):
   - na string `protocolo:`, APENDAR ao final (antes do fecha-aspas): `; ROADMAP-macro-pos-blindagem-5-passos rastreado (handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela) (track 0090); STATE ancorado no ROADMAP-macro-pos-blindagem-5-passos (passo 1 = W-FREEZE)`
   - `onda_atual: "TRACK-ROADMAP-5-PASSOS — readback 0090; ROADMAP-macro-pos-blindagem-5-passos rastreado sob rito e curado por Mauricio; handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela; STATE ancorado no roadmap; W-FREEZE (passo 1) segue como proximo gate humano"`
   - `proxima_acao: "W-FREEZE (freeze-gate.sh exit 0 pelo humano; tag v1-estavel)"`  (INALTERADO)
   - `ultima_atualizacao: "2026-06-24T12:00:00-03:00"`
   - `readback_ativo: ".hbn/readbacks/0090-track-roadmap-5-passos.json"`
   - `handoff_mais_recente: ".hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md"`
   - ADICIONAR/MANTER um campo top-level (logo apos a linha `proxima_acao:`):
     `roadmap_ativo: "docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md"`
   - bloco `proximo_ponto` inteiro vira EXATAMENTE (mesma indentacao, sem campos extras — G-NEXT exige apenas passo/ato/destino/gate/bloco_ref/status):
proximo_ponto:
  passo: "W-FREEZE — passo 1 do ROADMAP-macro-pos-blindagem-5-passos (freeze do PROTOCOLO): freeze-gate.sh exit 0 pelo humano; tag v1-estavel"
  ato: freeze
  destino: human
  gate: hearback_humano
  bloco_ref: .hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md
  status: pendente
   - No topo de `sinais_abertos`, manter este sinal:
     - "🟢 TRACK-ROADMAP-5-PASSOS — readback 0090; ROADMAP-macro-pos-blindagem-5-passos rastreado (handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela) sob rito (zona-livre curada por Mauricio 2026-06-21); STATE ancorado no roadmap via roadmap_ativo + proximo_ponto."
   - Manter tambem o sinal:
     - "🟡 W-FREEZE (PASSO 1) PROXIMO — freeze do PROTOCOLO segue liberado; falta o orquestrador montar o freeze-checklist real e o humano rodar `bash guards/freeze-gate.sh <checklist>` exit 0 + tag v1-estavel."

C5. REGISTRY.md deve manter exatamente estas 3 linhas novas 7-col; nao registrar o handoff nesta janela:
| 20260621-133000-opus-roadmap-macro-5-passos | docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md | roadmap-zona-livre; passo=macro-5-passos | frio | fronteira | — | 2026-06-21T13:30:00-03:00 |
| 20260624-120000-opus-despacho-track-roadmap | .hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md | despacho | frio | fronteira | — | 2026-06-24T12:00:00-03:00 |
| 20260624-120002-codex-readback-track-roadmap | .hbn/readbacks/0090-track-roadmap-5-passos.json | readback | frio | fronteira | — | 2026-06-24T12:00:02-03:00 |

C6. STAGE EXPLICITO (antes da atestacao):
   git add .hbn/relay/STATE.md .hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md .hbn/readbacks/0090-track-roadmap-5-passos.json docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md REGISTRY.md

C7. GERAR a atestacao com ESTE script (NAO a mao; readback_ativo->0090). Salve /tmp/gen_orq.py e rode `python3 /tmp/gen_orq.py`:
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

C8. Runner + suite + bateria; depois commit UNICO:
   bash guards/hbn-guards-runner.sh
   bash guards/tests/run-guard-tests.sh
   bash guards/tests/adversarial-battery.sh
   git rev-parse main   # DEVE == 4db692876381a0d7909985c8500d999f2e677b04
STAGE FINAL e COMMIT (um shot):
   git add .hbn/attestations/34a7f2f9-orq-entrada.json .hbn/relay/STATE.md .hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md .hbn/readbacks/0090-track-roadmap-5-passos.json docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md REGISTRY.md
Mensagem de commit (trailers contiguos no fim, sem linha em branco entre eles):
   chore(track): rastrear ROADMAP-macro-pos-blindagem-5-passos (track 0090) — STATE ancorado no roadmap

   HBN-Readback: 0090
   HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
   HBN-Token-FP: 34a7f2f9
Apos o commit: escreva .hbn/relay/RETURN.json (status ok + sha novo + readback 0090). NAO iniciar o W-FREEZE neste commit. Reporte o SHA e cole a saida de `git rev-parse main`.

## scaffold — .hbn/readbacks/0090-track-roadmap-5-passos.json
{
  "readback_id": "0090-track-roadmap-5-passos",
  "execution_id": "track-roadmap-2026-06-24",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "entregue",
  "zona_livre_curada": true,
  "zona_livre_nota": "Mauricio aprovou em 2026-06-21 o ROADMAP-macro-pos-blindagem-5-passos como documento de fronteira. Rastreamento sob rito para ancorar a janela antes do W-FREEZE (passo 1). O handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela por decisao de Mauricio. Curadoria humana explicita; sem cross-audit/selagem por nao ser mudanca de guard/spec.",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0090-track-roadmap-5-passos.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md",
  "understanding": "Rastrear sob rito somente o ROADMAP-macro-pos-blindagem-5-passos.md ja aprovado por Mauricio e ancorar o STATE no roadmap (campo roadmap_ativo + proximo_ponto citando o passo 1). O handoff orquestrador pos-roadmap permanece como contexto de entrada e nao e rastreado nesta janela. NAO e selagem: sem seals_proposal, status entregue (G-QUORUM nao opina; freeze-gate nao trata como pendente). G-ZONA-LIVRE coberto por zona_livre_curada+zona_livre_nota. REGISTRY 7-col fronteira/frio para os 3 artefatos governados desta janela. Atestacao 34a7f2f9 regenerada same-fp com readback_ativo->0090 e handoff_mais_recente->despacho 20260624-120000. proxima_acao permanece W-FREEZE (gate humano). Ato de autoridade sob G-ORQ-REF (Exit A').",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "ROADMAP-macro-pos-blindagem-5-passos aprovado por Mauricio em 2026-06-21; direcao corrigida de rastrear sob rito so o roadmap e ancorar o STATE no roadmap antes do W-FREEZE, deixando o handoff pos-roadmap como contexto de entrada nao rastreado nesta janela.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "docs/brainstorm/rodada-2026-06-21/ROADMAP-macro-pos-blindagem-5-passos.md",
      ".hbn/messages/20260624-120000-opus-4-8-despacho-track-roadmap.md",
      ".hbn/readbacks/0090-track-roadmap-5-passos.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","guards/**","src/**","core/**","methodology/**","schemas/**",".hbn/freeze/**"]
  },
  "stop_condition": "Track 0090 (rastreamento do ROADMAP-macro-pos-blindagem-5-passos + ancoragem do STATE no roadmap) concluido. NAO iniciar o W-FREEZE (gate humano) neste commit. Handoff pos-roadmap fica como contexto de entrada, nao rastreado nesta janela.",
  "HBN-Readback": "0090",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-24T12:00:00-03:00",
  "protocol_version": "0.3.0"
}
⟦HBN-COPY END⟧
