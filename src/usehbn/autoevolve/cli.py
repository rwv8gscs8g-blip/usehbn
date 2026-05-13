"""CLI surface for `hbn autoevolve` subcommands.

Subcommands:
  plan        — push planned tasks for a cycle
  status      — human/JSON summary of cycle progress
  audit       — render aggregated markdown report from the audit JSONL
  approve     — toggle the human gate
  rollback    — show commands to revert a microdelta commit
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import List

from usehbn.autoevolve.audit import AuditWriter, audit_path_for_cycle
from usehbn.autoevolve.approval import HUMAN_GATE_FILE, human_gate_active


def _cmd_status(args) -> int:
    path = audit_path_for_cycle(args.cycle)
    audit = AuditWriter(path)
    rows = audit.read_all()
    if args.json:
        print(json.dumps(rows, ensure_ascii=False, indent=2))
        return 0
    if not rows:
        print(f"(no entries for cycle {args.cycle})")
        return 0
    print(f"cycle: {args.cycle}  entries: {len(rows)}")
    print(f"{'arm':<14} {'slug':<32} {'status':<9} tests")
    print("-" * 70)
    for r in rows:
        tests = "✓" if r.get("tests_passed") else "✗"
        print(f"{r.get('arm',''):<14} {r.get('slug',''):<32} {r.get('status',''):<9} {tests}")
    return 0


def _cmd_audit(args) -> int:
    path = audit_path_for_cycle(args.cycle)
    audit = AuditWriter(path)
    rows = audit.read_all()
    out: List[str] = []
    out.append(f"# Autoevolve cycle audit — {args.cycle}\n")
    out.append(f"Entries: **{len(rows)}**\n")
    if rows:
        out.append("| arm | slug | status | tests | commit |")
        out.append("|---|---|---|---|---|")
        for r in rows:
            tests = "✅" if r.get("tests_passed") else "❌"
            commit = (r.get("commit") or "")[:10]
            out.append(f"| {r.get('arm','')} | {r.get('slug','')} | {r.get('status','')} | {tests} | `{commit}` |")
    report = "\n".join(out) + "\n"
    if args.output:
        Path(args.output).write_text(report, encoding="utf-8")
        print(f"wrote {args.output}")
    else:
        print(report)
    return 0


def _cmd_approve(args) -> int:
    gate = Path(HUMAN_GATE_FILE)
    if args.lock:
        gate.parent.mkdir(parents=True, exist_ok=True)
        gate.write_text("locked\n", encoding="utf-8")
        print(f"human gate ACTIVE — auto microdeltas blocked ({HUMAN_GATE_FILE})")
    elif args.unlock:
        if gate.exists():
            gate.unlink()
        print("human gate RELEASED — auto microdeltas permitted")
    else:
        state = "ACTIVE" if human_gate_active() else "released"
        print(f"human gate: {state}")
    return 0


def _cmd_rollback(args) -> int:
    print(f"# To revert microdelta with commit {args.commit}:")
    print(f"git revert {args.commit}")
    print("# Then re-run: pytest -q")
    return 0


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(prog="hbn autoevolve", description="HBN autoevolve cycle orchestrator")
    sub = p.add_subparsers(dest="subcommand", required=True)

    s = sub.add_parser("status", help="show cycle status")
    s.add_argument("--cycle", required=True)
    s.add_argument("--json", action="store_true")
    s.set_defaults(func=_cmd_status)

    a = sub.add_parser("audit", help="render markdown audit report")
    a.add_argument("--cycle", required=True)
    a.add_argument("--output", default=None)
    a.set_defaults(func=_cmd_audit)

    g = sub.add_parser("approve", help="manage human gate")
    g.add_argument("--lock", action="store_true")
    g.add_argument("--unlock", action="store_true")
    g.set_defaults(func=_cmd_approve)

    r = sub.add_parser("rollback", help="print revert command for a microdelta")
    r.add_argument("--commit", required=True)
    r.set_defaults(func=_cmd_rollback)

    return p


def main(argv: List[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
