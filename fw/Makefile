# @generated — vyges-soc-generator  DO NOT EDIT
# Firmware Makefile for edge_sensor
#
# Usage:
#   make             — build boot.hex
#   make disasm      — show disassembly
#   make clean       — remove artifacts
#
# Prerequisites:
#   riscv64-unknown-elf-gcc (apt: gcc-riscv64-unknown-elf)

CROSS   ?= riscv64-unknown-elf
CC       = $(CROSS)-gcc
OBJCOPY  = $(CROSS)-objcopy
OBJDUMP  = $(CROSS)-objdump

ARCH    := rv32imc
ABI     := ilp32

CFLAGS  := -march=$(ARCH) -mabi=$(ABI) \
           -nostdlib -nostartfiles -ffreestanding \
           -Wall -O2 \
           -I../../build/firmware

SRCS_S  := crt0.S
SRCS_C  := main.c
LDSCRIPT:= ../../build/firmware/edge_sensor.ld

TARGET  := boot

.PHONY: all clean disasm

all: $(TARGET).hex
	@echo "=== Boot ROM: $(TARGET).hex ==="
	cp $(TARGET).hex ../../boot.hex

$(TARGET).elf: $(SRCS_S) $(SRCS_C) $(LDSCRIPT)
	$(CC) $(CFLAGS) -T $(LDSCRIPT) -o $@ $(SRCS_S) $(SRCS_C)

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O verilog $< $@

disasm: $(TARGET).elf
	$(OBJDUMP) -d -M no-aliases $<

clean:
	rm -f $(TARGET).elf $(TARGET).hex ../../boot.hex