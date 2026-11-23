#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RENDERS_DIR="$ROOT_DIR/renders"
mkdir -p "$RENDERS_DIR"

echo "=== [1/3] Rendering HyperFrames Showcase ==="
cd "$ROOT_DIR/hyperframes"
if [ ! -d "node_modules" ]; then
    echo "Installing HyperFrames dependencies..."
    npm install
fi

echo "Running HyperFrames linter..."
npx hyperframes lint

OUTPUT_FILE="$RENDERS_DIR/hyperframes-showcase.mp4"
echo "Rendering HyperFrames scene (1920x1080 @ 30fps)..."
if npx hyperframes render --output "$OUTPUT_FILE" --fps 30 --quality high --gpu; then
    echo "HyperFrames render completed successfully using GPU encoding."
else
    echo "GPU encoding unavailable or failed; falling back to high-quality software encoding..."
    npx hyperframes render --output "$OUTPUT_FILE" --fps 30 --quality high
fi

if [ -f "$OUTPUT_FILE" ]; then
    echo "HyperFrames render verified: $OUTPUT_FILE"
else
    echo "ERROR: HyperFrames output not found at $OUTPUT_FILE" >&2
    exit 1
fi
