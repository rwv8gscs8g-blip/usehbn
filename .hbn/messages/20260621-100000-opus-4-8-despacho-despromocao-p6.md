---
titulo: "Despacho — Despromocao-P6: G-ARVORE-LABEL cobre despromocao (rebaixamento rastreavel)"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md
readback_alvo: 0086-despromocao-p6
created_at: "2026-06-21T10:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - guards/assert-arvore-label.sh
  - REGISTRY.md
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho Despromocao-P6 / G-ARVORE-LABEL cobre despromocao

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T10:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T10:00:00-03:00 readback_ativo=.hbn/readbacks/0086-despromocao-p6.json; DESPROMOCAO-P6 PROPOSTO; main intocada 4db6928; HEAD 6b9bd3d.
PRÓXIMA AÇÃO: cross-audit da Despromocao-P6 (readback 0086)
SITUACAO: roadmap B, ultimo guard antes do W-FREEZE. G-ARVORE-LABEL (assert-arvore-label.sh) so cobre PROMOCAO (subir a intermediaria/estavel exige evento arvore-promocao + readback); REBAIXAR (estavel->fronteira) passa livre. P6 fecha: despromocao exige evento arvore-despromocao rastreavel.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- Simetria: hoje subir e gateado, descer nao. P6 exige que uma linha nova cujo arvore seja MENOR que a anterior do mesmo path seja tipo=arvore-despromocao + readback versionado; senao bloqueia. Preserva toda a logica de promocao.
- Implementacao (NAO selagem): regenerar atestacao same-fp; parar para cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: 6b9bd3d. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md, guards/hbn-guards-runner.sh.

READBACK A CRIAR: .hbn/readbacks/0086-despromocao-p6.json (0086 = proximo monotonico apos 0085).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Intencao
Hoje guards/assert-arvore-label.sh gateia PROMOCAO (linha nova com arvore intermediaria|estavel exige tipo=arvore-promocao + readback). DESPROMOCAO (rebaixar a arvore de um path ja promovido — ex.: estavel->fronteira via nova linha append-only) NAO e gateada: a linha nasce fronteira e passa livre. Fechar: despromocao tambem exige evento rastreavel.

## Comportamento exigido (voce escreve o bash — §2.10)
Em guards/assert-arvore-label.sh, ADICIONE deteccao de DESPROMOCAO, preservando TODA a logica de promocao atual:
1. ORDEM canonica: fronteira(0) < intermediaria(1) < estavel(2).
2. Para CADA linha NOVA (added) do REGISTRY com path P e arvore A valida: determine a arvore ANTERIOR de P = a arvore da linha 7-col MAIS RECENTE de P no REGISTRY ANTES deste commit (lê o blob base: HEAD:REGISTRY local / base em CI; ignore as proprias linhas added; ignore linhas legadas 5/6-col). Se P nao tinha arvore anterior, NAO ha despromocao (nasce fronteira normalmente).
3. Se A (nova) < arvore ANTERIOR de P (rebaixamento): EXIJA que a linha nova seja tipo=arvore-despromocao E referencie um readback versionado (.hbn/readbacks/NNNN-*.json existente) — reaproveite a funcao readback_ref_exists. Senao => guard_fail ("despromocao de '<P>' de <ant> para <A> sem evento tipo=arvore-despromocao + readback").
4. fail-closed; nao reavalie historico (so as linhas added deste commit). Preserve estavel=>quente e a checagem de promocao.

## STATE
- onda_atual: "DESPROMOCAO-P6 PROPOSTO — readback 0086; G-ARVORE-LABEL passa a gatear despromocao (rebaixamento rastreavel), aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; Despromocao-P6 0086 entregue/proposto"
- proxima_acao: "cross-audit da Despromocao-P6 (readback 0086)"
- ultima_atualizacao: "2026-06-21T10:00:00-03:00"
- readback_ativo: ".hbn/readbacks/0086-despromocao-p6.json"
- handoff_mais_recente: ".hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md"
- ACRESCENTE em sinais_abertos (no topo): "🔴 EXCEÇÃO F-01 / Despromocao-P6 PROPOSED_UNTIL_CROSS_AUDIT — readback 0086 safe_track, implementador=codex, autorizacao humana Mauricio, orq_entrada_ref presente; aguarda cross-audit != OpenAI + hearback antes de selagem."
- proximo_ponto (G-NEXT):
  proximo_ponto:
    passo: "cross-audit da Despromocao-P6 (readback 0086)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md
    status: pendente

## Testes exigidos (voce escreve fixtures/casos — secao G-ARVORE-LABEL)
- run-guard-tests.sh: caso BOM (despromocao COM linha tipo=arvore-despromocao + readback versionado => passa) + RUINS BLOQUEADOS: (i) rebaixar estavel->fronteira via linha comum (sem evento) => bloqueia; (ii) rebaixar intermediaria->fronteira sem evento => bloqueia; (iii) evento arvore-despromocao SEM referencia a readback => bloqueia. NEUTRO/REGRESSAO: promocao continua exigindo arvore-promocao+readback; nascer fronteira (sem anterior) passa; estavel=>quente preservado.
- adversarial-battery.sh: B88+ para as burlas de despromocao acima.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/assert-arvore-label.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md
- .hbn/readbacks/0086-despromocao-p6.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh.

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (assert-arvore-label.sh MODIFICADO => sem linha): o despacho 20260621-100000 e o readback 0086.

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

## scaffold — .hbn/readbacks/0086-despromocao-p6.json
{
  "readback_id": "0086-despromocao-p6",
  "execution_id": "despromocao-p6-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0086-despromocao-p6.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md",
  "understanding": "Estender G-ARVORE-LABEL (assert-arvore-label.sh) para gatear DESPROMOCAO: uma linha nova do REGISTRY cuja arvore seja menor que a arvore anterior do mesmo path (fronteira<intermediaria<estavel) exige tipo=arvore-despromocao + readback versionado; senao bloqueia. Preserva promocao e estavel=>quente. Forward-only, fail-closed. Testes (run-guard-tests + adversarial B88+). Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho Despromocao-P6 de 2026-06-21T10:00:00-03:00 sob token_fp 34a7f2f9; estender guard+testes+STATE+REGISTRY+atestacao dentro do files_allowed; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/assert-arvore-label.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-100000-opus-4-8-despacho-despromocao-p6.md",
      ".hbn/readbacks/0086-despromocao-p6.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh"]
  },
  "stop_condition": "Entrega 0086 (Despromocao-P6) em commit unico; parar para cross-audit != OpenAI. NAO selar. NAO iniciar W-FREEZE.",
  "HBN-Readback": "0086",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T10:00:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0086
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0086 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. NAO iniciar W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
