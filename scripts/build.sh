#!/usr/bin/env bash
set -euo pipefail
PKG="${RBNX_PACKAGE_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
FLAGS=()
[[ "${RBNX_BUILD_CLEAN:-}" == "1" ]] && FLAGS+=(--clean)
rbnx codegen -p "$PKG" "${FLAGS[@]}"

VENV="$PKG/rbnx-build/venv"
uv venv --allow-existing --system-site-packages \
  --python "${AUDIO_DRIVER_PYTHON:-python3}" "$VENV"
ROBONIX_API="$(rbnx path robonix-api)"
uv pip install --python "$VENV/bin/python" --quiet "$ROBONIX_API" -r "$PKG/requirements.txt"

PYTHONPATH="$ROBONIX_API:$PKG:${PYTHONPATH:-}" \
  "$VENV/bin/python" -c 'import audio_driver.main'
echo "[build] done."
