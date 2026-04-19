// @generated — vyges-soc-generator  DO NOT EDIT
// crt0.S — Minimal C runtime startup for edge_sensor (RV32IMC)
//
// Responsibilities:
//   1. Initialize stack pointer.
//   2. Install mtvec (direct mode) pointing at _trap_handler. Without this,
//      any trap — illegal instruction, misaligned load/store, ecall, EBREAK,
//      debug entry — jumps to the Ibex default mtvec reset value and hangs
//      invisibly. With this, _trap_handler spins at a known address so a
//      debugger (via the RV debug module) can inspect mcause/mepc.
//   3. Copy .data (initialized globals) from ROM LMA to RAM VMA.
//   4. Zero .bss.
//   5. Call main; halt in WFI if it returns.

.section .text.start, "ax"
.globl _start
.extern main

_start:
    // Stack at top of RAM
    lui     sp, %hi(0x10020000)

    // mtvec: direct mode (mode=0 in [1:0]), base = _trap_handler. The
    // handler is 4-byte aligned by the section default, so the low bits
    // are already zero and csrw writes a valid direct-mode vector.
    la      t0, _trap_handler
    csrw    mtvec, t0

    // Copy .data from ROM LMA to RAM VMA. Linker exposes _data_lma
    // (LOADADDR of .data), _data_start, _data_end (VMA bounds).
    la      t0, _data_lma
    la      t1, _data_start
    la      t2, _data_end
data_copy:
    bge     t1, t2, data_done
    lw      t3, 0(t0)
    sw      t3, 0(t1)
    addi    t0, t0, 4
    addi    t1, t1, 4
    j       data_copy
data_done:

    // Zero .bss
    la      t0, _bss_start
    la      t1, _bss_end
bss_clear:
    bge     t0, t1, bss_done
    sw      zero, 0(t0)
    addi    t0, t0, 4
    j       bss_clear
bss_done:

    // Call main
    jal     ra, main

    // Halt on return
halt:
    wfi
    j       halt

// ── Trap handler ──────────────────────────────────────────────────────────
// Spin so a debugger can break in and inspect mcause / mepc / mtval. No CSR
// reads here (debugger will halt us via the DM). If no debugger is attached,
// the CPU loops forever at _trap_handler rather than wandering into
// unmapped memory — predictable failure mode.
.section .text, "ax"
.balign 4
.globl _trap_handler
_trap_handler:
    j       _trap_handler