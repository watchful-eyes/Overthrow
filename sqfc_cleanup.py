# Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
# Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
import sys
from pathlib import Path


def main():
    addon_base_path = Path(__file__).resolve().parent / "addons"
    if addon_base_path.is_symlink() or getattr(addon_base_path, "is_junction", lambda: False)():
        return 1
    for file in addon_base_path.rglob("*.sqfc"):
        if file.is_symlink() or not file.is_file():
            continue
        if file.resolve().is_relative_to(addon_base_path):
            file.unlink()
    return 0


if __name__ == "__main__":
    sys.exit(main())
