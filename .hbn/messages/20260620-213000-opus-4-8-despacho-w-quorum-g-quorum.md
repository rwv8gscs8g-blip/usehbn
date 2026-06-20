---
titulo: "Despacho — W-QUORUM: guard G-QUORUM (quorum de selagem >=2 familias != OpenAI)"
tipo: despacho
status: proposto
temperatura: frio
path: .hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md
readback_alvo: 0070-w-quorum-g-quorum
created_at: "2026-06-20T21:30:00-03:00"
autoria: "opus-4-8 (orquestrador · Anthropic) — bastao token_fp 34a7f2f9"
implementador_destino: "codex (OpenAI)"
orq_entrada_ref: .hbn/attestations/34a7f2f9-orq-entrada.json
relacionado:
  - .hbn/relay/STATE.md
  - guards/hbn-guards-runner.sh
  - guards/assert-auditor-id.sh
  - guards/data/auditor-families.txt
---

# HBN PEER REVIEW — Despacho W-QUORUM / G-QUORUM

## RELATO DE ESTADO — opus-4-8 · orquestrador · 2026-06-20T21:30:00-03:00
SOU: opus-4-8 · familia Anthropic · papel orquestrador.
STATE: .hbn/relay/STATE.md ultima_atualizacao=2026-06-20T21:30:00-03:00 readback_ativo=.hbn/readbacks/0070-w-quorum-g-quorum.json; G-QUORUM PROPOSTO; main intocada 4db6928; HEAD 6ad1638.
PRÓXIMA AÇÃO: cross-audit do G-QUORUM (readback 0070)
SITUACAO: A3 do "blindar o orquestrador" — tornar o quorum >=2 familias != OpenAI um fato de disco guard-enforçado, em vez de conferencia manual do orquestrador.
BASTAO: opus-4-8 (Anthropic), atestação v2 valida.

## Decisões informais (cápsula)
- A3/G-QUORUM mecaniza o que foi feito a mao no 0067 e no 0066: nenhuma SELAGEM passa sem >=2 pareceres canonicos de familias distintas != OpenAI.
- Forward-only (so o readback vigente ADICIONADO neste commit): selagens antigas (0065/0068/0069) nao sao reavaliadas. Acoplamento proximo_ponto<->orquestrador fica para W-ORQ-4.

