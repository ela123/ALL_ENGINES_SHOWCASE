#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RENDERS_DIR="$ROOT_DIR/renders"
PUBLIC_ASSETS="$ROOT_DIR/remotion/public/assets"

echo "=== [3/3] Preparing Remotion Assets & Rendering Master Showcase ==="
mkdir -p "$PUBLIC_ASSETS" "$RENDERS_DIR"

# Synchronize base assets
echo "Syncing base assets..."
cp -r "$ROOT_DIR/assets/"* "$PUBLIC_ASSETS/"

# Copy specialist renders
HF_RENDER="$RENDERS_DIR/hyperframes-showcase.mp4"
MANIM_RENDER="$RENDERS_DIR/manim/manim-showcase.mp4"
MANIM_3D_RENDER="$RENDERS_DIR/manim/manim-3d-showcase.mp4"

if [ -f "$HF_RENDER" ]; then
    cp -f "$HF_RENDER" "$PUBLIC_ASSETS/hyperframes-showcase.mp4"
else
    echo "ERROR: Required specialist render missing: $HF_RENDER" >&2
    exit 1
fi

if [ -f "$MANIM_RENDER" ]; then
    cp -f "$MANIM_RENDER" "$PUBLIC_ASSETS/manim-showcase.mp4"
else
    echo "ERROR: Required specialist render missing: $MANIM_RENDER" >&2
    exit 1
fi

if [ -f "$MANIM_3D_RENDER" ]; then
    cp -f "$MANIM_3D_RENDER" "$PUBLIC_ASSETS/manim-3d-showcase.mp4"
else
    echo "Notice: 3D render missing, duplicating 2D render..."
    cp -f "$MANIM_RENDER" "$PUBLIC_ASSETS/manim-3d-showcase.mp4"
fi

cd "$ROOT_DIR/remotion"
if [ ! -d "node_modules" ]; then
    echo "Installing Remotion dependencies..."
    npm install
fi

OUTPUT_MASTER="$RENDERS_DIR/integrated-showcase.mp4"
echo "Rendering Integrated Master Timeline (1920x1080 @ 30fps)..."

# Attempt Chromium GPU angle-egl, fallback to swangle or default
if npx remotion render src/index.ts IntegratedShowcase "$OUTPUT_MASTER" --gl=angle-egl --codec=h264 --crf=18; then
    echo "Remotion master rendered successfully with angle-egl."
elif npx remotion render src/index.ts IntegratedShowcase "$OUTPUT_MASTER" --gl=swangle --codec=h264 --crf=18; then
    echo "Remotion master rendered successfully with swangle fallback."
else
    echo "Rendering with default Remotion GL configuration..."
    npx remotion render src/index.ts IntegratedShowcase "$OUTPUT_MASTER" --codec=h264 --crf=18
fi

echo "Integrated Master Render completed: $OUTPUT_MASTER"
