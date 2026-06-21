---
titulo: "Despacho — W-ORQ-4d: integrar bateria adversarial + suite ao CI + guard G-CI-BATTERY"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md
readback_alvo: 0080-w-orq-4d-ci-battery
created_at: "2026-06-21T05:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .github/workflows/hbn-shield.yml
  - guards/hbn-guards-runner.sh
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-ORQ-4d / bateria no CI + G-CI-BATTERY

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T05:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T05:00:00-03:00 readback_ativo=.hbn/readbacks/0080-w-orq-4d-ci-battery.json; W-ORQ-4d PROPOSTO; main intocada 4db6928; HEAD 1a9e5fb.
PRÓXIMA AÇÃO: cross-audit do W-ORQ-4d (readback 0080)
SITUACAO: faceta 4/4 (ultima) do W-ORQ-4. O CI (.github/workflows/hbn-shield.yml:29) so roda o runner; a bateria adversarial e a suite ficam SO locais. 4d integra-as ao CI e adiciona um guard que trava a integracao (nao pode ser removida em silencio).
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- 4d fecha o W-ORQ-4: bateria (B1-B82) + suite passam a rodar no CI; G-CI-BATTERY (invariante no runner) garante que o workflow mantenha as duas invocacoes.
- Toca .github/workflows/hbn-shield.yml (modificado => sem linha de REGISTRY). Implementacao (NAO selagem): regenerar atestacao same-fp; parar para cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: 1a9e5fb. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash/yaml (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md.

READBACK A CRIAR: .hbn/readbacks/0080-w-orq-4d-ci-battery.json (0080 = proximo monotonico apos 0079).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Intencao
Integrar a bateria adversarial e a suite de guards ao CI (.github/workflows/hbn-shield.yml), que hoje so roda o runner. Adicionar G-CI-BATTERY: guard invariante (no runner) que garante que o workflow mantenha as invocacoes de run-guard-tests.sh E adversarial-battery.sh — para que a cobertura B1-B82 nao seja removida do CI em silencio.

## Comportamento exigido (voce escreve o yaml + o bash — §2.10)
1. EDITAR .github/workflows/hbn-shield.yml: ALEM do passo atual (`bash guards/hbn-guards-runner.sh`), ADICIONE dois passos que rodam no MESMO job/checkout:
   - `bash guards/tests/run-guard-tests.sh`
   - `bash guards/tests/adversarial-battery.sh`
   Ambos devem falhar o workflow (exit != 0) se houver regressao. Preserve o passo do runner e o env HBN_DIFF_BASE existente.
2. CRIAR guard guards/assert-ci-battery.sh (G-CI-BATTERY), padrao C3, INVARIANTE (roda todo commit; le o blob de .github/workflows/hbn-shield.yml no indice/HEAD, nao depende do diff): se o conteudo NAO contiver invocacao de guards/tests/run-guard-tests.sh OU de guards/tests/adversarial-battery.sh => guard_fail (fail-closed). Respeite guard_check_bypass e helpers de lib/common.sh. Adicionar ao guards/hbn-guards-runner.sh.

## Ativacao
O commit 0080 ja deixa o workflow com as duas invocacoes, logo G-CI-BATTERY passa (dogfood). Bootstrap do proximo_ponto em STATE.md:
  proximo_ponto:
    passo: "cross-audit do W-ORQ-4d (readback 0080)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md
    status: pendente

## STATE (alem do proximo_ponto)
- onda_atual: "W-ORQ-4d PROPOSTO — readback 0080; bateria adversarial + suite integradas ao CI e travadas por G-CI-BATTERY, aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; W-ORQ-4d 0080 entregue/proposto"
- proxima_acao: "cross-audit do W-ORQ-4d (readback 0080)"
- ultima_atualizacao: "2026-06-21T05:00:00-03:00"
- readback_ativo: ".hbn/readbacks/0080-w-orq-4d-ci-battery.json"
- handoff_mais_recente: ".hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md"

## Testes exigidos (voce escreve fixtures/casos seguindo os padroes existentes)
- run-guard-tests.sh: caso BOM (workflow com as duas invocacoes => G-CI-BATTERY passa) + RUINS BLOQUEADOS: (i) workflow sem run-guard-tests.sh; (ii) workflow sem adversarial-battery.sh. Use fixtures descartaveis.
- adversarial-battery.sh: B83+ para as burlas acima.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram (G-CI-BATTERY incluido).
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.
- (Opcional, se tiver `act` ou validador de yaml: confirme que hbn-shield.yml continua YAML valido.)

## files_allowed (stage EXPLICITO)
- .github/workflows/hbn-shield.yml
- guards/assert-ci-battery.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md
- .hbn/readbacks/0080-w-orq-4d-ci-battery.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**.

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (.github/workflows/hbn-shield.yml e MODIFICADO => NAO precisa de linha): guards/assert-ci-battery.sh, o despacho 20260621-050000 e o readback 0080.

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

## scaffold — .hbn/readbacks/0080-w-orq-4d-ci-battery.json
{
  "readback_id": "0080-w-orq-4d-ci-battery",
  "execution_id": "w-orq-4d-ci-battery-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0080-w-orq-4d-ci-battery.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md",
  "understanding": "Integrar bateria adversarial + suite ao CI (.github/workflows/hbn-shield.yml) e criar G-CI-BATTERY (guards/assert-ci-battery.sh, invariante no runner) que garante que o workflow mantenha as invocacoes de run-guard-tests.sh e adversarial-battery.sh. Adicionar ao runner + testes (run-guard-tests + adversarial B83+). Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho W-ORQ-4d de 2026-06-21T05:00:00-03:00 sob token_fp 34a7f2f9; integrar CI + guard + testes + STATE + REGISTRY + atestacao dentro do files_allowed; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      ".github/workflows/hbn-shield.yml",
      "guards/assert-ci-battery.sh",
      "guards/hbn-guards-runner.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-050000-opus-4-8-despacho-w-orq-4d-ci-battery.md",
      ".hbn/readbacks/0080-w-orq-4d-ci-battery.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**"]
  },
  "stop_condition": "Entrega 0080 (W-ORQ-4d) em commit unico; parar para cross-audit != OpenAI. NAO selar. NAO iniciar Despromocao-P6 nem W-FREEZE.",
  "HBN-Readback": "0080",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T05:00:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0080
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0080 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. NAO iniciar Despromocao-P6/W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
