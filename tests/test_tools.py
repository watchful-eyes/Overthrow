# Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
# Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
"""Run with: python -m unittest discover -s tests -p test_*.py -v"""
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "addons" / "overthrow_main"


class CleanupTests(unittest.TestCase):
    def test_cleanup_uses_script_addons_and_leaves_siblings_alone(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            project = base / "project"
            addon = project / "addons" / "test"
            addon.mkdir(parents=True)
            shutil.copyfile(ROOT / "sqfc_cleanup.py", project / "sqfc_cleanup.py")
            compiled = addon / "fn_test.sqfc"
            source = addon / "fn_test.sqf"
            sibling = base / "unrelated.sqfc"
            outside_addons = project / "keep.sqfc"
            for path in (compiled, source, sibling, outside_addons):
                path.write_text("fixture", encoding="utf-8")
            subprocess.run([sys.executable, str(project / "sqfc_cleanup.py")], cwd=base, check=True)
            self.assertFalse(compiled.exists())
            for path in (source, sibling, outside_addons):
                self.assertEqual(path.read_text(encoding="utf-8"), "fixture")


class RemoteConfigurationTests(unittest.TestCase):
    def test_all_remote_calls_are_covered_by_the_shared_allowlist(self):
        config = (ADDON / "CfgRemoteExec.hpp").read_text(encoding="utf-8")
        allowed = set(re.findall(r"class\s+(\w+)\s*\{", config.lower()))
        calls = {}
        pattern = re.compile(r'''remoteExec(?:Call)?\s*\[\s*["']([^"']+)["']''', re.IGNORECASE)
        for path in ADDON.rglob("*"):
            if path.suffix not in {".sqf", ".hpp", ".cpp", ".ext", ".inc", ".sqm"}:
                continue
            for match in pattern.finditer(path.read_text(encoding="utf-8-sig")):
                calls[match[1].lower()] = str(path.relative_to(ROOT))
        self.assertFalse({name: path for name, path in calls.items() if name not in allowed})
        self.assertEqual(len(re.findall(r"mode\s*=\s*1\s*;", config)), 2)
        for unsafe in ("call", "spawn", "compile", "addAction", "addEventHandler", "assignCurator", "unassignCurator"):
            self.assertNotIn(unsafe.lower(), allowed)

    def test_every_mission_uses_the_same_remote_configuration(self):
        common = (ADDON / "mission_component.hpp").read_text(encoding="utf-8")
        self.assertIn('"\\overthrow_main\\CfgRemoteExec.hpp"', common)
        missions = list((ADDON / "campaign" / "missions").glob("OverthrowMp*/description.ext"))
        self.assertEqual(len(missions), 4)
        for path in missions:
            text = path.read_text(encoding="utf-8")
            self.assertIn("mission_component.hpp", text)
            self.assertNotIn("class CfgRemoteExec", text)


if __name__ == "__main__":
    unittest.main()
