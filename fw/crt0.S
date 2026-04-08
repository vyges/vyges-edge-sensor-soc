// @generated — vyges-soc-generator  DO NOT EDIT
// crt0.S — Minimal C runtime startup for edge_sensor (RV32IMC)

.section .text.start, "ax"
.globl _start
.extern main

_start:
    // Stack at top of RAM
    lui     sp, %hi(0x10020000)

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