"""Chokepoint fail-closed para qualquer runtime mutável do useHBN."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
from typing import Iterable


class RuntimeLockError(RuntimeError):
    """A jaula detectou versão errada, drift ou mutação não autorizada."""


VERSION_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = VERSION_ROOT.parent
CANONICAL_POINTER = REPO_ROOT / ".hbn" / "canonical-root"
BASELINE = VERSION_ROOT / "scripts" / "jaula" / "BASELINE.sha256"


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _pointer_value(pointer: Path, label: str) -> str:
    try:
        lines = [
            line.strip()
            for line in pointer.read_text(encoding="utf-8").splitlines()
            if line.strip() and not line.lstrip().startswith("#")
        ]
    except OSError as exc:
        raise RuntimeLockError(f"{label} ilegível: {exc}") from exc
    if len(lines) != 1:
        raise RuntimeLockError(f"{label} deve ter exatamente uma linha")
    return lines[0]


def _canonical_root() -> Path:
    value = _pointer_value(CANONICAL_POINTER, "canonical-root")
    candidate = Path(value).expanduser()
    if not candidate.is_absolute():
        candidate = REPO_ROOT / candidate
    try:
        return candidate.resolve(strict=True)
    except OSError as exc:
        raise RuntimeLockError(f"canonical-root inválido: {exc}") from exc


def _active_version(canonical_root: Path) -> str:
    return _pointer_value(
        canonical_root / ".hbn" / "active-version", "active-version"
    )


def _baseline_records() -> dict[str, str]:
    records: dict[str, str] = {}
    try:
        for line in BASELINE.read_text(encoding="utf-8").splitlines():
            if not line.strip() or line.lstrip().startswith("#"):
                continue
            digest, rel = line.split(maxsplit=1)
            records[rel.lstrip("*")] = digest
    except (OSError, ValueError) as exc:
        raise RuntimeLockError(f"baseline inválida: {exc}") from exc
    return records


def assert_runtime_locked() -> None:
    canonical_root = _canonical_root()
    active_version = _active_version(canonical_root)
    try:
        active_root = (canonical_root / active_version).resolve(strict=True)
        module_root = VERSION_ROOT.resolve(strict=True)
    except OSError as exc:
        raise RuntimeLockError(f"versão ativa inválida: {exc}") from exc
    if module_root != active_root:
        raise RuntimeLockError(
            f"módulo fora da versão ativa: {module_root} != {active_root}"
        )
    records = _baseline_records()
    expected = records.get("guards/MANIFEST.yaml")
    if not expected or _sha256(VERSION_ROOT / "guards" / "MANIFEST.yaml") != expected:
        raise RuntimeLockError("drift no MANIFEST de guards")


def _within(path: Path, base: Path) -> bool:
    try:
        path.resolve(strict=False).relative_to(base.resolve(strict=True))
        return True
    except (OSError, ValueError):
        return False


def _confirmed_hearback(ref: str) -> bool:
    target = VERSION_ROOT / ref.lstrip("./")
    if not _within(target, VERSION_ROOT / ".hbn" / "hearbacks"):
        return False
    try:
        data = json.loads(target.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return False
    return data.get("status") in {"confirmed", "confirmado"} and bool(
        data.get("gate", {}).get("assinatura") or data.get("signed_by")
    )


def authorize_write(
    target: str | os.PathLike[str],
    *,
    actor: str,
    readback_ref: str,
    hearback_ref: str,
) -> Path:
    """Autoriza uma escrita do runtime; o chamador ainda realiza a gravação."""
    assert_runtime_locked()
    path = Path(target).expanduser().resolve(strict=False)
    if not _within(path, VERSION_ROOT):
        raise RuntimeLockError("destino fora da versão quente")
    if actor not in {"implementador", "humano"}:
        raise RuntimeLockError(f"ator sem capacidade de mutação: {actor}")
    rb = VERSION_ROOT / readback_ref.lstrip("./")
    if not _within(rb, VERSION_ROOT / ".hbn" / "readbacks") or not rb.is_file():
        raise RuntimeLockError("readback_ref inválido ou ausente")
    if not _confirmed_hearback(hearback_ref):
        raise RuntimeLockError("hearback humano confirmado/assinado ausente")
    return path


def run_allowed(argv: Iterable[str]) -> tuple[str, ...]:
    """Valida subprocesso sem executá-lo; nenhuma API genérica é exposta."""
    args = tuple(argv)
    if not args or args[0] not in {"git", "shasum", "sha256sum"}:
        raise RuntimeLockError("subprocesso fora da allowlist")
    if args[0] == "git" and (len(args) < 2 or args[1] not in {"status", "diff", "show"}):
        raise RuntimeLockError("git mutável recusado")
    return args


# A importação é o chokepoint: nenhum entrypoint pode carregar o runtime solto.
assert_runtime_locked()
