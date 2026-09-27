#!/usr/bin/env bash
# Packages the addon into dist/BlessTheBlizzard-<version>.zip for CurseForge upload
set -euo pipefail

ADDON_NAME="BlessTheBlizzard"
FILES=("$ADDON_NAME.toc" "$ADDON_NAME.lua" "africa.mp3")

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VERSION="$(sed -n 's/^## Version:[[:space:]]*//p' "$ADDON_NAME.toc" | tr -d '\r')"
ZIP="dist/$ADDON_NAME-$VERSION.zip"

# CurseForge expects a top-level folder matching the TOC name
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir "$STAGE/$ADDON_NAME"
cp "${FILES[@]}" "$STAGE/$ADDON_NAME/"

mkdir -p dist
rm -f "$ZIP"

if command -v zip >/dev/null; then
    (cd "$STAGE" && zip -rq "$ROOT/$ZIP" "$ADDON_NAME")
elif command -v bsdtar >/dev/null; then
    bsdtar -a -cf "$ZIP" -C "$STAGE" "$ADDON_NAME"
elif [ -x /c/Windows/System32/tar.exe ]; then
    # Windows' built-in tar is bsdtar; Git Bash's own tar can't write zips
    /c/Windows/System32/tar.exe -a -cf "$ZIP" -C "$(cygpath -w "$STAGE")" "$ADDON_NAME"
else
    echo "No zip tool found (install zip or bsdtar)" >&2
    exit 1
fi

echo "Built $ZIP"
