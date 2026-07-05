---
titulo: "Despacho — W-ORQ-4a: guard G-READLIST-RITE (edicao da read-list exige rito)"
tipo: despacho
status: congelado
temperatura: glacier
path: .hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md
readback_alvo: 0074-w-orq-4a-readlist-rite
created_at: "2026-06-21T00:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - core/read-list-canonica.txt
  - guards/hbn-guards-runner.sh
  - guards/assert-orq-entrada.sh
---

# HBN PEER REVIEW — Despacho W-ORQ-4a / G-READLIST-RITE

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T00:30:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T00:30:00-03:00 readback_ativo=.hbn/readbacks/0074-w-orq-4a-readlist-rite.json; W-ORQ-4a PROPOSTO; main intocada 4db6928; HEAD dc66f3e.
PRÓXIMA AÇÃO: cross-audit do W-ORQ-4a (readback 0074)
SITUACAO: roadmap B, faceta 1 de W-ORQ-4 (dividido por gate). Hoje so a CONTAGEM 13 protege a read-list; trocar path/hash/ordem passa despercebido. G-READLIST-RITE exige rito declarado para qualquer edicao de core/read-list-canonica.txt.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- W-ORQ-4 dividido em facetas (gate Mauricio): 4a=read-list sem rito (esta); proximas: orq_entrada_ref omitido; freeze sem dereferenciar; B1-B67 ao CI.
- Rito = mecanico e reaproveita estruturas: o commit que toca a read-list precisa stage de um readback declarando read_list_rite + human_status confirmed. Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: dc66f3e. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: neste commit NAO modifique core/read-list-canonica.txt (so adicione o guard/testes/STATE/readback). NAO toque guards/data/**.

READBACK A CRIAR: .hbn/readbacks/0074-w-orq-4a-readlist-rite.json (0074 = proximo monotonico apos 0073).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Intencao
Criar G-READLIST-RITE: qualquer commit que ADICIONE/MODIFIQUE core/read-list-canonica.txt so passa se carregar um RITO declarado — um readback staged que declara read_list_rite + human_status confirmed. Fecha o buraco onde editar a read-list por dentro (trocar path/hash/ordem, sem mudar a contagem 13) passa sem gate.

## Comportamento exigido (voce escreve o bash — §2.10)
Novo guard guards/assert-readlist-rite.sh (G-READLIST-RITE), padrao C3 (blob staged via :path local; HEAD:path / range em CI). Use python3 para parse. Comportamento:
1. GATILHO: core/read-list-canonica.txt aparece no diff com status A ou M (diff-filter=AM). Se NAO aparecer, guard_ok e exit 0.
2. Se aparecer, EXIJA prova de rito: entre os readbacks .hbn/readbacks/*.json ADICIONADOS/MODIFICADOS no MESMO diff, pelo menos UM blob staged deve ter:
   - campo top-level "read_list_rite" presente e nao-vazio (string nao-vazia; ex.: o id do readback ou "true"); E
   - campo "human_status" == "confirmed".
   Se nenhum readback staged satisfizer => guard_fail (BLOQUEIA, fail-closed), citando que a read-list mudou sem rito declarado.
3. fail-closed em qualquer ambiguidade (read-list mudou e nenhum readback staged; readback sem read_list_rite; human_status != confirmed). Respeite guard_check_bypass e helpers de lib/common.sh (guard_diff_files, guard_version_repo_path, HBN_DIFF_BASE).
Nota: este guard NAO substitui assert-orq-entrada (contagem 13); soma-se a ele.

## Ativacao
Adicionar G-READLIST-RITE ao guards/hbn-guards-runner.sh. O commit 0074 NAO toca core/read-list-canonica.txt, logo G-READLIST-RITE passa trivialmente. Bootstrap do proximo_ponto em STATE.md:
  proximo_ponto:
    passo: "cross-audit do W-ORQ-4a (readback 0074)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md
    status: pendente
Selo de vigencia: PROPOSED_UNTIL_CROSS_AUDIT (suite verde + cross-audit >=2 familias != OpenAI + hearback antes de selar; readback >=0075).

## STATE (alem do proximo_ponto)
- onda_atual: "W-ORQ-4a PROPOSTO — readback 0074; G-READLIST-RITE no runner (edicao da read-list exige rito declarado), aguardando cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; W-ORQ-4a 0074 entregue/proposto"
- proxima_acao: "cross-audit do W-ORQ-4a (readback 0074)"
- ultima_atualizacao: "2026-06-21T00:30:00-03:00"
- readback_ativo: ".hbn/readbacks/0074-w-orq-4a-readlist-rite.json"
- handoff_mais_recente: ".hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md"

## Testes exigidos (voce escreve fixtures/casos seguindo os padroes existentes)
- run-guard-tests.sh: caso BOM (read-list modificada + readback staged com read_list_rite e human_status confirmed => passa) + RUINS BLOQUEADOS: (i) read-list modificada SEM readback staged; (ii) readback staged SEM read_list_rite; (iii) read_list_rite presente mas human_status != confirmed. Caso NEUTRO: commit que NAO toca a read-list passa (guard_ok).
- adversarial-battery.sh: B76+ para as burlas acima.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/assert-readlist-rite.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md
- .hbn/readbacks/0074-w-orq-4a-readlist-rite.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/** (INCL core/read-list-canonica.txt — NAO tocar neste commit), methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**.

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato novo (path como coluna exata): guards/assert-readlist-rite.sh, o despacho 20260621-003000 e o readback 0074.

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

## scaffold — .hbn/readbacks/0074-w-orq-4a-readlist-rite.json
{
  "readback_id": "0074-w-orq-4a-readlist-rite",
  "execution_id": "w-orq-4a-readlist-rite-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0074-w-orq-4a-readlist-rite.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md",
  "understanding": "Criar G-READLIST-RITE: todo commit que adiciona/modifica core/read-list-canonica.txt exige um readback staged com read_list_rite (nao-vazio) + human_status confirmed; senao bloqueia (fail-closed, forward-only, blob staged). Adicionar ao runner + testes (run-guard-tests + adversarial B76+). Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar; este commit NAO toca a read-list.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho W-ORQ-4a de 2026-06-21T00:30:00-03:00 sob token_fp 34a7f2f9; implementar guard+runner+testes+STATE+REGISTRY+atestacao dentro do files_allowed; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/assert-readlist-rite.sh",
      "guards/hbn-guards-runner.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-003000-opus-4-8-despacho-w-orq-4a-readlist-rite.md",
      ".hbn/readbacks/0074-w-orq-4a-readlist-rite.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**"]
  },
  "stop_condition": "Entrega 0074 (G-READLIST-RITE) em commit unico; parar para cross-audit != OpenAI. NAO selar. NAO iniciar as outras facetas de W-ORQ-4 nem W-FREEZE.",
  "HBN-Readback": "0074",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T00:30:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0074
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0074 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar. NAO iniciar as outras facetas de W-ORQ-4/W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
