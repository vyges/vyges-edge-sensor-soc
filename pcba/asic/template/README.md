# Upstream PCB template

This `template/` directory contains files copied verbatim from:

- Source: https://github.com/TinyTapeout/caravel-mvp-pcb
- Ref: main
- License: Apache-2.0

The original upstream filename stem is `caravel-mvp` and is preserved
so KiCad-internal file references continue to resolve. The Vyges PCBA
emitter substitutes generated nets and components into this layout in
Phase 3c. Phase 3b validates the kicad-cli pipeline (ERC, DRC, gerber,
drill, STEP, SVG export) on the unmodified template.
