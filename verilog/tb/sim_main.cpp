// sim_main.cpp — Verilator C++ harness for tb_edge_sensor_smoke.
//
// Drives clock + reset on the SoC, samples uart_tx_o every cycle, decodes
// 8N1 UART at 115200 baud against a 50 MHz core clock, and prints decoded
// characters to stdout in real time. Also samples the Ibex instruction-
// fetch PC every 10k cycles for forward-progress confirmation.
//
// Build:  make -C verilog/tb
// Run:    ./obj_dir/Vtb_edge_sensor_smoke [max_cycles]
//
// Default: 200,000 cycles (= 4 ms sim time = ~46 UART characters at 115200
// baud, enough to see the start of the firmware banner).

#include "Vtb_edge_sensor_smoke.h"
#include "verilated.h"

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// ── Clock + UART parameters (match the firmware's UART_NCO config) ────────
static constexpr int CLK_HZ         = 50'000'000;
static constexpr int UART_BAUD      = 115200;
static constexpr int CYCLES_PER_BIT = (CLK_HZ + UART_BAUD / 2) / UART_BAUD; // 434

static constexpr long DEFAULT_CYCLES = 200'000;

// ── 8N1 UART receiver: samples one TX line bit each cycle ─────────────────
class UartRx {
public:
    void tick(bool tx_high) {
        switch (state_) {
        case Idle:
            // Falling edge = start bit
            if (prev_high_ && !tx_high) {
                state_ = Start;
                // Schedule the mid-bit sample for the start bit
                ticks_to_sample_ = CYCLES_PER_BIT / 2;
            }
            break;

        case Start:
            if (--ticks_to_sample_ == 0) {
                if (tx_high) {
                    // False start, line went high again before we could
                    // confirm — drop back to idle.
                    state_ = Idle;
                } else {
                    state_ = Data;
                    bit_idx_ = 0;
                    shift_  = 0;
                    ticks_to_sample_ = CYCLES_PER_BIT;
                }
            }
            break;

        case Data:
            if (--ticks_to_sample_ == 0) {
                shift_ |= (uint8_t)(tx_high ? 1u : 0u) << bit_idx_;
                bit_idx_++;
                if (bit_idx_ == 8) {
                    state_ = Stop;
                }
                ticks_to_sample_ = CYCLES_PER_BIT;
            }
            break;

        case Stop:
            if (--ticks_to_sample_ == 0) {
                emit(shift_);
                state_ = Idle;
            }
            break;
        }
        prev_high_ = tx_high;
    }

    long char_count() const { return char_count_; }

private:
    enum State { Idle, Start, Data, Stop };

    void emit(uint8_t c) {
        std::fputc((int)c, stdout);
        std::fflush(stdout);
        char_count_++;
    }

    State    state_           = Idle;
    int      ticks_to_sample_ = 0;
    int      bit_idx_         = 0;
    uint8_t  shift_           = 0;
    bool     prev_high_       = true;
    long     char_count_      = 0;
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    long max_cycles = DEFAULT_CYCLES;
    if (argc >= 2) {
        max_cycles = std::strtol(argv[1], nullptr, 0);
        if (max_cycles <= 0) max_cycles = DEFAULT_CYCLES;
    }

    auto* tb = new Vtb_edge_sensor_smoke;
    UartRx uart;

    // ── Reset for 20 cycles ───────────────────────────────────────────────
    tb->rst_ni = 0;
    tb->clk_i  = 0;
    for (int i = 0; i < 40; i++) {
        tb->clk_i = (i & 1);
        tb->eval();
    }
    tb->rst_ni = 1;

    std::fprintf(stderr,
                 "[tb] reset released — running %ld cycles (CLK=%d Hz, UART=%d "
                 "baud, %d cycles/bit)\n",
                 max_cycles, CLK_HZ, UART_BAUD, CYCLES_PER_BIT);

    long cycles = 0;
    while (cycles < max_cycles && !Verilated::gotFinish()) {
        // Rising edge
        tb->clk_i = 1;
        tb->eval();
        // Sample uart_tx_o on the rising edge
        uart.tick((tb->uart_tx_o & 1) != 0);
        // Falling edge
        tb->clk_i = 0;
        tb->eval();

        cycles++;
        if (cycles % 50'000 == 0) {
            std::fprintf(stderr, "[tb] %ld cycles, PC=0x%08x, uart_tx=%d, "
                         "uart_chars=%ld\n",
                         cycles, (unsigned)tb->dbg_pc_o,
                         (int)(tb->uart_tx_o & 1), uart.char_count());
        }
    }

    std::fprintf(stderr,
                 "\n[tb] sim complete: %ld cycles, final PC=0x%08x, uart "
                 "characters received: %ld\n",
                 cycles, (unsigned)tb->dbg_pc_o, uart.char_count());

    int rc = (uart.char_count() > 0) ? 0 : 1;
    delete tb;
    return rc;
}
