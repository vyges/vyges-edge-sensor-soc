# @generated — vyges-soc-generator  DO NOT EDIT
# SoC      : edge_sensor
# Corner   : tt
# Format   : SDC (Synopsys Design Constraints / OpenSTA compatible)

# ── Corner: tt (pvt=tt, T=25°C, V=1.8V) ──

read_liberty sky130_fd_sc_hd__tt_025C_1v80.lib

# Link design
read_verilog ../rtl/top_edge_sensor_asic.v
link_design top_edge_sensor_asic

# ── Clocks ─────────────────────────────────────────────────────────────
create_clock -name clk_sys -period 20.0 [get_ports clk_i]
set_clock_uncertainty -setup 0.15 [get_clocks clk_sys]
set_clock_uncertainty -hold 0.05 [get_clocks clk_sys]

# ── Timing margins ──────────────────────────────────────────────────────
set_clock_uncertainty -setup 0.5 -add [get_clocks clk_sys]
set_clock_uncertainty -hold 0.1 -add [get_clocks clk_sys]

# ── Reset synchronizer false paths ──────────────────────────────────────
set_false_path -to [get_pins u_rst_sync/sync_ff/D]

# ── Path exceptions ─────────────────────────────────────────────────────
set_false_path -from [get_cells u_ibex/u_ibex_core/u_ibex_tracer] -to [get_cells *]  ;# ibex tracer is for simulation only

# ── I/O timing ──────────────────────────────────────────────────────────
# UART RX from FT232H (on-board, <5 cm trace)
set_input_delay -clock [get_clocks clk_sys] -max 2.0 [get_ports uart_rx_i]
set_input_delay -clock [get_clocks clk_sys] -min 0.5 [get_ports uart_rx_i]
# UART TX to FT232H
set_output_delay -clock [get_clocks clk_sys] -max 2.0 [get_ports uart_tx_o]
set_output_delay -clock [get_clocks clk_sys] -min 0.5 [get_ports uart_tx_o]

# ── Timing reports ──────────────────────────────────────────────────────
report_checks -path_delay max -format full_clock_expanded -nworst 20 > reports/edge_sensor_tt_setup.rpt
report_checks -path_delay min -format full_clock_expanded -nworst 20 > reports/edge_sensor_tt_hold.rpt
report_tns > reports/edge_sensor_tt_tns.rpt
