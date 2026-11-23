# Pipeline design and integration choices

1. **Scene authoring:** Remotion owns React-driven timeline and native video/caption composition. HyperFrames owns HTML/CSS/GSAP motion systems. ManimGL owns mathematical/diagram scenes.
2. **Timebase:** all final sequences use 30 fps; convert time to frames with round(seconds*fps). Specialist scene renders should export matching fps/resolution or be normalized by FFmpeg.
3. **Interchange:** MP4 for opaque scene outputs; WebM/PNG sequence for alpha overlays if an engine supports alpha. ManimGL output is normally a video asset.
4. **Compositing:** use a single final master timeline. Avoid encoding intermediate stages multiple times when possible. Prefer lossless PNG sequences or high-quality mezzanine output for VFX stages; sample pipeline uses high-quality MP4 for practical simplicity.
5. **Audio:** keep music and SFX as separate tracks in source timeline. Mix in FFmpeg with loudness control; avoid hard clipping. The sample ambient bed is synthetic.
6. **GPU:** Remotion Chrome GL and FFmpeg NVENC are distinct. HyperFrames `--gpu` refers to encoder acceleration. ManimGL OpenGL acceleration is contingent on an available GL context. Notebook probes hardware and permits fallback.
7. **Validation:** inspect output dimensions/fps/duration, run snapshots, review transitions, ensure audio is not clipped, and compare frame boundaries.
8. **Future upgrade:** add engine capability detection, render manifests, retry/resume, per-scene checksums, and a robust transparent overlay workflow before production automation.