⟦HBN-COPY dest=codex⟧ BEGIN
CONTEXTO (chat NOVO, sem memoria — tudo aqui e autossuficiente):
- Repo: ~/Projetos/usehbn. Branch: proposta/reestruturacao-m-a-s0. HEAD esperado: 6ad1638. main DEVE estar em 4db692876381a0d7909985c8500d999f2e677b04 e NUNCA ser tocada.
- Voce e o implementador (OpenAI). Orquestrador = opus-4-8 (Anthropic). §2.9a OK. TRACK: safe_track.
- LEIS: sem merge / sem --no-verify / sem `git add .` (stage EXPLICITO); honre TODOS os guards; se UM bloquear, PARE e relate, nunca contorne; VOCE escreve o bash (§2.10).
- IDEMPOTENCIA: se algo abaixo ja existir, confira e relate — NAO duplique. NAO toque em guards/data/** (o mapa) nem em core/read-list-canonica.txt.

READBACK A CRIAR: .hbn/readbacks/0070-w-quorum-g-quorum.json (0070 = proximo monotonico apos 0069).
ATO: implementacao (NAO e ato de autoridade). Regenere a atestacao same-fp via o GERADOR de C6 (NAO a mao). Pare no handoff para cross-audit != OpenAI. NAO selar.

## Intencao
Criar o guard G-QUORUM, que torna mecanica a regra "nenhuma SELAGEM sem quorum": todo commit que ADICIONA um readback com status "vigente" (= uma selagem) so passa se a proposta ratificada tiver >=2 pareceres canonicos de familias DISTINTAS != OpenAI com APROVA_<NNNN>: SIM no disco. Mecaniza o que o orquestrador fez a mao no 0067 e no 0066.

## Comportamento exigido (voce escreve o bash — §2.10)
Novo guard guards/assert-quorum-selagem.sh (G-QUORUM), padrao C3 (valida o BLOB STAGED via :path local; HEAD:path / range em CI; nunca a working tree, E-FECH-01). Use python3 para parse de JSON/front-matter (precedente assert-scope-lock / assert-next-checkpoint). Comportamento:
1. ESCOPO/GATILHO: considere apenas readbacks .hbn/readbacks/NNNN-*.json ADICIONADOS neste diff (diff-filter=A). Para cada um, leia o blob staged; se "status" != "vigente", IGNORE (nao e selagem). Se nao houver readback vigente adicionado, guard_ok e exit 0 (forward-only; selagens antigas nao sao reavaliadas).
2. Para CADA readback vigente adicionado:
   a. Ele DEVE declarar o campo top-level "seals_proposal" com um numero de 4 digitos (regex ^[0-9]{4}$) = a proposta/readback ratificada. Ausente/malformado => guard_fail (BLOQUEIA).
   b. Reuna os pareceres do disco em .hbn/results/ que ratificam NNNN: arquivos cujo basename casa "*-${NNNN}.md" E que existem no indice (git cat-file -e :path local / HEAD em CI). Para cada um, leia o front-matter "familia:" e "autor:" e confirme que o corpo contem a linha de veredito exata "APROVA_${NNNN}: SIM".
   c. Para cada parecer valido: "familia" deve existir em guards/data/auditor-families.txt E ser != OpenAI. Compute o CONJUNTO de familias DISTINTAS != OpenAI que tem APROVA_${NNNN}: SIM.
   d. Se |familias distintas != OpenAI com SIM| < 2 => guard_fail (BLOQUEIA, fail-closed) citando NNNN e o que faltou. Caso contrario, ok.
3. fail-closed em qualquer ambiguidade (readback ilegivel, seals_proposal ausente, pareceres faltando). NAO reavaliar selagens de commits passados.
4. Respeite guard_check_bypass (cabecalho padrao) e os helpers de lib/common.sh (guard_diff_files, guard_version_repo_path, guard_fail/ok, HBN_DIFF_BASE para CI).

## Ativacao
Adicionar G-QUORUM ao guards/hbn-guards-runner.sh nesta entrega. O proprio commit 0070 NAO adiciona readback vigente (0070 e status implemented_pending_cross_audit), logo G-QUORUM passa trivialmente (sem selagem no diff). Bootstrap do proximo_ponto: defina em STATE.md o front-matter:
  proximo_ponto:
    passo: "cross-audit do G-QUORUM (readback 0070)"
    ato: cross-audit
    destino: human
    gate: hearback_humano
    bloco_ref: .hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md
    status: pendente
Selo de vigencia: PROPOSED_UNTIL_CROSS_AUDIT (suite verde + cross-audit >=2 familias != OpenAI + hearback antes de selar; readback >=0071). NOTA: a partir do G-QUORUM ativo, TODA selagem futura (incl. a do proprio 0070) deve trazer "seals_proposal" no readback vigente + os 2 pareceres no commit.

## STATE (alem do proximo_ponto)
- onda_atual: "G-QUORUM PROPOSTO — readback 0070; guard de quorum de selagem >=2 familias != OpenAI no runner, aguardando cross-audit + hearback antes de selar"
- na string protocolo:, acrescente ao final (antes do parentese de fechamento): "; G-QUORUM 0070 entregue/proposto"
- proxima_acao: "cross-audit do G-QUORUM (readback 0070)"
- ultima_atualizacao: "2026-06-20T21:30:00-03:00"
- readback_ativo: ".hbn/readbacks/0070-w-quorum-g-quorum.json"
- handoff_mais_recente: ".hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md"

## Testes exigidos (voce escreve os fixtures/casos seguindo os padroes existentes)
- run-guard-tests.sh: caso BOM (readback vigente com seals_proposal e 2 pareceres de familias distintas != OpenAI com APROVA SIM => passa) + casos-RUINS BLOQUEADOS: (i) readback vigente sem seals_proposal; (ii) so 1 parecer != OpenAI; (iii) 2 pareceres mas MESMA familia; (iv) parecer de familia OpenAI nao conta; (v) parecer presente mas sem APROVA_NNNN: SIM.
- adversarial-battery.sh: entradas B71+ para as burlas acima (mirror do estilo write_auditor_id_result/mk_*_repo).
- bash guards/hbn-guards-runner.sh -> Todos os guards passaram.
- bash guards/tests/run-guard-tests.sh -> 0 falharam.
- bash guards/tests/adversarial-battery.sh -> BATERIA VERDE.
- git rev-parse main == 4db692876381a0d7909985c8500d999f2e677b04.

## files_allowed (stage EXPLICITO)
- guards/assert-quorum-selagem.sh
- guards/hbn-guards-runner.sh
- guards/tests/run-guard-tests.sh
- guards/tests/adversarial-battery.sh
- .hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md
- .hbn/readbacks/0070-w-quorum-g-quorum.json
- .hbn/relay/STATE.md
- REGISTRY.md
- .hbn/attestations/34a7f2f9-orq-entrada.json

## files_forbidden
main, core/**, methodology/**, schemas/**, src/**, docs/brainstorm/**, .hbn/freeze/**, guards/data/** (NAO tocar o mapa), core/read-list-canonica.txt.

## C-REGISTRY
APPEND em REGISTRY.md (append-only, 7-col fronteira/frio) uma linha por artefato novo (path como coluna exata): guards/assert-quorum-selagem.sh, o despacho 20260620-213000 e o readback 0070. (guards/*.sh e numbered/governed => exige linha.)

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

## scaffold — .hbn/readbacks/0070-w-quorum-g-quorum.json
{
  "readback_id": "0070-w-quorum-g-quorum",
  "execution_id": "w-quorum-g-quorum-2026-06-20",
  "agent_id": "codex",
  "implementador_id": "codex",
  "track": "safe_track",
  "status": "implemented_pending_cross_audit",
  "activation_status": "PROPOSED_UNTIL_CROSS_AUDIT",
  "hearback_status": "confirmed",
  "human_status": "confirmed",
  "path": ".hbn/readbacks/0070-w-quorum-g-quorum.json",
  "orq_entrada_ref": ".hbn/attestations/34a7f2f9-orq-entrada.json",
  "dispatch_ref": ".hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md",
  "understanding": "Criar G-QUORUM: toda selagem (readback vigente ADICIONADO) exige seals_proposal NNNN + >=2 pareceres canonicos de familias distintas != OpenAI com APROVA_NNNN: SIM no disco. Forward-only, fail-closed, blob staged. Adicionar ao runner + testes (run-guard-tests + adversarial B71+). Implementacao: regenerar atestacao same-fp, parar para cross-audit != OpenAI, NAO selar.",
  "authorization": {
    "human": "Mauricio (Luis Mauricio Junqueira Zanin)",
    "evidence": "Despacho W-QUORUM de 2026-06-20T21:30:00-03:00 sob token_fp 34a7f2f9; implementar guard+runner+testes+STATE+REGISTRY+atestacao dentro do files_allowed; parar para cross-audit != OpenAI.",
    "token_fp": "34a7f2f9"
  },
  "scope": {
    "files_allowed": [
      "guards/assert-quorum-selagem.sh",
      "guards/hbn-guards-runner.sh",
      "guards/tests/run-guard-tests.sh",
      "guards/tests/adversarial-battery.sh",
      ".hbn/messages/20260620-213000-opus-4-8-despacho-w-quorum-g-quorum.md",
      ".hbn/readbacks/0070-w-quorum-g-quorum.json",
      ".hbn/relay/STATE.md",
      "REGISTRY.md",
      ".hbn/attestations/34a7f2f9-orq-entrada.json"
    ],
    "files_forbidden": ["main","core/**","methodology/**","schemas/**","src/**","docs/brainstorm/**",".hbn/freeze/**","guards/data/**","core/read-list-canonica.txt"]
  },
  "stop_condition": "Entrega 0070 (G-QUORUM) em commit unico; parar para cross-audit != OpenAI. NAO selar. NAO iniciar W-ORQ-4/W-FREEZE.",
  "HBN-Readback": "0070",
  "HBN-Human-Authorization": "Mauricio (Luis Mauricio Junqueira Zanin)",
  "HBN-Token-FP": "34a7f2f9",
  "created_at": "2026-06-20T21:30:00-03:00",
  "protocol_version": "0.3.0"
}

## trailers (contiguos)
HBN-Readback: 0070
HBN-Human-Authorization: Mauricio (Luis Mauricio Junqueira Zanin)
HBN-Token-FP: 34a7f2f9

## stop_condition
Commit UNICO da entrega 0070 (prepare -> stage explicito -> COMMIT num so shot). Apos o commit, escreva .hbn/relay/RETURN.json (status ok + sha, ou blocked + blockers com guard/arquivo/linha) e PARE no handoff para cross-audit != OpenAI. NAO selar G-QUORUM. NAO iniciar W-ORQ-4/W-FREEZE. Reporte o SHA.
⟦HBN-COPY END⟧

— FIM DO DESPACHO —
