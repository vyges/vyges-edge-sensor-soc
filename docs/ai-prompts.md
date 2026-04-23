# AI Prompt Log — Edge Sensor SoC

This is the ChipFoundry contest disclosure of AI-assisted work that produced artifacts committed to this repository. One entry per meaningful work session.

**Tools used**

- **Vyges SoC Generator** (proprietary, v0.3.0) — generates SoC RTL, firmware, constraints, OpenLane configs, block diagrams, and integration tests from a declarative design specification. Invocation-only disclosure; internals are not in scope for the contest submission.
- **Vyges IP Catalog** (`catalog.services.vyges.com`) — public IP catalog that resolves IP metadata (interfaces, parameters, integration hints) and RTL references by name.
- **Claude Code** (Anthropic Claude Opus 4.6) — code review, documentation drafting, and targeted scripting assistance. No RTL modules were written by Claude; RTL in this repository is generator output.
- **sv2v** — SystemVerilog → Verilog conversion for OpenLane ingestion.
- **OpenLane 2.3.10** / **KLayout** / **Magic** / **Netgen** / **OpenSTA** — RTL-to-GDSII, DRC, LVS, and STA.
- **ChipFoundry CLI** (`chipfoundry-cli`, via `cf harden` / `cf precheck` / `cf verify`) — contest-provided wrapper around the OpenLane/Caravel flow.
- **Verilator 5.040** + **cocotb 1.9.2** — SoC-level integration test runner.
- **Vivado 2025.2** — FPGA synthesis for structural validation on Arty A7-100T (bitstream not shipped with the contest repo).

---

## Flow overview

```text
design specification ──► IP catalog resolution ──► Vyges SoC Generator ──► sv2v ──► OpenLane ──► GDS
                                                              │
                                                              ├──► firmware (C + linker + boot ROM hex)
                                                              ├──► cocotb integration tests (smoke / buswalk / reset)
                                                              └──► planned floorplan SVG + labeled hardened PNG
```

The design specification declares the CPU, bus, peripherals, memory map, clock/reset topology, Caravel GPIO assignments, and the firmware application. The generator resolves every IP against the Vyges IP Catalog, reads each IP's `vyges-metadata.json` (the Vyges Silicon IP Nutrition Label — interfaces, parameters, integration hints), and composes the SoC without hand-written port wiring. Claude's role is confined to documentation, review, and auxiliary scripts; it does not produce RTL.

---

## Session 1: SoC generation

**Date:** 2026-03-15
**Tool:** Vyges SoC Generator + Vyges IP Catalog
**Artifact:** `verilog/rtl/`, `fw/`, `sdc/`, `docs/edge_sensor_block_diagram.svg`, `openlane/*/config.json`

### Prompt

```text
vyges-soc-generate <design-specification> --output build/
```

### Summary

Single invocation produces the full Edge Sensor SoC: TL-UL crossbar (`xbar_main`), Ibex RV32IMC CPU wrapper, UART, SPI Host, PLIC, FFT accelerator with its 4-bank sky130 SRAM wrapper, Caravel `user_project_wrapper` with GPIO glue, address-map package, per-corner SDC, SVG block diagram, and per-macro OpenLane configs. Nine IPs are resolved from the Vyges IP Catalog with no manual cloning.

### Files produced (selected)

- `verilog/rtl/xbar_main.sv` — TL-UL crossbar (1 host, 5 slaves)
- `verilog/rtl/rv_core_ibex_tlul.sv` — Ibex RV32IMC TL-UL wrapper
- `verilog/rtl/fft_ctrl_tlul.sv` — FFT TL-UL↔APB bridge wrapper
- `verilog/rtl/fft_data_sram.sv` — 4-bank sky130 SRAM wrapper for the FFT engine
- `verilog/rtl/edge_sensor_glue.v` — Caravel GPIO glue + tie-offs
- `verilog/rtl/caravel/user_project_wrapper.v` — Caravel top (seven macros, no logic)
- `docs/edge_sensor_block_diagram.svg` — architecture diagram
- `openlane/*/config.json` — per-macro OpenLane configs with proven placement

---

## Session 2: IP catalog resolution

**Date:** 2026-03-20
**Tool:** Vyges IP Catalog (`catalog.services.vyges.com`)
**Artifact:** IP metadata consumed by the generator during Session 1

### Prompt

