# @generated — vyges-soc-generator  DO NOT EDIT
# Firmware Makefile for edge_sensor
#
# Usage:
#   make             — build boot.hex (Verilog hex format) and boot_rom.hex
#                       (flat word array for $readmemh into a local boot ROM)
#   make boot.bin    — build raw binary (for cf precheck firmware loaders)
#   make disasm      — show disassembly
#   make clean       — remove artifacts
#
# Prerequisites:
#   riscv64-unknown-elf-gcc (apt: gcc-riscv64-unknown-elf)
#   python3                  (for boot_rom.hex word-array conversion)
#
# Targets the boot ROM and data RAM declared in edge_sensor.ld. All
# firmware sources (crt0.S, main.c, header, linker script) live in this
# directory; the Makefile uses local relative paths so it works whether
# the firmware ships at build/firmware/ (default soc-generator output) or
# is flattened into a project-local fw/ directory.
#
# Output files (all written to this directory, with copies into the parent
# directory for the contest-repo convention of boot.hex at the repo root):
#   boot.elf       — linked ELF
#   boot.hex       — Verilog hex (objcopy -O verilog), byte-addressed,
#                    suitable for tools that expect absolute addresses
#   boot_rom.hex   — flat 32-bit word array, one word per line, starting
#                    at index 0; suitable for $readmemh into a local boot
#                    ROM array (e.g. rv_core_ibex_tlul.boot_rom)
#   boot.bin       — raw little-endian binary (built on demand: `make boot.bin`)

CROSS   ?= riscv64-unknown-elf
CC       = $(CROSS)-gcc
OBJCOPY  = $(CROSS)-objcopy
OBJDUMP  = $(CROSS)-objdump

# zicsr is required for csr{r,w,s,c}{i} instructions (mtvec / mstatus setup
# in crt0). GCC 13+ no longer implies zicsr under rv32imc.
ARCH    := rv32imc_zicsr
ABI     := ilp32

CFLAGS  := -march=$(ARCH) -mabi=$(ABI) \
           -nostdlib -nostartfiles -ffreestanding \
           -Wall -O2 \
           -I.

SRCS_S  := crt0.S
SRCS_C  := main.c
LDSCRIPT:= edge_sensor.ld

TARGET  := boot

.PHONY: all clean disasm bin

all: $(TARGET).hex $(TARGET)_rom.hex
	@echo "=== Boot ROM: $(TARGET).hex + $(TARGET)_rom.hex ==="
	cp $(TARGET).hex     ../$(TARGET).hex
	cp $(TARGET)_rom.hex ../$(TARGET)_rom.hex

bin: $(TARGET).bin

$(TARGET).elf: $(SRCS_S) $(SRCS_C) $(LDSCRIPT)
	$(CC) $(CFLAGS) -T $(LDSCRIPT) -o $@ $(SRCS_S) $(SRCS_C)

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O verilog $< $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# boot_rom.hex — flat word-indexed hex for $readmemh into a local boot ROM
# array. objcopy -O verilog produces byte-addressed Verilog hex which $readmemh
# treats as absolute array indices, so a 32 KB ROM image starting at byte
# 0x8000 would be loaded at array index 0x8000 — out of bounds for an
# 8192-word array. The flat-word format starts at index 0 and packs four
# little-endian bytes per line as a single 32-bit word.
$(TARGET)_rom.hex: $(TARGET).bin
	@python3 -c "import sys; \
data = open('$(TARGET).bin','rb').read(); \
data += b'\\x00' * ((4 - len(data) % 4) % 4); \
out = open('$(TARGET)_rom.hex','w'); \
[out.write(f'{int.from_bytes(data[i:i+4],\"little\"):08x}\\n') for i in range(0, len(data), 4)]; \
out.close(); \
print(f'wrote $(TARGET)_rom.hex with {len(data)//4} words ({len(data)} bytes)')"

disasm: $(TARGET).elf
	$(OBJDUMP) -d -M no-aliases $<

clean:
	rm -f $(TARGET).elf $(TARGET).hex $(TARGET)_rom.hex $(TARGET).bin \
	      ../$(TARGET).hex ../$(TARGET)_rom.hex