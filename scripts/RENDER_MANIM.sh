#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RENDERS_DIR="$ROOT_DIR/renders/manim"
mkdir -p "$RENDERS_DIR"

echo "=== [2/3] Rendering ManimGL Scenes ==="
cd "$ROOT_DIR/manim"

# Check if DISPLAY is set, or set default for Xvfb
if [ -z "${DISPLAY:-}" ]; then
    export DISPLAY=":99"
    if ! pgrep -x "Xvfb" > /dev/null; then
        echo "Starting Xvfb on display :99..."
        Xvfb :99 -screen 0 1920x1080x24 > /dev/null 2>&1 &
        sleep 2
    fi
fi

echo "Rendering Scene 1: RiskAndCompounding..."
manimgl scenes.py RiskAndCompounding -w -r 1920x1080 --fps 30 --video_dir "$RENDERS_DIR" --file_name manim-showcase

echo "Rendering Scene 2: LeverageSurface (3D)..."
if ! manimgl scenes.py LeverageSurface -w -r 1920x1080 --fps 30 --video_dir "$RENDERS_DIR" --file_name manim-3d-showcase; then
    echo "Warning: 3D scene failed under current GL context. Using 2D render as fallback for 3D track..."
    cp -f "$RENDERS_DIR/manim-showcase.mp4" "$RENDERS_DIR/manim-3d-showcase.mp4"
fi

echo "ManimGL rendering complete."