```text
HTTP GET https://catalog.services.vyges.com/ip/{ip-name}
```

For each IP referenced in the design specification:
`opentitan-rv-core-ibex`, `opentitan-uart`, `vyges-spi-host-lite`, `vyges-rv-plic-lite`, `fast-fourier-transform-ip`, `tlul-apb-adapter`, `opentitan-tlul`, `opentitan-prim`, `opentitan-prim-generic`.

### Summary

The catalog returns the Vyges Silicon IP Nutrition Label for each IP: declared clock/reset ports, bus interface type and role, parameters and defaults, register offsets, interrupts, and `soc_generator_hints` used for wiring. No manual GitHub cloning or port-list transcription; the generator acts on the catalog response directly. The catalog entries used here are public at [github.com/vyges-ip](https://github.com/vyges-ip).

---

## Session 3: sv2v conversion

**Date:** 2026-03-28
**Tool:** sv2v (open-source)
**Artifact:** `verilog/rtl/soc_conv.v` (SystemVerilog → Verilog for OpenLane)

### Prompt

```text
sv2v --define=FFT_USE_SRAM_MACRO --top=edge_sensor_soc_top *.sv > soc_conv.v
```

### Summary

Flattens the generated SystemVerilog source set to plain Verilog for OpenLane ingestion. The `FFT_USE_SRAM_MACRO` define selects the sky130 SRAM hard-macro instantiation path in the FFT data memory wrapper instead of the behavioural memory used in simulation. Only the converted `soc_conv.v` is committed to this repository; the upstream SystemVerilog source set is the Vyges SoC Generator output from Session 1.

---

## Session 4: OpenLane hardening, DRC/LVS sign-off, and ChipFoundry precheck

**Date:** 2026-04-03 through 2026-04-08
**Tool:** OpenLane 2.3.10, KLayout, Magic, Netgen, `cf precheck`
**Artifact:** `gds/`, `lef/`, `lib/`, `verilog/gl/`, `spef/`, `signoff/`

### Prompt (final, per macro)

```text
openlane openlane/<macro>/config.json --run-tag final
```

followed by wrapper assembly and `cf precheck` on `user_project_wrapper`.

### Summary

Seven macros hardened bottom-up on sky130A, then composed inside the Caravel `user_project_wrapper` die. Per-macro GDS is retained for individual DRC/LVS review; the composed `user_project_wrapper.gds` is the tape-out-ready deliverable.

| Macro | Die (µm) | DRC | Notes |
| ------- | ---------- | ----- | ------- |
| `xbar_main` | 1100×1100 | 0 | Combinational TL-UL crossbar |
| `uart` | 700×700 | 0 | OpenTitan UART |
| `spi_host_lite` | 500×500 | 0 | Vyges SPI Host (lite) |
| `rv_plic_lite` | 400×400 | 0 | Vyges PLIC (lite) |
| `rv_core_ibex_tlul` | 1400×1400 | 0 | Ibex RV32IMC (hold closure) |
| `fft_ctrl_tlul` | 1300×2100 | 0 (KLayout) | 4× sky130 SRAM macros |
| `edge_sensor_glue` | 600×600 | 0 | Caravel GPIO glue |
| **`user_project_wrapper`** | **2920×3520** | **0 (KLayout)** | Seven macros placed + routed |

OpenLane configurations and macro placements were emitted by the Vyges SoC Generator alongside the RTL. `cf precheck` on the composed wrapper passes DRC, LVS, and the Caravel I/O ring checks. Per-corner SPEF (`nom` / `min` / `max`) is committed for each hardened macro and for the wrapper to support STA review by the contest judges. LVS was independently verified against a clean-room build of the same design.

---

## Session 5: Firmware generation (C + boot ROM)

**Date:** 2026-04-10
**Tool:** Vyges SoC Generator (firmware emission pass)
**Artifact:** `fw/main.c`, `fw/edge_sensor.h`, `fw/edge_sensor.inc`, `fw/crt0.S`, `fw/edge_sensor.ld`, `fw/Makefile`, `boot.hex`, `boot_rom.hex`

### Prompt

```text
vyges-soc-generate <design-specification> --output build/ --emit firmware
```

### Summary

The firmware pass produces a minimal bare-metal application that exercises every peripheral: UART banner and decimal output, SPI Host register touches, PLIC configuration, and an FFT start/poll sequence. It also emits `edge_sensor.h` with per-peripheral base addresses and register offsets, a linker script, `crt0.S`, and a `Makefile` that builds the `riscv64-unknown-elf-gcc` ELF and converts it to both `boot.hex` (byte-addressable Verilog hex, for reference) and `boot_rom.hex` (flat word-indexed hex, directly loadable via `$readmemh` into the Ibex boot ROM). The resulting firmware is what the integration tests in Session 7 execute.

### Files produced

- `fw/main.c` — SoC-level application (UART + SPI Host + PLIC + FFT)
- `fw/edge_sensor.h` / `fw/edge_sensor.inc` — register-level defines
- `fw/edge_sensor.ld` — linker script matching the SoC memory map
- `fw/crt0.S` — reset vector and stack setup
- `fw/Makefile` — builds ELF, `boot.hex`, and `boot_rom.hex`

---

## Session 6: Floorplan diagrams

**Date:** 2026-04-10
**Tool:** Vyges SoC Generator (floorplan renderers) + KLayout (headless)
**Artifact:** `docs/user_project_wrapper_floorplan.svg`, `docs/user_project_wrapper_layout.png`

### Prompt

```text
vyges-soc-generate <design-specification> --output build/ --emit floorplan
```

### Summary

Two complementary floorplan views are emitted. `user_project_wrapper_floorplan.svg` is a tool-independent planned floorplan generated from the same macro placement coordinates that drive the OpenLane wrapper configuration — it shows die outline, per-macro rectangles with category colouring (CPU / crossbar / FFT / SRAM / peripheral / glue), SRAM hard-block insets, S/E/W edge pin rows, and friendly display names with auto-shrinking labels. `user_project_wrapper_layout.png` is a post-hardening KLayout render of the actual wrapper GDS with the sky130A layer properties loaded, so reviewers can compare the planned and realised layouts side by side. The KLayout script is invoked automatically at the end of the wrapper hardening step and is non-fatal when KLayout is not installed.

---

## Session 7: SoC-level cocotb integration test stack + CI wiring

**Date:** 2026-04-10
**Tool:** Vyges SoC Generator (testbench emission pass), Verilator 5.040, cocotb 1.9.2
**Artifact:** `tb/cocotb/smoke/`, `tb/cocotb/buswalk/`, `tb/cocotb/reset/`, `tb/cocotb/sim_models/`, CI integration in `.github/workflows/user_project_ci.yml`

### Prompt

```text
vyges-soc-generate <design-specification> --output build/ --emit tb-cocotb
```

### Summary

Three SoC-level integration tests are emitted under `tb/cocotb/`, along with a behavioural sky130 SRAM model used for simulation only. Each test is a standalone cocotb + Verilator run with its own `Makefile`, SystemVerilog wrapper, and Python test. The same Python assertions run across the RTL target and the gate-level targets.

- **`smoke`** — boots the real `boot_rom.hex` from Session 5 into the Ibex local boot ROM via hierarchical `$readmemh`, clocks the SoC, and asserts the instruction-fetch PC advances past the boot entry. Wall-clock ≈ 1 s.
- **`buswalk`** — a small RV32I test program reads each peripheral's base address through the CPU data port, then halts via `wfi + jal -4`. cocotb asserts the CPU PC reaches the halt address, which exercises the real CPU → host adapter → crossbar → peripheral path. No `riscv-gcc` dependency at run time. Wall-clock ≈ 0.2 s.
- **`reset`** — asserts `rst_ni` three times during firmware execution and verifies that the CPU PC drops back into the boot ROM window during each hold and resumes cleanly after each release. This catches the integration-bug family where reset reaches the CPU but a downstream module survives the reset and stalls it. Wall-clock ≈ 4 s.
- **`sim_models/sim_sky130_sram_2kbyte_1rw1r_32x512_8.v`** — behavioural 1RW+1R SRAM model (512×32 with byte enables) that stands in for the sky130 hard macro during simulation.

Each test directory supports three Make targets: `make` (RTL), `make gls` (generic synthesised gate-level netlist), and `make gls-openlane` (hardened multi-macro `user_project_wrapper` with sky130 cell models). The gate-level targets are committed as a working scaffold that has been exercised internally against a separate clean-room build of the same design; the wrapper-level GLS run is deferred behind a future re-harden cycle in order to preserve the validated contest GDS. VCD waveform dumping is on by default; `WAVES=fst` switches to the smaller FST format.

The tests are wired into the existing `rtl-verification` CI job: five new steps install Verilator + cocotb + libxml2-utils, run the three tests in sequence, cross-check `results.xml` with `xmllint`, and (on failure only) upload `dump.vcd`, `results.xml`, and the `sim_build/` directory as workflow artifacts.

### Files produced

- `tb/cocotb/smoke/{Makefile,tb_smoke.sv,test_smoke.py,README.md}`
- `tb/cocotb/buswalk/{Makefile,tb_buswalk.sv,test_buswalk.py,busread.hex,README.md}`
- `tb/cocotb/reset/{Makefile,tb_reset.sv,test_reset.py,README.md}`
- `tb/cocotb/sim_models/sim_sky130_sram_2kbyte_1rw1r_32x512_8.v`
- `.github/workflows/user_project_ci.yml` — new `rtl-verification` steps

---

## Session 8: FPGA structural validation

**Date:** 2026-03-21
**Tool:** Vivado 2025.2
**Artifact:** Bitstream for Digilent Arty A7-100T — not committed to the contest repo

### Prompt

```text
vivado -mode batch -source build/synth/build_arty.tcl
```

### Summary

The same generator emits a Vivado build script and XDC constraints that produce an Arty A7-100T bitstream from the same RTL set. Synthesis is clean with zero DRC errors in roughly two minutes and is used solely as structural validation: it confirms module instantiations, port widths, clock/reset topology, and metadata-driven wiring before the ASIC hardening cycle. Bitstream and Vivado reports are not part of the contest deliverable and are kept outside this repository. Physical FPGA bring-up on a board is a planned next validation step.

---

## Session 9: Documentation review

**Date:** 2026-03-15 through 2026-04-11
**Tool:** Claude Code (Anthropic Claude Opus 4.6)
**Artifact:** `README.md`, `docs/` narrative sections, inline generator template comments

### Prompt (representative)

```text
Review the README and docs/ for clarity, consistency with the generated
block diagram, and compliance with the ChipFoundry contest submission
checklist. Keep engineering substance; do not rewrite RTL.
```

### Summary

Claude was used to review generated RTL and documentation for clarity, to draft README sections (architecture overview, reviewer guidance, BOM, verification narrative), and to write auxiliary helper scripts. All RTL, firmware, testbenches, OpenLane configs, SDC, and diagrams in this repository are produced by the Vyges SoC Generator. Claude did not author RTL modules.

---

## Session 10: PCBA generation (reference board)

**Date:** 2026-04-11
**Tool:** Vyges SoC Generator (PCBA emission pass) + KiCad 8.0.9 (ERC/DRC/gerber validation)
**Artifact:** `pcba/asic/`, `pcba/fpga/`

### Prompt

```text
vyges-soc-generate <design-specification> --emit pcba --output <workspace>/
```

### Summary

The PCBA emission pass extends the same declarative design specification to generate the reference board alongside the chip. The ASIC target produces a chipIgnite Caravel QFN-64 breakout with 11 components (FT232H USB bridge, W25Q32 QSPI flash, dual AP7361C LDOs for 1.8V core + 3.3V I/O, MCP809 reset supervisor, USB-C receptacle, ADXL355 Pmod header, Tag-Connect debug header, reset button, power LED), 13 signal nets cross-referenced to `caravel.gpio[]`, and 3 power rails with per-load decoupling budgets. The FPGA target produces an Arty A7-100T sensor daughterboard (4 components, 6 nets, Pmod passthrough). Board-side pin assignments are single-sourced from the chip-side GPIO declarations — changing a peripheral pin in the specification updates both the chip wrapper and the board schematic.

The generator emits KiCad 8 project files, schematics with real stock library symbol references (resolved against the KiCad 8 default symbol libraries), an authoritative netlist, BOM CSV, human-readable inspection files, and a 7-section modification guide for the KiCad GUI work. The physical layout starts from a fork of the `TinyTapeout/caravel-mvp-pcb` minimum-viable Caravel breakout (Apache-2.0), with upstream gerbers, drill files, 3D STEP model, board SVG, and schematic PDF exported via `kicad-cli` on a headless Ubuntu KiCad 8 installation.

### Files produced

- `pcba/asic/{edge_sensor_asic.kicad_pro, .kicad_sch, .net}` — KiCad project + schematic + netlist
- `pcba/asic/bom/edge_sensor_asic_bom.csv` — BOM
- `pcba/asic/MODIFICATION_GUIDE.md` — step-by-step KiCad GUI work guide
- `pcba/asic/inspection/{components,nets,power}.txt` — human-readable summaries
- `pcba/asic/template/` — TinyTapeout Caravel breakout fork + exported gerbers/STEP/SVG/PDF
- `pcba/fpga/` — FPGA daughterboard (same file set, no template fork)

---

## Session 11: Mechanical enclosure

**Date:** 2026-04-11
**Tool:** Vyges SoC Generator (enclosure emission) + OpenSCAD 2021.01 (STL rendering)
**Artifact:** `pcba/asic/mechanical/enclosure.scad`, `pcba/asic/mechanical/enclosure.stl`

### Prompt

```text
vyges-soc-generate <design-specification> --emit mechanical --output <workspace>/
```

### Summary

A parametric open-top enclosure generated from the `pcba.asic.mechanical` section of the design specification. The OpenSCAD script reads board dimensions (60 × 50 mm), corner radius (2 mm), mounting hole pattern (4× M3 at corners), component clearance (12 mm), and enclosure style (open-top box) from the specification and produces a 3D-printable housing with USB-C and Pmod connector cutouts, PCB support ledges, M3 standoffs with pilot holes for heat-set inserts, and Vyges branding embossed on the north wall, south wall, and interior floor (Lato Bold). Rendered to STL (206 KB, 692 vertices) via OpenSCAD on the Ubuntu build box. Designed for FDM/SLA 3D printing or CNC milling. The enclosure attaches to motor, pump, or compressor housings via M3 standoffs — application-specific through-holes for the mounting surface are left to the integrator.

---

## Session 12: ChipFoundry CF_SRAM commercial SRAM integration

**Date:** 2026-04-16
**Tool:** Vyges SoC Generator (SRAM backend emission)
**Artifact:** `openlane/fft_ctrl_tlul/config.json`, `openlane/fft_ctrl_tlul/cf_sram/`, `openlane/fft_ctrl_tlul/cf_sram_bb.v`, `openlane/fft_ctrl_tlul/sram_blackbox.spice`, `openlane/fft_ctrl_tlul/macro_placement.cfg`

### Prompt

```text
vyges-soc-generate <design-specification> --output <workspace>/
```

with the FFT peripheral declaring `memory.implementation.asic: cf_sram` in the design specification.

### Summary

Migrated the FFT accelerator's SRAM backend from the earlier OpenRAM-generated `sky130_sram_2kbyte_1rw1r_32x512_8` (4 banks) to ChipFoundry's `CF_SRAM_1024x32` commercial macro (2 banks), the recommended commercial SRAM for sky130 Caravel chipIgnite tapeouts. The generator emits a `cf_sram/` directory with the vendor-supplied GDS, LEF, Liberty and SPICE views; a blackbox Verilog stub for synthesis; a pin-level SPICE stub for LVS; a 2-bank macro placement on the FFT die; and the corresponding OpenLane `EXTRA_LEFS` / `EXTRA_LIBS` / `EXTRA_GDS_FILES` / `EXTRA_SPICE_MODELS` wiring. `fft_ctrl_tlul` re-hardens cleanly at its proven 1300 × 2100 µm geometry with the CF_SRAM banks along the left edge.

---

## Session 13: RISC-V Debug Module integration

**Date:** 2026-04-16
**Tool:** Vyges SoC Generator (debug-module expansion)
**Artifact:** `verilog/rtl/user_project_wrapper.v`, `verilog/gl/vyges_rv_dbg_tlul.v`, `openlane/vyges_rv_dbg_tlul/config.json`, `lvs/user_project_wrapper/lvs_config.json`

### Prompt

```text
vyges-soc-generate <design-specification> --output <workspace>/
```

with a `debug_module` block declaring `ip: vyges-rv-dbg-tlul`, `target_cpu: u_ibex`, a TL-UL slave region at `0x00010000` for the debug CSRs, System Bus Access as a second host on the main crossbar, and JTAG TAP pins routed to Caravel GPIO 7-11.

### Summary

Added a RISC-V Debug Spec 0.13 debug module using the Vyges-authored `vyges-rv-dbg-tlul` wrapper over `pulp-platform/riscv-dbg`. The generator wires the DM's debug-request interface to Ibex (halt / resume / single-step), exposes the DM's slave CSR region at `0x00010000` on the main TL-UL crossbar, and adds the DM's SBA master as a second crossbar host so `openocd` + `gdb` can read and write SoC memory without halting the CPU. JTAG TAP pins (TCK / TMS / TDI / TDO / TRST_n, IDCODE `0x10000001`) are routed to Caravel GPIO 7-11 via the `edge_sensor_glue` I/O mapping.

---

## Session 14: 8-macro wrapper re-harden (CF_SRAM + rv_dm)

**Date:** 2026-04-20
**Tool:** ChipFoundry CLI (`cf harden`) + LibreLane 2.4.6 + KLayout
**Artifact:** `gds/user_project_wrapper.gds.gz`, `lef/user_project_wrapper.lef`, `verilog/gl/user_project_wrapper.v`, `spef/`, `lib/`, `signoff/user_project_wrapper/`, `docs/user_project_wrapper_layout.png`

### Prompt (final, per macro)

```text
cf harden <macro>
```

invoked in the sequence emitted by the generator from `lvs/user_project_wrapper/lvs_config.json` (children first, wrapper last).

### Summary

Re-hardened `vyges_rv_dbg_tlul` at 1300 × 600 µm, re-hardened `fft_ctrl_tlul` at its proven 1300 × 2100 µm geometry with CF_SRAM backing, then composed the 8-macro `user_project_wrapper` at the full Caravel die (2920 × 3520 µm). The wrapper config declares every child macro in `MAGIC_EXT_ABSTRACT_CELLS` so the wrapper-scope DRC / LVS / XOR / illegal-overlap extractors preserve each child's macro boundary instead of re-flattening pre-signed-off internals. All 78 LibreLane flow stages complete cleanly. A KLayout render of the final GDS (`docs/user_project_wrapper_layout.png`, sky130A layer colors) is included as the proof-of-completion picture.

---

## Session 15: FPGA live vibration-to-UART bring-up

**Date:** 2026-04-18
**Tool:** Xilinx Vivado 2025.2 + OpenFPGALoader + `riscv64-unknown-elf-gcc` + OpenOCD + GDB
**Artifact:** firmware `boot_rom.hex`, Arty A7-100T bitstream (live capture superseded by `docs/edge_sensor_fpga_demo.gif` from Session 17)

### Prompt

```text
Bring up the Vyges Edge Sensor SoC on Arty A7-100T hardware: CPU boots from
boot_rom.hex, PLIC initializes, SPI reads the ADXL355 accelerometer, FFT
processes 1024-point samples, results stream over UART.
```

### Summary

Full end-to-end hardware loop validated on real silicon-equivalent FPGA fabric: Ibex CPU boots the firmware, initializes the PLIC, drives SPI to the ADXL355 Pmod sensor, feeds samples into the hardware FFT accelerator, and streams the resulting frequency-domain vibration signature over UART at 115 200 baud. The live UART capture from this session was superseded by the demo capture (`docs/edge_sensor_fpga_demo.gif`, session 17) which exercises the same stack plus the UART command interpreter. This session covered the TL-UL crossbar, PLIC interrupt vector, SPI Host, FFT ctrl, UART, and reset infrastructure end-to-end — the hardest bugs to catch post-tapeout.

---

## Session 16: 7-macro wrapper re-harden (no debug module)

**Date:** 2026-04-22
**Tool:** Vyges SoC Generator + ChipFoundry CLI (`cf harden`) + LibreLane 2.4.6 + KLayout
**Artifact produced:** `gds/user_project_wrapper.klayout.gds`, re-hardened `gds/{rv_core_ibex_tlul,xbar_main,edge_sensor_glue}.gds`, `docs/drc-waiver-summary.md`, `docs/user_project_wrapper_layout.png`

### Prompt

```text
vyges-soc-generate <design-specification> --output <workspace>/
```

with the `debug_module` block removed from the specification and the `floorplan.macro_locations` overrides set for 7-macro composition. Then `cf harden` per child macro followed by the wrapper.

### Summary of result

Recomposed the wrapper as a 7-macro design (CPU + crossbar + 4 peripherals + glue, no debug module), re-hardening the 3 macros whose port signatures changed (`rv_core_ibex_tlul`, `xbar_main`, `edge_sensor_glue`); the wrapper closes routing with 509 KLayout sign-off violations, all categorised in `docs/drc-waiver-summary.md` (354 CF_SRAM-internal, 141 wrapper density-fill, 14 glue residuals).

### Files modified

- `verilog/rtl/user_project_wrapper.v` — 7-macro composition, no debug instance
- `openlane/user_project_wrapper/config.json` — floorplan locations + macro list
- `openlane/rv_core_ibex_tlul/config.json` — synthesis strategy for firmware-variant tolerance
- `gds/`, `lef/`, `lib/`, `spef/multicorner/`, `verilog/gl/` — re-hardened signoff artifacts
- `docs/drc-waiver-summary.md` — per-rule KLayout DRC breakdown + waiver rationale

---

## Session 17: UART-resident debug command interpreter (firmware)

**Date:** 2026-04-21
**Tool:** Claude Code
**Artifact produced:** `fw/main.c`

### Prompt

```text
Add a UART-resident command interpreter to the firmware so a silicon
inspection or register poke is reachable over the UART console. Magic
byte sequence (VYDB) between telemetry windows opens a command loop
with read (R), write (W), jump (J), bus-slave enumeration (E), SPI
device enumeration (S), and exit (X). Restrict E to main-crossbar
slaves so a stuck bridged peripheral cannot hang the debug channel.
```

### Summary of result

Added a small state machine to the firmware main loop that watches UART RX for the 4-byte `VYDB` magic between telemetry windows and enters a command loop on match; commands dispatch to 32-bit register accesses, a jump, and enumeration helpers. Validated end-to-end on Arty A7-100T: the prompt opens between Prometheus windows, `E` lists the main-crossbar slaves with their ctrl + status registers, `X` resumes the telemetry stream.

### Files modified

- `fw/main.c` — UART-RX helpers, command parser, bus-slave + SPI-device enumeration

---

## The Vyges IP Catalog

All IP blocks in this SoC come from the [Vyges public IP catalog](https://github.com/vyges-ip). Each entry ships a `vyges-metadata.json` describing interfaces, parameters, register layout, integration hints, and quality metrics — the Vyges Silicon IP Nutrition Label.

| IP | Catalog entry | Role in SoC |
| ---- | --------------- | ------------- |
| opentitan-rv-core-ibex | [vyges-ip/opentitan-rv-core-ibex](https://github.com/vyges-ip/opentitan-rv-core-ibex) | RV32IMC CPU |
| opentitan-uart | [vyges-ip/opentitan-uart](https://github.com/vyges-ip/opentitan-uart) | UART peripheral |
| vyges-spi-host-lite | [vyges-ip/vyges-spi-host-lite](https://github.com/vyges-ip/vyges-spi-host-lite) | SPI Host (ADXL355 sensor) |
| vyges-rv-plic-lite | [vyges-ip/vyges-rv-plic-lite](https://github.com/vyges-ip/vyges-rv-plic-lite) | Interrupt controller |
| fast-fourier-transform-ip | [vyges-ip/fast-fourier-transform-ip](https://github.com/vyges-ip/fast-fourier-transform-ip) | 1024-point FFT accelerator |
| cf-sram | [vyges-ip/cf-sram](https://github.com/vyges-ip/cf-sram) | ChipFoundry CF_SRAM_1024x32 commercial SRAM (sky130) |
| tlul-apb-adapter | [vyges-ip/tlul-apb-adapter](https://github.com/vyges-ip/tlul-apb-adapter) | TL-UL ↔ APB bridge |
| opentitan-tlul | [vyges-ip/opentitan-tlul](https://github.com/vyges-ip/opentitan-tlul) | TL-UL primitives |
| opentitan-prim / opentitan-prim-generic | [vyges-ip/opentitan-prim](https://github.com/vyges-ip/opentitan-prim) | OpenTitan primitive libraries |

The Silicon IP Nutrition Label format is open and visible in every IP in the public catalog; the tooling that consumes it (Vyges SoC Generator, Vyges IP Catalog) is proprietary to Vyges Inc. and patent pending. For the contest submission, the relevant disclosure is the invocation and the resolved IP set — not the internals of the generator or the catalog service.
