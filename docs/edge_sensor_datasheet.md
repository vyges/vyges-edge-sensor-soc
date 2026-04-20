# Edge Sensor SoC

**Ibex RV32IMC RISC-V · TL-UL (OpenTitan TileLink) · ASIC · SKY130**

*Generated: 2026-04-20*

---

## 1. Product Overview

The **Edge Sensor SoC** is a custom ASIC designed for industrial vibration monitoring and predictive maintenance. Built on the SKY130 open-source PDK, it integrates a Ibex RV32IMC RISC-V processor core with and 4 memory-mapped peripheral(s) connected via a TL-UL (OpenTitan TileLink) on-chip crossbar. The SoC runs at 40 MHz and is designed to perform real-time frequency-domain signal analysis at the edge without a host CPU.

## 2. Key Features

- **Processor:** Ibex RV32IMC RV32IMC at 40 MHz
- **UART:** Full-duplex, programmable baud rate, TL-UL slave
- **Vyges Spi Host Lite:** SPI host, configurable polarity/phase, TL-UL slave
- **Vyges Rv Plic Lite:** TL-UL slave peripheral
- **FFT Accelerator:** TL-UL slave peripheral
- **ROM:** 32KB @ `0x00008000`
- **RAM:** 128KB @ `0x10000000`
- **Bus:** TL-UL (OpenTitan TileLink) crossbar with 6 slave(s)
- **On-chip SRAM:** ChipFoundry CF_SRAM commercial 1024×32 single-port macros (validated sky130 silicon IP; deployed in the FFT accelerator's sample and twiddle-factor memories)
- **Process:** SKY130 130 nm open-source PDK
- **Target package:** Caravel chipIgnite harness (QFN64)
- **Interrupts:** 14 sources via PLIC (priority + claim/complete)
- **Power domains:** main, aon
- **Lifecycle:** manufacturing → development → production → rma
- **Crossbars:** main, apb (multi-xbar hierarchy)
- **License:** Apache-2.0 (all IP blocks)

## 3. Applications

- Industrial vibration monitoring for motors, pumps, and compressors
- Predictive maintenance — hardware FFT for real-time anomaly detection
- Edge IoT sensor nodes with on-chip signal processing
- Open-silicon tapeout reference design (Caravel chipIgnite / SKY130)
- Hardware FFT acceleration benchmark vs. soft-core DSP

## 4. Block Diagram

![Edge Sensor Block Diagram](edge_sensor_block_diagram.svg)

| Block | Instance | IP | Bus Interface |
|---|---|---|---|
| CPU | `u_ibex` | `opentitan-rv-core-ibex` | TL-UL host |
| Crossbar | `xbar_main` | *(generated)* | TL-UL |
| Peripheral | `u_uart` | `opentitan-uart` | TL-UL slave |
| Peripheral | `u_spi_host` | `vyges-spi-host-lite` | TL-UL slave |
| Peripheral | `u_plic` | `vyges-rv-plic-lite` | TL-UL slave |
| Peripheral | `u_fft` | `fast-fourier-transform-ip` (2× CF_SRAM_1024x32) | TL-UL slave |
| Memory (rom) | `u_rom` | *(generic)* | TL-UL slave |
| Memory (ram) | `u_ram` | *(generic)* | TL-UL slave |
| Debug | `u_dm` | `vyges-rv-dbg-tlul` | TL-UL slave + SBA master + JTAG TAP |

## 5. Memory Organization

| Region | Instance | Base Address | Size | Type |
|---|---|---|---|---|
| UART | `u_uart` | `0x40000000` | 4KB | Peripheral registers |
| Vyges Spi Host Lite | `u_spi_host` | `0x40200000` | 4KB | Peripheral registers |
| Vyges Rv Plic Lite | `u_plic` | `0x40300000` | 4KB | Peripheral registers |
| FFT Accelerator | `u_fft` | `0x40100000` | 4KB | Peripheral registers |
| ROM | `u_rom` | `0x00008000` | 32KB | ROM (firmware) |
| RAM | `u_ram` | `0x10000000` | 128KB | SRAM (data/stack) |
| Debug Module | `u_dm` | `0x00010000` | 8KB | Debug CSRs + ROM (JTAG-only) |

## 6. Peripheral Overview

| Peripheral | Instance | Interface | Key Specification |
|---|---|---|---|
| UART | `u_uart` | TL-UL slave | TX/RX FIFO; programmable baud; 8N1 default |
| Vyges Spi Host Lite | `u_spi_host` | TL-UL slave | Up to 4 chip-selects; CPOL/CPHA configurable |
| Vyges Rv Plic Lite | `u_plic` | TL-UL slave | — |
| FFT Accelerator | `u_fft` | TL-UL slave | — |

## 6a. Debug Interface

RISC-V Debug Spec 0.13 run-control via JTAG TAP. The `u_dm` instance of `vyges-rv-dbg-tlul` exposes a single TL-UL slave region (8KB at `0x00010000`) and a TL-UL host port (System Bus Access). External debuggers (openocd/gdb) attach via the JTAG pins routed to Caravel GPIOs.

| Signal | Direction | Pin / GPIO | Notes |
|---|---|---|---|
| `TCK` | input | GPIO 7 | JTAG clock |
| `TMS` | input | GPIO 8 | TAP state-machine select |
| `TDI` | input | GPIO 9 | Serial data in |
| `TDO` | output | GPIO 10 | Serial data out |
| `TRST_N` | input | GPIO 11 | Optional async reset (tied high when unmapped) |

**Parameters:**

- `IdcodeValue`: `0x10000001` (32-bit TAP IDCODE)
- `NrHarts`: 1
- `BusWidth`: 32-bit
- `DmBaseAddress`: `0x00010000`

**Supported operations:** halt / resume / single-step, CSR + GPR read/write via abstract commands, debug-ROM-based program buffer execution, hardware breakpoint/watchpoint (via CPU trigger module), memory R/W via SBA (when wired as an xbar host — MVP integration ties SBA off).

## 7. Clock Architecture

| Clock | Source | Port | Frequency | Period |
|---|---|---|---|---|
| `clk_sys` | primary | `clk_i` | 40 MHz | 25.0 ns |

- **`sys`** domain clocked by `clk_sys`; reset synchronizer at `u_rst_sync/sync_ff`

## 8. Electrical Characteristics

Derived from SkyWater SKY130 HD standard cell library specifications.

| Parameter | Min | Typical | Max | Unit |
|---|---|---|---|---|
| Core supply voltage (VDD) | 1.60 | 1.80 | 1.95 | V |
| I/O supply voltage (VDDIO) | 1.62 | 1.80 | 1.98 | V |
| Operating temperature | −40 | 25 | 125 | °C |
| Clock frequency | — | 50 | 50 | MHz |

**Process corners used for STA:**

- **TT** (tt): 25 °C, 1.8 V
- **SS** (ss): 100 °C, 1.6 V
- **FF** (ff): -40 °C, 1.95 V

## 8.5 Synthesis Statistics

Synthesized with **Yosys 0.33** targeting **sky130_fd_sc_hd** (tt 025C 1v80, 130 nm CMOS). PDK installed via [ciel](https://pypi.org/project/ciel/) (version hash `6d4d11780c40...`).

NAND2 reference cell area: **3.75 μm²** (sky130 HD, drive strength 1).

| Module | Cells | Area (μm²) | Gate Equiv. | Notes |
|---|---|---|---|---|
| `xbar_main` | 221 | 1,378 | ~367 | TL-UL 1-host/4-slave crossbar (soc-generator output); Yosys measured 2026-03-15; pure combinational |
| `uart` | 4,551 | 55,372 | ~14,765 | Full OpenTitan UART (uart_core + uart_reg_top); Yosys measured 2026-03-15. Includes 2×64-entry FIFOs, alert/interrupt, TL-UL register bus. uart_core alone is 3,489 cells / 46,049 μm² / 12,280 GE. |
| `ibex_top` | 14,664 | 124,021 | ~33,072 | Full Ibex RV32IMC (ibex_core + ibex_register_file_ff + ibex_cs_registers); Yosys measured 2026-03-15. Config: SecureIbex=0, ICache=0, WritebackStage=0. ibex_core alone is 9,654 cells / 76,707 μm² / 20,455 GE. Published 50K GE is for hardened ICache+SecureIbex config. |
| `fft_ctrl_tlul` | 128,391 | 2,392,959 | ~638,122 | FFT accelerator + TL-UL→APB bridge (full hierarchy); Yosys measured 2026-03-15. Area dominated by synthesized memories: 65,893 enable-FFs (~1.98M μm²) = double-buffered 1024×32b sample RAM; combinational mux tree = 1024×16b twiddle ROM. Both map to sky130 SRAM macros in OpenLane flow. Butterfly+control+bridge logic-only ≈ 10K GE (confirmed by standalone fft_engine synthesis: 4,098 cells / 36,724 μm²). |
| **Total (synthesized modules)** | **147,827** | **2,573,730** | **~686,327** | |

> **Note:** All gate counts are post-synthesis (Yosys 0.33), pre-placement, sky130 HD TT 25°C 1.8V, 2026-03-15. NAND2 reference: sky130_fd_sc_hd__nand2_1 = 3.75 μm². Complete synthesis run covers all four SoC bus-attached modules (no submodule proxies). ibex_top includes ibex_core + register_file_ff + cs_registers; significantly below published 50K GE because that figure is for the hardened config (ICache + SecureIbex enabled); our config uses SecureIbex=0, ICache=0, WritebackStage=0. uart includes uart_core + uart_reg_top (full TL-UL register bus). fft_ctrl_tlul Yosys area is inflated by 65,893 enable-FFs (sample data RAM, double-buffered 1024×32b) and combinational twiddle ROM mux tree; both map to sky130 SRAM macros in OpenLane and are excluded from logic GE. Logic-only FFT estimate (~10K GE) derived from standalone fft_engine synthesis. SRAM macros (RAM 128KB, ROM 32KB, twiddle ROM 2KB, FFT sample RAM ~8KB) not counted in logic GE. Full definitive die area pending OpenLane hardening.


## 9. Timing

Setup margin: **0.5 ns** &nbsp; Hold margin: **0.1 ns** (added via `set_clock_uncertainty -add` in SDC)

| Corner | PVT | Temperature | Voltage | Liberty | Check |
|---|---|---|---|---|---|
| **TT** | tt | 25 °C | 1.8 V | `sky130_fd_sc_hd__tt_025C_1v80.lib` | both |
| **SS** | ss | 100 °C | 1.6 V | `sky130_fd_sc_hd__ss_100C_1v60.lib` | setup |
| **FF** | ff | -40 °C | 1.95 V | `sky130_fd_sc_hd__ff_n40C_1v95.lib` | hold |

Constraint files: `constraints/edge_sensor.sdc` (generic), `constraints/run_opensta.tcl` (OpenSTA batch run).

**I/O timing:**

| Port | Direction | Clock | Max | Min | Description |
|---|---|---|---|---|---|
| `uart_rx_i` | Input | `clk_sys` | 2.0 ns | 0.5 ns | UART RX from FT232H (on-board, <5 cm trace) |
| `uart_tx_o` | Output | `clk_sys` | 2.0 ns | 0.5 ns | UART TX to FT232H |

## 10. I/O Description

| Signal | Direction | Width | Description |
|---|---|---|---|
| `clk_i` | Input | 1 | Primary system clock |
| `rst_ni` | Input | 1 | Active-low asynchronous reset |
| `scan_en_i` | Input | 1 | DFT scan enable — tie 0 in functional mode |
| `scan_mode_i` | Input | 1 | DFT scan mode select — tie 0 in functional mode |
| `u_uart_rx_i` | Input | 1 | UART receive |
| `u_uart_tx_o` | Output | 1 | UART transmit |
| `u_uart_tx_en_o` | Output | 1 | UART TX enable (RS-485) |

## 11. IP Attribution & Open Source Licenses

All IP blocks are sourced from the **Vyges IP Catalog** ([github.com/vyges-ip](https://github.com/vyges-ip)). Each catalog entry carries a `vyges-metadata.json` that declares interfaces, clock domains, and verification status — enabling metadata-driven SoC assembly.

| IP | Vyges Catalog | Version | License |
|---|---|---|---|
| `opentitan-rv-core-ibex` | [`vyges-ip/opentitan-rv-core-ibex`](https://github.com/vyges-ip/opentitan-rv-core-ibex) | 0.1.0 | Apache-2.0 |
| `opentitan-uart` | [`vyges-ip/opentitan-uart`](https://github.com/vyges-ip/opentitan-uart) | 0.1.0 | Apache-2.0 |
| `vyges-spi-host-lite` | [`vyges-ip/vyges-spi-host-lite`](https://github.com/vyges-ip/vyges-spi-host-lite) | 0.1.0 | Apache-2.0 |
| `vyges-rv-plic-lite` | [`vyges-ip/vyges-rv-plic-lite`](https://github.com/vyges-ip/vyges-rv-plic-lite) | 0.1.0 | Apache-2.0 |
| `fast-fourier-transform-ip` | [`vyges-ip/fast-fourier-transform-ip`](https://github.com/vyges-ip/fast-fourier-transform-ip) | 1.0.0 | Apache-2.0 |

## 12. Interrupt Architecture

The SoC uses a **U_Plic** with 14 interrupt sources routed to the CPU (`u_ibex.irq_external_i`).

| ID | Source | Signal | Description |
|---|---|---|---|
| 1 | `u_uart` | `intr_tx_watermark_o` | |
| 2 | `u_uart` | `intr_tx_empty_o` | |
| 3 | `u_uart` | `intr_rx_watermark_o` | |
| 4 | `u_uart` | `intr_tx_done_o` | |
| 5 | `u_uart` | `intr_rx_overflow_o` | |
| 6 | `u_uart` | `intr_rx_frame_err_o` | |
| 7 | `u_uart` | `intr_rx_break_err_o` | |
| 8 | `u_uart` | `intr_rx_timeout_o` | |
| 9 | `u_uart` | `intr_rx_parity_err_o` | |
| 10 | `u_spi_host` | `intr_tx_empty_o` | |
| 11 | `u_spi_host` | `intr_rx_full_o` | |
| 12 | `u_spi_host` | `intr_idle_o` | |
| 13 | `u_fft` | `fft_done_o` | |
| 14 | `u_fft` | `fft_error_o` | |

## 13. Power Domains

| Domain | Always-On | Description |
|---|---|---|
| `main` | No | Switchable main domain — CPU, memory, peripherals |
| `aon` | Yes | Always-on domain — wakeup logic, timers (future) |

## 14. Lifecycle States

| State | ID | Debug | DFT | Description |
|---|---|---|---|---|
| `manufacturing` | 0 | Enabled | Enabled | Factory test and provisioning |
| `development` | 1 | Enabled | Disabled | Firmware development with JTAG |
| `production` | 2 | Disabled | Disabled | Field deployment (debug locked) |
| `rma` | 3 | Enabled | Enabled | Return merchandise authorization |

**State Transitions:**

- `manufacturing` → `development` (requires: jtag_unlock)
- `development` → `production` (requires: otp_fuse)
- `production` → `rma` (requires: rma_token)

## 15. SRAM Implementation

| Memory | Size | Macro | Banks | Area |
|---|---|---|---|---|
| ROM | 32KB | `sky130_sram_2kbyte_1rw1r_32x512_8` | 16 | 4.48 mm² |
| RAM | 128KB | `sky130_sram_2kbyte_1rw1r_32x512_8` | 64 | 17.92 mm² |

## 16. Firmware

Boot firmware application: **sensor_demo**

| Parameter | Value |
|---|---|
| UART Baud Rate | 115200 |
| SPI Clock | 3.125 MHz |
| FFT Length | 1024 points |
| Iterations | 10 |
| Sensor | adxl355 (3-axis) |

Generated firmware files in `build/firmware/`:

- `edge_sensor.h` — register defines, IRQ IDs, power domain macros
- `edge_sensor.ld` — linker script
- `main.c` — application firmware (from template)
- `crt0.S` — C runtime startup
- `Makefile` — cross-compile with `riscv64-unknown-elf-gcc`

## 17. Getting Started

The complete design is available as an open-source repository. All generated RTL, constraints, and documentation are checked in under `build/` and `docs/`.

| Artifact | Location |
|---|---|
| ASIC top wrapper (SystemVerilog) | `build/rtl/top_edge_sensor_asic.sv` |
| Simulation top | `build/rtl/top_edge_sensor_sim.sv` |
| Address map package | `build/pkg/edge_sensor_pkg.sv` |
| SDC constraints (all corners) | `build/constraints/` |
| OpenSTA run script | `build/constraints/run_opensta.tcl` |
| PrimeTime run script | `build/constraints/run_primetime.tcl` |
| IP RTL source | `local-ips/<ip-name>/` |
| Firmware (generated) | `build/firmware/` (main.c, crt0.S, Makefile, .h, .ld) |
| SRAM wrappers | `build/rtl/sram_*_wrapper.sv` |
| Bridge wrappers | `build/rtl/*_ctrl_tlul.sv` |
| sv2v script | `scripts/sv2v_fpga.sh` |
| Clean-room test | `scripts/clean_room_test.sh` |
| Block diagram | `docs/edge_sensor_block_diagram.svg` |
| Architecture doc | `docs/edge_sensor_architecture.md` |

**Simulation:**
```
cd sim && make sim
```

**STA (OpenSTA):**
```
cd build/constraints && opensta run_opensta.tcl
```

---

*© 2026 Vyges. All Rights Reserved. Generated by Vyges SoC Generator.*
