# Universal Translator

## Purpose

The HBN universal translator is the layer responsible for carrying a natural
HBN entry across different environments without forcing the human to learn the
machine path first.

Its job is to interpret canonical HBN semantic anchors such as:

- `usehbn`
- `use hbn`
- `usehbn.org`
- `usehbn.com`

and translate them into the correct machine path for the active environment.

## Problem It Solves

The human should not have to decide first whether they are talking to:

- a shell
- Codex
- ChatGPT
- Gemini
- Claude Code
- Antigravity
- Cursor
- Copilot
- a future runtime
- a legacy bridge

The translator should detect the environment, identify the active interface,
and normalize the natural instruction into the correct executable route.

## Current Translation Targets

In the current HBN runtime, natural input can be translated into:

- `hbn run "<sentence>"`
- `usehbn "<sentence>"`
- `use hbn ...` in shell environments bootstrapped by `get-hbn`
- repository-local runtime adapters for Codex, ChatGPT, Gemini, Claude Code, Antigravity, Cursor, and Copilot

## Translation Responsibilities

The universal translator must:

1. detect HBN activation in natural text
2. normalize the semantic anchor to `usehbn`
3. detect the current environment and runtime
4. select the correct machine path
5. preserve the original human sentence
6. remain extensible to future technologies
7. become the basis for later legacy-system translation layers

## Long-Term Direction

This translator is not only about shell ergonomics. It is the first general
environment-adaptation layer of HBN.

The same design logic is intended to evolve later into:

- translator bridges for legacy runtimes
- interface translators for heterogeneous tools
- normalization layers between human natural language and machine control paths

## Current State

The repository now includes an initial implementation scaffold in:

- `src/usehbn/translation/universal.py`
- `src/usehbn/connectors/`

This is not the final translator. It is the first explicit code layer that
models environment-aware natural-entry translation as a core HBN concern.

The connector layer now adds:

- human language profiling
- device profiling
- target-technology fingerprinting
- connector resolution by runtime + host + target + language
- trust-policy driven approval rules for installation and activation
