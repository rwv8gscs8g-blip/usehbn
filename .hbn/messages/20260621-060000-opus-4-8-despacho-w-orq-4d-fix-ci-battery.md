---
titulo: "Despacho — W-ORQ-4d-fix: endurecer G-CI-BATTERY contra bypass de comentario/echo"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260621-060000-opus-4-8-despacho-w-orq-4d-fix-ci-battery.md
readback_alvo: 0081-w-orq-4d-fix-ci-battery
created_at: "2026-06-21T06:00:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - guards/assert-ci-battery.sh
  - .hbn/results/20260621-053000-antigravity-cross-ia-w-orq-4d-0080.md
  - .hbn/relay/STATE.md
---

# HBN PEER REVIEW — Despacho W-ORQ-4d-fix / endurecer G-CI-BATTERY

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-21T06:00:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-21T06:00:00-03:00 readback_ativo=.hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json; W-ORQ-4d-FIX PROPOSTO; main intocada 4db6928; HEAD 40f03d3.
PRÓXIMA AÇÃO: cross-audit do W-ORQ-4d-fix (readback 0081)
SITUACAO: cross-audit do 0080 reprovou (antigravity APROVA_0080: NAO) — achou 2 bypasses no G-CI-BATTERY: comentario inline e echo do path satisfaziam o grep sem invocar o script. Fix endurece o guard para exigir invocacao REAL.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- Reprovacao legitima (k-0026/k-0028): grep de substring do path passava com `# bash ...` (comentario) ou `echo "bash ..."`. Fix: exigir que `bash <script>` seja o COMANDO de fato de um passo run, apos remover comentario inline e excluir echo/aspas.
- Adversarial B85 (bypass comentario) + B86 (bypass echo) devem BLOQUEAR. Implementacao (NAO selagem): regenerar atestacao same-fp; parar para re-cross-audit != OpenAI.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: 40f03d3. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- CRITICO: NAO toque core/read-list-canonica.txt, guards/data/**, core/orchestrator-profile-spec.md.

READBACK A CRIAR: .hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json (0081 = proximo monotonico apos 0080).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para re-cross-audit != OpenAI. NAO selar.

## Intencao
O cross-audit do W-ORQ-4d (readback 0080) reprovou: o G-CI-BATTERY (guards/assert-ci-battery.sh) usa grep de substring do caminho do script no workflow, o que e burlavel por (a) comentario inline `- run: echo "skip" # bash guards/tests/run-guard-tests.sh` e (b) echo `- run: echo "bash guards/tests/run-guard-tests.sh"`. Endurecer o guard para exigir a INVOCACAO REAL.

## Comportamento exigido (voce escreve o bash — §2.10)
1. ENDURECER guards/assert-ci-battery.sh. Para cada script obrigatorio S em {guards/tests/run-guard-tests.sh, guards/tests/adversarial-battery.sh}, exija que .github/workflows/hbn-shield.yml (blob no indice/HEAD) contenha uma INVOCACAO REAL de S como comando de um passo `run:`. Algoritmo robusto:
   - Para cada linha do workflow, REMOVA o comentario inline: corte a partir da primeira ocorrencia de " #" (espaco-hash) ate o fim da linha (alem de descartar linhas que comecam com #).
   - Identifique o(s) comando(s) do passo run: linha `^[[:space:]]*-?[[:space:]]*run:[[:space:]]*(.+)$` (comando inline) OU, em bloco escalar `run: |`/`run: >`, as linhas indentadas seguintes.
   - Tokenize o comando em segmentos por `&&`, `;`, `||`, `|` e quebras de linha; trim cada segmento.
   - S conta como invocado SOMENTE se algum segmento, apos o trim, COMECAR com `bash <S>` (regex `^bash[[:space:]]+<S esc>([[:space:]]|$)`). Assim, `echo "bash <S>"` (comeca com echo) e `# bash <S>` (removido pelo strip) NAO contam.
   - Se nenhum segmento real invocar S => guard_fail (fail-closed), citando S.
   Preserve guard_check_bypass e a natureza invariante (le indice/HEAD, nao depende de diff). Use python3 para o parse (mais seguro que sed/grep para isto).
2. PRESERVE o comportamento bom: o workflow atual (que invoca os dois scripts de verdade) deve continuar PASSANDO.

## STATE
- onda_atual: "W-ORQ-4d-FIX PROPOSTO — readback 0081; G-CI-BATTERY endurecido contra bypass de comentario/echo, aguardando re-cross-audit + hearback"
- na string protocolo:, acrescente antes do parentese final: "; W-ORQ-4d-fix 0081 entregue/proposto"
- proxima_acao: "cross-audit do W-ORQ-4d-fix (readback 0081)"
- ultima_atualizacao: "2026-06-21T06:00:00-03:00"
- readback_ativo: ".hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json"
- handoff_mais_recente: ".hbn/messages/20260621-060000-opus-4-8-despacho-w-orq-4d-fix-ci-battery.md"
- proximo_ponto (G-NEXT):
  proximo_ponto:
    passo: "cross-audit do W-ORQ-4d-fix (readback 0081)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260621-060000-opus-4-8-despacho-w-orq-4d-fix-ci-battery.md
    status: pendente

## Testes exigidos (voce escreve fixtures/casos — secao G-CI-BATTERY)
- run-guard-tests.sh: caso BOM (workflow com `bash guards/tests/run-guard-tests.sh` e `bash guards/tests/adversarial-battery.sh` como comandos reais => passa) + RUINS BLOQUEADOS, EXATAMENTE os dois bypasses reportados:
   (B85) `- run: echo "skip" # bash guards/tests/run-guard-tests.sh` (comentario inline) => BLOQUEIA.
   (B86) `- run: echo "bash guards/tests/adversarial-battery.sh"` (echo) => BLOQUEIA.
   Mantenha tambem os casos ja existentes (workflow sem a invocacao) bloqueando.
- adversarial-battery.sh: ADICIONE B85 (comentario inline) e B86 (echo) — ambos devem BLOQUEAR.
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/assert-ci-battery.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260621-060000-opus-4-8-despacho-w-orq-4d-fix-ci-battery.md
- .hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/**, guards/hbn-guards-runner.sh, .github/workflows/** (o workflow ja invoca os scripts de verdade; NAO precisa mudar — o fix e SO no guard/testes).

## C-REGISTRY
APPEND em REGISTRY.md (7-col fronteira/frio) uma linha por artefato NOVO (assert-ci-battery.sh e MODIFICADO => NAO precisa de linha): o despacho 20260621-060000 e o readback 0081.

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

## scaffold — .hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json
{
  "readback_id": "0081-w-orq-4d-fix-ci-battery",
  "execution_id": "w-orq-4d-fix-ci-battery-2026-06-21",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260621-060000-opus-4-8-despacho-w-orq-4d-fix-ci-battery.md",
  "understanding": "Corrigir G-CI-BATTERY (guards/assert-ci-battery.sh) apos reprovacao do cross-audit (antigravity APROVA_0080: NAO): substituir grep de substring por verificacao de INVOCACAO REAL (bash <script> como comando de passo run, apos remover comentario inline e excluindo echo/aspas). Adicionar adversarial B85 (bypass comentario) e B86 (bypass echo), ambos BLOQUEIAM. Implementacao: regenerar atestacao same-fp, parar para re-cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho W-ORQ-4d-fix de 2026-06-21T06:00:00-03:00 sob token_fp 34a7f2f9, motivado pela reprovacao em .hbn/results/20260621-053000-antigravity-cross-ia-w-orq-4d-0080.md; parar para re-cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/assert-ci-battery.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260621-060000-opus-4-8-despacho-w-orq-4d-fix-ci-battery.md",
      ".hbn/readbacks/0081-w-orq-4d-fix-ci-battery.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","guards/hbn-guards-runner.sh",".github/workflows/**"]
  },
  "stop_condition": "Entrega 0081 (W-ORQ-4d-fix) em commit unico; parar para re-cross-audit != OpenAI. NAO selar. NAO iniciar Despromocao-P6/W-FREEZE.",
  "HBN-Readback": "0081",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-21T06:00:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0081
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0081 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para re-cross-audit != OpenAI. NAO selar. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
