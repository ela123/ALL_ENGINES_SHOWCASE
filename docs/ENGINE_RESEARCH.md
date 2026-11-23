# Engine integration research notes

## Recommendation
Use a **staged, media-interchange pipeline** rather than attempting to make all engines execute inside one renderer.

- **Remotion** is the master timeline and final composition: React-based scenes, transitions, captions, layout, video/audio layers. For GPU-enabled Chromium rendering, Remotion documents `--gl=angle-egl` as recommended on Linux cloud GPU; the browser backend may still fall back if GPU access is unavailable.
- **HyperFrames** is the HTML/CSS/GSAP specialist layer. Its timeline must be paused, registered under `window.__timelines` matching the composition ID, and seekable. It can render MP4 or transparent WebM for overlay work.
- **ManimGL (3b1b/manim)** specializes in explanatory math, diagrams, geometry, graph animation and camera work. It outputs media, which can be used by another engine. This showcase imports ManimGL's render as a clip into the Remotion master.
- **FFmpeg** validates, normalizes, muxes and final-encodes. Use NVENC when the installed FFmpeg exposes it; otherwise fall back.

## Why not force a single engine?
Each engine's timeline and rendering model differs. Converting all native projects into a single engine would lose native semantics and add fragile adapters. The media boundary is the stable integration layer. HyperFrames documentation's integration guide describes media-level integration for outputs such as Manim, where pixels remain rendered media while timing, placement and layering stay editable in the host timeline.

## GPU caveats
A Colab GPU runtime provides CUDA devices, but not every video renderer uses CUDA. Chromium GPU/OpenGL availability is a separate capability; ManimGL requires an OpenGL context and may use Mesa software rendering in a headless Colab setup; HyperFrames `--gpu` can accelerate video encoding through an available hardware encoder; FFmpeg NVENC is only available if the FFmpeg build and GPU expose it. The notebook probes and falls back instead of pretending all stages are GPU accelerated.

## Official references
- Remotion GPU: https://www.remotion.dev/docs/gpu
- Remotion GL backends: https://www.remotion.dev/docs/gl-options
- HyperFrames CLI: https://hyperframes.app/docs/5-packages/cli
- HyperFrames rendering: https://hyperframes.app/docs/3-guides/4-rendering
- HyperFrames GSAP timeline contract: https://hyperframes.app/docs/3-guides/3-gsap-animation
- HyperFrames HTML schema: https://hyperframes.app/docs/6-reference/html-schema
- HyperFrames Remotion integration guide: https://github.com/heygen-com/hyperframes/blob/main/skills/remotion-to-hyperframes/SKILL.md
- ManimGL: https://github.com/3b1b/manim
