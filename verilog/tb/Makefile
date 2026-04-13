# Makefile — Verilator smoke test for the edge_sensor SoC firmware
#
# Builds tb_edge_sensor_smoke (a thin SV wrapper around edge_sensor_soc_top
# that hierarchically loads boot.hex into the Ibex local boot ROM) plus the
# C++ harness sim_main.cpp (UART decoder + cycle driver), then runs ~200k
# cycles and prints decoded UART output to stdout.
#
# Usage:
#   make           — build + run
#   make build     — build only
#   make clean     — wipe obj_dir
#   make CYCLES=N  — run for N cycles instead of the default

VERILATOR ?= verilator
RTL_DIR    = ../rtl
TB_DIR     = .
TOP        = tb_edge_sensor_smoke

CYCLES   ?= 200000

VFLAGS  = --cc --exe --build \
          --top-module $(TOP) \
          -O3 -CFLAGS "-O2" \
          -j 4 \
          -Wno-WIDTH -Wno-UNOPTFLAT -Wno-UNUSED \
          -Wno-LATCH -Wno-CASEINCOMPLETE -Wno-INITIALDLY \
          -Wno-CMPCONST -Wno-MULTIDRIVEN -Wno-COMBDLY \
          -Wno-SELRANGE -Wno-WIDTHCONCAT \
          -Wno-TIMESCALEMOD -Wno-ASCRANGE -Wno-PINMISSING \
          -Wno-IMPLICIT -Wno-STMTDLY -Wno-BLKANDNBLK \
          -Wno-UNSIGNED -Wno-CASEOVERLAP -Wno-PROCASSWIRE \
          -Wno-VARHIDDEN -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND

BIN = obj_dir/V$(TOP)

.PHONY: all build run clean

all: run

build: $(BIN)

$(BIN): $(TB_DIR)/$(TOP).sv $(RTL_DIR)/soc_conv.v sim_main.cpp CF_SRAM_1024x32.v
	$(VERILATOR) $(VFLAGS) \
	    $(RTL_DIR)/soc_conv.v \
	    CF_SRAM_1024x32.v \
	    $(TB_DIR)/$(TOP).sv \
	    sim_main.cpp

run: $(BIN)
	@echo "=== Running smoke test ($(CYCLES) cycles) ==="
	./$(BIN) $(CYCLES)

clean:
	rm -rf obj_dir
