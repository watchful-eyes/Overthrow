# Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
# Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
"""Execute the source regressions using an explicitly supplied SQF-VM binary."""
import argparse
from pathlib import Path
import re
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--sqfvm", required=True, type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    result = subprocess.run(
        [str(args.sqfvm.resolve()), "-a", "--suppress-welcome", "--no-work-print",
         "--no-execute-print", "--virtual", str(root / "addons" / "overthrow_main") + "|\\overthrow_main",
         "--input-sqf", str(root / "tests" / "regressions.sqf")],
        cwd=root, capture_output=True, text=True, encoding="utf-8", errors="replace", check=False,
    )
    output = result.stdout + result.stderr
    print(output)
    # Some VM failures still return zero; require an explicit completion marker as well.
    if result.returncode or re.search(r"\[(?:ERR|FAT)\]", output):
        return 1
    expected = (root / "tests" / "regressions.sqf").read_text(encoding="utf-8").count("call _check;")
    return 0 if f"OVERTHROW_REGRESSIONS_PASSED={expected}" in output else 1


if __name__ == "__main__":
    sys.exit(main())
