# How HBN Works

HBN starts with an explicit command identity:

- `usehbn`
- `use hbn`

When one of these triggers appears in a sentence, the protocol scaffold moves through a simple execution flow:

1. intent capture
2. request structuring
3. constraint and risk validation
4. safe execution
5. result documentation

In the current repository, this flow is implemented as:

- activation detection in `src/usehbn/trigger.py`
- intent structuring in `src/usehbn/protocol/intent.py`
- claim review in `src/usehbn/protocol/truth_barrier.py`
- warning aggregation in `src/usehbn/protocol/guardian.py`
- optional local consent capture in `src/usehbn/protocol/consent.py`

The runtime is deliberately minimal. It demonstrates protocol semantics rather than claiming a complete engineering engine.
