---
titulo: "Despacho — W-ORQ-4c: freeze-gate dereferencia a meta-superficie do orquestrador"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md
readback_alvo: 0078-w-orq-4c-freeze-deref
created_at: "2026-06-21T03:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - guards/freeze-gate.sh
  - core/freeze-gate-spec.md
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-ORQ-4c / freeze-gate dereferencia meta-superficie

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T03:30:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T03:30:00-03:00 readback_ativo=.hbn/readbacks/0078-w-orq-4c-freeze-deref.json; W-ORQ-4c PROPOSTO; main intocada 4db6928; HEAD a764b98.
PRÓXIMA AÇÃO: cross-audit do W-ORQ-4c (readback 0078)
SITUACAO: faceta 3/4 do W-ORQ-4. Hoje o freeze-gate so dereferencia hearback_ref do checklist e confia nos checkboxes; nao confere a meta-superficie do orquestrador. 4c faz o freeze-gate VETAR congelamento se houver proposta pendente (PROPOSED_UNTIL_CROSS_AUDIT) ou atestacao de entrada nao-verde.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- 4c ENDURECE guards/freeze-gate.sh (gate manual, fora do runner por-commit — risco baixo p/ commits normais) + atualiza core/freeze-gate-spec.md (NAO esta na read-list; nao muda a contagem 13). Modificacao de gate selado: cross-audit deve cacar regressao.
- Dereferenciar = conferir no DISCO, nao confiar no checkbox: nenhum readback PROPOSED_UNTIL_CROSS_AUDIT pendente + assert-orq-entrada verde. Implementacao (NAO selagem): regenerar atestacao same-fp; parar para cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: a764b98. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md, nem guards/hbn-guards-runner.sh.

READBACK A CRIAR: .hbn/readbacks/0078-w-orq-4c-freeze-deref.json (0078 = proximo monotonico apos 0077).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Intencao
Endurecer guards/freeze-gate.sh: hoje so dereferencia hearback_ref nas justificativas (anti-teatro) e confia no status dos checkboxes. Fazer o freeze-gate DEREFERENCIAR a meta-superficie do orquestrador no disco antes de declarar congelavel — fechando "freeze sem dereferenciar".

## Comportamento exigido (voce escreve o bash — §2.10)
1. Em guards/freeze-gate.sh, ALEM das checagens atuais (preservadas integralmente), ADICIONE duas verificacoes ATIVAS de disco (independentes dos checkboxes do checklist), executadas no diretorio do repo:
   a. META-DEREF PROPOSTAS: varra .hbn/readbacks/*.json (tracked, no worktree/HEAD). Se QUALQUER readback tiver activation_status == "PROPOSED_UNTIL_CROSS_AUDIT" (ou status == "implemented_pending_cross_audit"), VETE o freeze (exit != 0) citando o(s) readback(s) pendente(s). Congelar com proposta nao-ratificada = freeze sem dereferenciar.
   b. META-DEREF ATESTACAO: rode `bash guards/assert-orq-entrada.sh`; se nao retornar 0, VETE o freeze citando que a atestacao de entrada nao dereferencia limpo.
   Estas verificacoes sao BLOQUEADORAS (veto), independente do checklist. Use python3/jq para o parse. fail-closed.
2. PRESERVE todo o comportamento existente (criterios obrigatorios, na+hearback dereferenciavel, bloqueadores_abertos>0=veto). Nao altere o schema do checklist.

## STATE (alem do que segue) + spec
- Atualize core/freeze-gate-spec.md (§3 ou §2): documente os dois novos criterios meta (meta-deref-propostas, meta-deref-atestacao) como BLOQUEADORES ativos que o freeze-gate confere no disco, alem do checklist.
- proximo_ponto (G-NEXT exige) em STATE.md:
  proximo_ponto:
    passo: "cross-audit do W-ORQ-4c (readback 0078)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md
    status: pendente
- onda_atual: "W-ORQ-4c PROPOSTO — readback 0078; freeze-gate passa a dereferenciar a meta-superficie (propostas pendentes + atestacao), aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; W-ORQ-4c 0078 entregue/proposto"
- proxima_acao: "cross-audit do W-ORQ-4c (readback 0078)"
- ultima_atualizacao: "2026-06-21T03:30:00-03:00"
- readback_ativo: ".hbn/readbacks/0078-w-orq-4c-freeze-deref.json"
- handoff_mais_recente: ".hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md"

## Testes exigidos (voce escreve fixtures/casos seguindo os padroes existentes — secao G-FRZ)
- run-guard-tests.sh (G-FRZ): caso BOM (checklist ok + nenhum readback pendente + orq-entrada verde => congelavel) + RUINS VETADOS: (i) existe readback com activation_status PROPOSED_UNTIL_CROSS_AUDIT; (ii) atestacao de entrada nao-verde. Use repos/fixtures descartaveis (nao dependa do estado real do projeto). Regressao: os casos atuais de G-FRZ continuam.
- adversarial-battery.sh: B81+ se aplicavel ao padrao.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram (freeze-gate NAO esta no runner por-commit; mas o commit deve passar o runner normal).
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/freeze-gate.sh
- core/freeze-gate-spec.md
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md
- .hbn/readbacks/0078-w-orq-4c-freeze-deref.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/read-list-canonica.txt, core/orchestrator-profile-spec.md, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh. (core/freeze-gate-spec.md ESTA permitido acima; demais core/** proibido.)

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (freeze-gate.sh e freeze-gate-spec.md sao MODIFICADOS => NAO precisam de linha): o despacho 20260621-033000 e o readback 0078.

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

## scaffold — .hbn/readbacks/0078-w-orq-4c-freeze-deref.json
{
  "readback_id": "0078-w-orq-4c-freeze-deref",
  "execution_id": "w-orq-4c-freeze-deref-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0078-w-orq-4c-freeze-deref.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md",
  "understanding": "Endurecer guards/freeze-gate.sh para dereferenciar a meta-superficie do orquestrador no disco antes de declarar congelavel: vetar freeze se houver readback PROPOSED_UNTIL_CROSS_AUDIT pendente ou se assert-orq-entrada nao for verde. Atualizar core/freeze-gate-spec.md. Preservar comportamento existente (criterios, na+hearback, bloqueadores). Testes G-FRZ. Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho W-ORQ-4c de 2026-06-21T03:30:00-03:00 sob token_fp 34a7f2f9; endurecer freeze-gate+spec+testes+STATE+REGISTRY+atestacao dentro do files_allowed; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/freeze-gate.sh",
      "core/freeze-gate-spec.md",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-033000-opus-4-8-despacho-w-orq-4c-freeze-deref.md",
      ".hbn/readbacks/0078-w-orq-4c-freeze-deref.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/read-list-canonica.txt","core/orchestrator-profile-spec.md","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh"]
  },
  "stop_condition": "Entrega 0078 (W-ORQ-4c) em commit unico; parar para cross-audit != OpenAI. NAO selar. NAO iniciar 4d nem W-FREEZE.",
  "HBN-Readback": "0078",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T03:30:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0078
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0078 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. NAO iniciar 4d/W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
