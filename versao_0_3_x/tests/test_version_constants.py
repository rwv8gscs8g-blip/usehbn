"""Tests for the PACKAGE_VERSION vs PROTOCOL_VERSION distinction (MD-H, ADR-004 v2)."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

import argparse

from usehbn import PACKAGE_VERSION, PROTOCOL_VERSION, __version__
from usehbn.cli import run_version


def test_version_constants_documented():
    """Both constants exist as strings and PACKAGE_VERSION is alias of __version__."""
    assert isinstance(PACKAGE_VERSION, str)
    assert isinstance(PROTOCOL_VERSION, str)
    assert isinstance(__version__, str)
    assert PACKAGE_VERSION == __version__
    # Sanity: both currently aligned at 0.3.0 — but they are independent
    # constants and can diverge in future releases without breaking the
    # contract.
    assert len(PACKAGE_VERSION.split(".")) == 3
    assert len(PROTOCOL_VERSION.split(".")) == 3


def test_run_version_publishes_both_package_and_protocol_version():
    """`hbn version` must publish both fields — the MD-H bug fix.

    Pre-MD-H, cli.run_version published only `protocol_version` populated
    with `__version__` (the package version), confusing consumers that
    inspected ERP records gravados with the same field name but populated
    with the actual PROTOCOL_VERSION constant.
    """
    result = run_version(argparse.Namespace())
    assert "package_version" in result
    assert "protocol_version" in result
    assert result["package_version"] == PACKAGE_VERSION
    assert result["protocol_version"] == PROTOCOL_VERSION
    assert result["cli"] == "hbn"


def test_records_publish_protocol_version_not_package_version():
    """ERP records must use PROTOCOL_VERSION, not __version__.

    Regression test for the MD-H bug: cli.py previously had 9 sites
    publishing `protocol_version: __version__` which is semantically
    wrong (records describe the protocol, not the CLI package).
    """
    import inspect

    from usehbn import cli

    src = inspect.getsource(cli)
    # Sanity: no remaining `"protocol_version": __version__` patterns.
    assert '"protocol_version": __version__' not in src, (
        "cli.py must publish protocol_version using PROTOCOL_VERSION "
        "(the protocol identity), not __version__ (the package identity). "
        "See MD-H / auditoria/00_status/06_MD_H_RESOLUCAO_VERSAO.md."
    )
