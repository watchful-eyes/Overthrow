# Added 16 November 2026 for the community fork. GNU GPL v2.
"""Package an already signed/validated HEMTT release and corresponding source.

Run from the complete Git workspace after native validation, for example:
python tools/package_release.py --label 2.10.0-test.2 \
    --folder @OverthrowCE_GarrisonCommand_Test --output ..
Existing packages are never overwritten. Private keys/build caches are excluded.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
EXCLUDED_PARTS = {".git", ".hemttout", "__pycache__", "releases", "keys"}
EXCLUDED_SUFFIXES = {
    ".biprivatekey", ".hemttprivatekey", ".pyc", ".pbo", ".bisign",
    ".bikey", ".zip", ".7z", ".exe", ".log",
}
DOCS = [
    "BUILDING.md", "LICENSE.md", "mod.cpp", "README.md",
    "README_RELEASE_EN.md", "RELEASE_NOTES_EN.md", "TESTING_EN.md",
    "CREDITS.md", "MODIFICATIONS.md", "logo_overthrow.paa",
    "RELEASE_VALIDATION.json",
]
REQUIRED_SOURCE = {
    ".hemtt/project.toml", "addons/overthrow_main/config.cpp",
    "addons/overthrow_main/script_version.hpp", "LICENSE.md", "CREDITS.md",
    "addons/overthrow_main/functions/UI/dialogs/fn_adminCheatUI.sqf",
    "addons/overthrow_main/functions/admin/fn_processAdminCheat.sqf",
    "addons/overthrow_main/functions/util/fn_campaignForces.sqf",
    "addons/overthrow_main/functions/util/fn_applyCampaignForce.sqf",
    "addons/overthrow_main/ui/dialogs/notifications.hpp",
    "addons/overthrow_main/localization/strings.sqf",
}


def digest(path: Path) -> str:
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def safe_source(path: Path) -> bool:
    return (
        not any(part.casefold() in EXCLUDED_PARTS for part in path.parts)
        and path.suffix.casefold() not in EXCLUDED_SUFFIXES
        and path.name.casefold() not in {".hemttprivatekey", ".env"}
        and not path.name.casefold().startswith(".env.")
    )


def source_files() -> list[Path]:
    raw = subprocess.check_output(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
        cwd=ROOT,
    )
    result = []
    for name in sorted(set(raw.decode("utf-8").split("\0")) - {""}):
        relative = Path(name)
        if not safe_source(relative):
            continue
        source = ROOT / relative
        if not source.is_file():
            continue
        if source.is_symlink() or not source.resolve().is_relative_to(ROOT):
            raise ValueError(f"Source path escapes the repository: {relative}")
        result.append(relative)
    missing = REQUIRED_SOURCE - {path.as_posix() for path in result}
    if missing:
        raise ValueError(f"Missing corresponding source: {sorted(missing)}")
    return result


def check_archive(path: Path) -> None:
    with zipfile.ZipFile(path) as archive:
        if archive.testzip() is not None:
            raise ValueError(f"Archive CRC validation failed: {path.name}")
        for name in archive.namelist():
            item = Path(name)
            if item.is_absolute() or ".." in item.parts:
                raise ValueError("Unsafe archive path")
            if item.suffix.casefold() in {".biprivatekey", ".hemttprivatekey"} or item.name.casefold() == ".hemttprivatekey":
                raise ValueError("Private signing material in archive")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--label", required=True)
    parser.add_argument("--folder", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9.-]*", args.label):
        raise ValueError("Invalid release label")
    if not re.fullmatch(r"@[A-Za-z0-9_-]+", args.folder):
        raise ValueError("Invalid mod folder")
    validation = json.loads((ROOT / "RELEASE_VALIDATION.json").read_text(encoding="utf-8-sig"))
    if validation.get("release") != args.label or not validation.get("build", {}).get("signature_verified"):
        raise ValueError("Validation must identify this release and a verified signature")
    release = ROOT / ".hemttout" / "release"
    pbo = release / "addons" / "OT_overthrow_main.pbo"
    keys = list((release / "keys").glob("*.bikey"))
    signatures = list((release / "addons").glob("*.bisign"))
    if len(keys) != 1 or len(signatures) != 1:
        raise ValueError("Expected one public key and one PBO signature")
    build = validation["build"]
    for file, field in [(pbo, "pbo_sha256"), (keys[0], "public_key_sha256"), (signatures[0], "signature_sha256")]:
        if digest(file) != build.get(field):
            raise ValueError(f"Validation hash does not match {file.name}")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    stem = "OverthrowCE-" + args.label
    source_zip = output / (stem + "-source.zip")
    release_zip = output / (stem + "-release.zip")
    checksums = output / (stem + "-SHA256SUMS.txt")
    release_folder = output / (stem + "-release")
    if any(path.exists() for path in [source_zip, release_zip, checksums, release_folder]):
        raise FileExistsError("A package with this label already exists; nothing was overwritten")
    files = source_files()
    if any(path.as_posix() == "SOURCE_MANIFEST.json" for path in files):
        raise ValueError("Source manifest filename is reserved by the packager")
    manifest = {
        "release": args.label,
        "engine_addon_version": validation["engine_addon_version"],
        "git_base": build["git_base"],
        "source_changes_uncommitted": build["source_changes_uncommitted"],
        "sha256": {path.as_posix(): digest(ROOT / path) for path in files},
    }
    with zipfile.ZipFile(source_zip, "x", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in files:
            archive.write(ROOT / path, path.as_posix())
        archive.writestr("SOURCE_MANIFEST.json", json.dumps(manifest, indent=2) + "\n")
    check_archive(source_zip)
    mod = release_folder / args.folder
    for folder in ["addons", "keys", "source"]:
        (mod / folder).mkdir(parents=True, exist_ok=False)
    for file in [pbo, signatures[0]]:
        shutil.copy2(file, mod / "addons" / file.name)
    shutil.copy2(keys[0], mod / "keys" / keys[0].name)
    for name in DOCS:
        # These are the exact workspace documents included in the source ZIP.
        shutil.copy2(ROOT / name, mod / name)
    shutil.copy2(source_zip, mod / "source" / source_zip.name)
    payload = sorted(path for path in mod.rglob("*") if path.is_file())
    (mod / "SHA256SUMS.txt").write_text(
        "".join(f"{digest(path)}  {path.relative_to(mod).as_posix()}\n" for path in payload),
        encoding="utf-8",
    )
    with zipfile.ZipFile(release_zip, "x", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(mod.rglob("*")):
            if path.is_file():
                archive.write(path, path.relative_to(release_folder).as_posix())
    check_archive(release_zip)
    with zipfile.ZipFile(release_zip) as archive:
        prefix = args.folder + "/"
        if hashlib.sha256(archive.read(prefix + "addons/" + pbo.name)).hexdigest() != digest(pbo):
            raise ValueError("Packaged PBO differs from the tested PBO")
        if hashlib.sha256(archive.read(prefix + "source/" + source_zip.name)).hexdigest() != digest(source_zip):
            raise ValueError("Embedded source differs from standalone source")
    with zipfile.ZipFile(source_zip) as archive:
        for name, expected in manifest["sha256"].items():
            if hashlib.sha256(archive.read(name)).hexdigest() != expected:
                raise ValueError(f"Source snapshot hash mismatch: {name}")
    checksums.write_text(
        "".join(f"{digest(path)}  {path.name}\n" for path in [release_zip, source_zip]),
        encoding="utf-8",
    )
    print(json.dumps({
        "release": str(release_zip), "source": str(source_zip),
        "checksums": str(checksums), "mod_folder": str(mod),
        "source_files": len(files), "release_files": len(payload) + 1,
        "signature_verified": True, "archives_verified": True,
        "release_sha256": digest(release_zip), "source_sha256": digest(source_zip),
    }, indent=2))


if __name__ == "__main__":
    main()
