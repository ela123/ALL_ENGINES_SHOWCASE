#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================================="
echo " Starting Full All-Engines Multi-Stage Video Rendering Pipeline"
echo " Target Resolution: 1920x1080 @ 30 FPS"
echo "=========================================================="

"$SCRIPT_DIR/RENDER_HYPERFRAMES.sh"
"$SCRIPT_DIR/RENDER_MANIM.sh"
"$SCRIPT_DIR/RENDER_REMOTION.sh"

echo "All stages completed successfully!"
