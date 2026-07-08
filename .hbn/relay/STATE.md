---
state_version: 1
tipo: relay-de-transicao
projeto: usehbn (canônico)
protocolo: "PONTEIRO — o STATE vivo mora na versão quente ativa"
proxima_acao: 'Leia .hbn/active-version e siga para <ativa>/.hbn/relay/STATE.md — este arquivo de raiz é só um relay de transição da terceira exúvia.'
ultima_atualizacao: "2026-07-05T02:30:00-03:00"
atualizado_por: fable-5
---

# STATE (relay de raiz — pós terceira exúvia)

Este arquivo NÃO é o estado vivo. Desde a terceira exúvia (v3.0.0):

1. `cat .hbn/active-version` → versão quente ativa.
2. O STATE operacional vive em `<versão-ativa>/.hbn/relay/STATE.md`.
3. O STATE histórico do exoesqueleto v0.3.x foi preservado, congelado, em
   `versao_0_3_x/.hbn/relay/STATE.md`.

Ele permanece na raiz apenas porque é o único canal de relay allowlistado
pelo G-HOT-WRITE fora da versão quente (metadado vital de transição).
