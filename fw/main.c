// @generated — vyges-soc-generator  DO NOT EDIT
// main.c — edge_sensor boot firmware (sensor_demo)
//
// Generated from soc-spec.yaml firmware section.
// Regenerate with: soc-generator generate soc-spec.yaml

#include "edge_sensor.h"

#define REG32(addr) (*(volatile unsigned int *)(addr))

// ── UART driver ─────────────────────────────────────────────────────────────

// NCO derived from CLK_FREQ_HZ at compile time so the same firmware boots
// correctly on silicon (typically 40 MHz) and on FPGA (typically 50 MHz on
// Arty A7) without per-target rebuilds. Formula: NCO = baud * 2^20 / clk_hz.
#define UART_BAUD       115200U
#define UART_NCO        ((unsigned int)(((unsigned long long)UART_BAUD * 1048576ULL + (CLK_FREQ_HZ / 2)) / CLK_FREQ_HZ))

static void uart_init(void) {
    REG32(U_UART_CTRL) = (UART_NCO << 16) | 0x3;  // NCO + TX_EN + RX_EN
}

static void uart_putc(char c) {
    while (REG32(U_UART_STATUS) & 0x1) ;  // wait TX not full
    REG32(U_UART_WDATA) = (unsigned char)c;
}

static void uart_puts(const char *s) {
    while (*s) uart_putc(*s++);
}

static void uart_put_hex32(unsigned int val) {
    static const char hex[] = "0123456789ABCDEF";
    uart_puts("0x");
    for (int i = 28; i >= 0; i -= 4)
        uart_putc(hex[(val >> i) & 0xF]);
}

static void uart_put_dec(unsigned int val) {
    char buf[12];
    int i = 0;
    if (val == 0) { uart_putc('0'); return; }
    while (val > 0) { buf[i++] = '0' + (val % 10); val /= 10; }
    while (--i >= 0) uart_putc(buf[i]);
}

// ── UART RX + command interpreter ───────────────────────────────────────────
// Post-silicon recovery channel. Since this SoC ships without rv_dm (no JTAG
// TAP), this is the ONLY way to inspect or override silicon behaviour at
// runtime if the Prometheus telemetry reveals something unexpected. The
// command interpreter is triggered by a magic byte sequence on UART RX; it
// pauses the metric stream, accepts R/W/J/X commands from the host, then
// resumes. Costs ~300 bytes of ROM; enabled unconditionally because the
// downside risk of a silicon respin without a recovery channel dominates.

#define UART_STATUS_RXEMPTY_BIT  5

static int uart_has_rx(void) {
    return !(REG32(U_UART_STATUS) & (1U << UART_STATUS_RXEMPTY_BIT));
}

static int uart_getc_nonblock(void) {
    if (!uart_has_rx()) return -1;
    return (int)(REG32(U_UART_RDATA) & 0xFF);
}

static unsigned char uart_getc_blocking(void) {
    while (!uart_has_rx()) { /* spin */ }
    return (unsigned char)(REG32(U_UART_RDATA) & 0xFF);
}

static unsigned int parse_hex_word(const char **pp) {
    unsigned int v = 0;
    const char *p = *pp;
    while (*p == ' ') p++;
    while (*p) {
        char c = *p;
        unsigned int d;
        if      (c >= '0' && c <= '9') d = (unsigned int)(c - '0');
        else if (c >= 'a' && c <= 'f') d = (unsigned int)(c - 'a' + 10);
        else if (c >= 'A' && c <= 'F') d = (unsigned int)(c - 'A' + 10);
        else break;
        v = (v << 4) | d;
        p++;
    }
    *pp = p;
    return v;
}

static void read_line(char *buf, int max) {
    int i = 0;
    while (i < max - 1) {
        unsigned char c = uart_getc_blocking();
        uart_putc((char)c);  // echo
        if (c == '\r' || c == '\n') break;
        if (c == 0x08 || c == 0x7f) {  // backspace / del
            if (i > 0) i--;
            continue;
        }
        buf[i++] = (char)c;
    }
    buf[i] = 0;
    uart_puts("\r\n");
}

// ── Auto-enumeration: on-chip bus slaves + SPI devices ─────────────────────
// These commands let a human on the host side validate "is every block
// present and reachable from the CPU?" within ~10 seconds of silicon
// arrival, without needing an address map printout. For a chip that ships
// without JTAG, this is the difference between "boots and streams =
// everything works?" and "boots and streams = everything I actually
// exercised works; the rest is unknown".
//
// Note: the actual enum_spi_devices() implementation is defined further
// below, AFTER the SPI/ADXL355 drivers it depends on. Forward-declared
// here so debug_cmd_loop() can reference it.
static void enum_bus_slaves(void);
static void enum_spi_devices(void);

static void debug_cmd_loop(void) {
    char line[72];
    uart_puts("\r\n# vyges-debug: enter ('?' for help, 'X' to exit)\r\n");
    while (1) {
        uart_puts("# vyges> ");
        read_line(line, sizeof(line));
        const char *p = line;
        while (*p == ' ') p++;
        char cmd = *p;
        if (cmd) p++;
        switch (cmd) {
            case 'R': case 'r': {
                unsigned int addr = parse_hex_word(&p);
                unsigned int val  = REG32(addr);
                uart_puts("# vyges: ");
                uart_put_hex32(val);
                uart_puts("\r\n");
                break;
            }
            case 'W': case 'w': {
                unsigned int addr = parse_hex_word(&p);
                unsigned int val  = parse_hex_word(&p);
                REG32(addr) = val;
                uart_puts("# vyges: OK\r\n");
                break;
            }
            case 'J': case 'j': {
                unsigned int addr = parse_hex_word(&p);
                uart_puts("# vyges: jumping to ");
                uart_put_hex32(addr);
                uart_puts("\r\n");
                ((void (*)(void))(unsigned long)addr)();
                break;
            }
            case 'E': case 'e':
                enum_bus_slaves();
                break;
            case 'S': case 's':
                enum_spi_devices();
                break;
            case 'X': case 'x':
                uart_puts("# vyges: exit\r\n");
                return;
            case '?':
                uart_puts("# vyges: R <hex-addr>           read 32-bit\r\n");
                uart_puts("# vyges: W <hex-addr> <hex-val> write 32-bit\r\n");
                uart_puts("# vyges: J <hex-addr>           jump to addr\r\n");
                uart_puts("# vyges: E                      enumerate bus slaves\r\n");
                uart_puts("# vyges: S                      enumerate SPI devices\r\n");
                uart_puts("# vyges: X                      resume stream\r\n");
                break;
            default:
                if (cmd) uart_puts("# vyges: ? for help\r\n");
                break;
        }
    }
}

// Scan RX FIFO for the magic sequence 'V' 'Y' 'D' 'B'. Non-blocking; meant
// to be called between telemetry windows. On match, enters debug_cmd_loop()
// which blocks until 'X' is received.
static void check_debug_magic(void) {
    static const unsigned char magic[] = { 'V', 'Y', 'D', 'B' };
    static unsigned int seq_idx = 0;
    int c;
    while ((c = uart_getc_nonblock()) >= 0) {
        unsigned char b = (unsigned char)c;
        if (b == magic[seq_idx]) {
            seq_idx++;
            if (seq_idx == sizeof(magic)) {
                seq_idx = 0;
                debug_cmd_loop();
                return;
            }
        } else {
            seq_idx = (b == magic[0]) ? 1u : 0u;
        }
    }
}

// ── SPI Host driver ─────────────────────────────────────────────────────────

// SPI clock divider: SCLK = 40 MHz / (2*(5+1)) = 3.125 MHz
#define SPI_CLK_DIV 5U

static void spi_init(void) {
    REG32(U_SPI_HOST_DIV) = SPI_CLK_DIV;
    REG32(U_SPI_HOST_CTRL) = 0x01;  // enable, CPOL=0, CPHA=0, 8-bit
}

static void spi_cs_assert(void)   { REG32(U_SPI_HOST_CSCTRL) = 1; }
static void spi_cs_deassert(void) { REG32(U_SPI_HOST_CSCTRL) = 0; }

static unsigned char spi_xfer8(unsigned char tx) {
    REG32(U_SPI_HOST_TXDATA) = tx;
    while (REG32(U_SPI_HOST_STATUS) & 0x01) ;  // wait not busy
    return (unsigned char)REG32(U_SPI_HOST_RXDATA);
}

// ── ADXL355 accelerometer ───────────────────────────────────────────────────

#define ADXL355_DEVID_AD    0x00
#define ADXL355_TEMP2       0x06
#define ADXL355_TEMP1       0x07
#define ADXL355_XDATA3      0x08
#define ADXL355_YDATA3      0x0B
#define ADXL355_ZDATA3      0x0E
#define ADXL355_POWER_CTL   0x2D

static unsigned char adxl355_read_reg(unsigned char addr) {
    spi_cs_assert();
    spi_xfer8((addr << 1) | 0x01);
    unsigned char val = spi_xfer8(0x00);
    spi_cs_deassert();
    return val;
}

static void adxl355_write_reg(unsigned char addr, unsigned char val) {
    spi_cs_assert();
    spi_xfer8((addr << 1) | 0x00);
    spi_xfer8(val);
    spi_cs_deassert();
}

static int decode20(unsigned char b0, unsigned char b1, unsigned char b2) {
    int raw = ((int)b0 << 12) | ((int)b1 << 4) | (b2 >> 4);
    if (raw & 0x80000) raw |= 0xFFF00000;  // sign extend 20-bit
    return raw;
}

// Single-shot burst read of X/Y/Z. CS held across all 9 bytes so the
// sensor returns a coherent triplet (per-byte CS cycles would let the
// sample update mid-read).
static void adxl355_read_xyz(int *x, int *y, int *z) {
    spi_cs_assert();
    spi_xfer8((ADXL355_XDATA3 << 1) | 0x01);
    unsigned char buf[9];
    for (int j = 0; j < 9; j++) buf[j] = spi_xfer8(0x00);
    spi_cs_deassert();
    *x = decode20(buf[0], buf[1], buf[2]);
    *y = decode20(buf[3], buf[4], buf[5]);
    *z = decode20(buf[6], buf[7], buf[8]);
}

// 12-bit temperature: TEMP2 high nibble + TEMP1 byte. Datasheet conversion
// is C = (1885 - raw)/9.05 + 25 — done client-side, silicon emits raw.
static unsigned int adxl355_read_temp_raw(void) {
    unsigned char hi = adxl355_read_reg(ADXL355_TEMP2);
    unsigned char lo = adxl355_read_reg(ADXL355_TEMP1);
    return ((unsigned int)(hi & 0x0F) << 8) | lo;
}

// SPI device enumeration — walk the probes that apply to this SoC's wiring.
// Called via 'S' in the debug command loop.
static void enum_spi_devices(void) {
    // ADXL355 — standard DEVID_AD register read (0x00). Returns 0xAD if
    // the accelerometer is present + talking.
    unsigned char devid = adxl355_read_reg(ADXL355_DEVID_AD);
    // uart_put_hex32() already emits the 0x prefix; don't double-print.
    uart_puts("# vyges: spi cs0 devid=");
    uart_put_hex32(devid);
    uart_puts(devid == 0xAD ? " [ADXL355 OK]\r\n" : " [unknown/absent]\r\n");

    // Generic SPI flash JEDEC ID probe (command 0x9F, 3-byte response).
    // edge_sensor does not ship a flash today, but the probe is cheap and
    // useful if a future PCBA adds one on the same SPI host.
    spi_cs_assert();
    spi_xfer8(0x9F);
    unsigned char mfr  = spi_xfer8(0);
    unsigned char typ  = spi_xfer8(0);
    unsigned char cap  = spi_xfer8(0);
    spi_cs_deassert();
    // uart_put_hex32() already emits the 0x prefix; don't double-print.
    uart_puts("# vyges: spi jedec mfr="); uart_put_hex32(mfr);
    uart_puts(" type="); uart_put_hex32(typ);
    uart_puts(" cap=");  uart_put_hex32(cap);
    unsigned int ok = (mfr != 0x00 && mfr != 0xFF);
    uart_puts(ok ? " [present]\r\n" : " [absent]\r\n");
}

// On-chip bus slave enumeration — reads each peripheral's ctrl + status
// registers. A dead peripheral typically returns all-zero or all-one (the
// tlul stub's canned response for unmatched addresses), giving a clear
// "alive vs missing" signal per block. Called via 'E' in the debug cmd loop.
//
// Enumerates TL-UL main-crossbar slaves ONLY. Peripherals behind a TL-UL→APB
// bridge (e.g. fft_ctrl) are NOT read here: a stuck APB slave can hang the
// bridge's TL-UL response and take the CPU down with it, which would
// disable the only debug channel on silicon without rv_dm. APB slaves
// report their own liveness via the Prometheus telemetry stream (e.g.
// window_index increments whenever the FFT completes a window).
static void enum_bus_slaves(void) {
    struct ip_entry { const char *name; unsigned int base; };
    static const struct ip_entry ips[] = {
        {"uart",     U_UART_BASE},
        {"spi_host", U_SPI_HOST_BASE},
        {"plic",     U_PLIC_BASE},
    };
    const unsigned n = sizeof(ips) / sizeof(ips[0]);
    for (unsigned i = 0; i < n; i++) {
        unsigned int base   = ips[i].base;
        unsigned int ctrl   = REG32(base + 0x10);
        unsigned int status = REG32(base + 0x14);
        // uart_put_hex32() already emits the 0x prefix; don't double-print.
        uart_puts("# vyges: ");
        uart_puts(ips[i].name);
        uart_puts(" @");
        uart_put_hex32(base);
        uart_puts(" ctrl=");
        uart_put_hex32(ctrl);
        uart_puts(" status=");
        uart_put_hex32(status);
        uart_puts("\r\n");
    }
    uart_puts("# vyges: ");
    uart_put_dec(n);
    uart_puts(" slave(s) enumerated\r\n");
}

// ── Vibration analysis (CPU-side, fixed-point) ─────────────────────────────
// Collects N coherent X/Y/Z triplets in a tight SPI poll then per-axis:
//   peak_to_peak : max - min (raw 20-bit counts)
//   mean_abs_dev : sum(|s - mean|) / N  (proxy for RMS vibration)
//   zero_cross   : sign changes of (s - mean)  (fundamental-frequency proxy)
//   sample_rate  : measured via mcycle CSR (validates SPI host throughput)
//
// 1 LSB at +/-2g full scale = 4/2^20 = 3.815 uG. Values are kept as
// integers because the core has no F extension; the receiver scales raw
// counts to physical units.

#define VIB_N 256
static int sample_x[VIB_N];
static int sample_y[VIB_N];
static int sample_z[VIB_N];

typedef struct {
    int p2p;
    unsigned int mad;
    unsigned int fest_hz;
} axis_stats_t;

static axis_stats_t compute_axis_stats(const int *buf, unsigned int rate_hz) {
    int smin = buf[0], smax = buf[0];
    long sum = 0;
    for (int i = 0; i < VIB_N; i++) {
        int s = buf[i];
        sum += s;
        if (s < smin) smin = s;
        if (s > smax) smax = s;
    }
    int mean = (int)(sum / VIB_N);
    long mad_sum = 0;
    int zc = 0;
    int prev_d = buf[0] - mean;
    for (int i = 1; i < VIB_N; i++) {
        int d = buf[i] - mean;
        mad_sum += (d < 0) ? -d : d;
        if ((prev_d ^ d) < 0) zc++;
        prev_d = d;
    }
    axis_stats_t r;
    r.p2p     = smax - smin;
    r.mad     = (unsigned int)(mad_sum / VIB_N);
    r.fest_hz = ((unsigned int)zc * rate_hz) / (2U * VIB_N);
    return r;
}

static unsigned int read_mcycle(void) {
    unsigned int v;
    __asm__ volatile("csrr %0, mcycle" : "=r"(v));
    return v;
}

// ── Prometheus exposition helpers ───────────────────────────────────────────
// Emit one Prometheus-format metric line. The static labels vendor + chip
// identify Vyges silicon in federated/multi-source Prometheus deployments.

#define CHIP_LABELS "vendor=\"vyges\",chip=\"edge_sensor\""

static void prom_axis(const char *metric, const char *axis, unsigned int val) {
    uart_puts(metric);
    uart_puts("{axis=\""); uart_puts(axis);
    uart_puts("\","); uart_puts(CHIP_LABELS); uart_puts("} ");
    uart_put_dec(val);
    uart_puts("\r\n");
}

static void prom_scalar(const char *metric, unsigned int val) {
    uart_puts(metric);
    uart_puts("{"); uart_puts(CHIP_LABELS); uart_puts("} ");
    uart_put_dec(val);
    uart_puts("\r\n");
}

static void emit_metric_descriptors(void) {
    uart_puts("# HELP vyges_edge_sensor_sensor_ok 1 if ADXL355 DEVID matched this window; 0 if sensor missing/broken\r\n");
    uart_puts("# TYPE vyges_edge_sensor_sensor_ok gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_vibration_p2p_counts Peak-to-peak ADC counts per axis (20-bit, +/-2g)\r\n");
    uart_puts("# TYPE vyges_edge_sensor_vibration_p2p_counts gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_vibration_mad_counts Mean absolute deviation from mean per axis\r\n");
    uart_puts("# TYPE vyges_edge_sensor_vibration_mad_counts gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_freq_estimate_hz Zero-crossing fundamental frequency estimate per axis\r\n");
    uart_puts("# TYPE vyges_edge_sensor_freq_estimate_hz gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_temperature_raw On-chip ADXL355 12-bit temperature ADC code (apply client-side scaling)\r\n");
    uart_puts("# TYPE vyges_edge_sensor_temperature_raw gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_sample_rate_hz Measured SPI sample rate this window (0 when sensor missing)\r\n");
    uart_puts("# TYPE vyges_edge_sensor_sample_rate_hz gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_mcycle Ibex mcycle CSR snapshot at end of window\r\n");
    uart_puts("# TYPE vyges_edge_sensor_mcycle counter\r\n");
    uart_puts("# HELP vyges_edge_sensor_window_index Monotonically increasing window counter since boot\r\n");
    uart_puts("# TYPE vyges_edge_sensor_window_index counter\r\n");
}

// ── PLIC driver ─────────────────────────────────────────────────────────────

static void plic_init(void) {
    unsigned int enable_mask = 0;
    enable_mask |= (1 << IRQ_UART_TX_WATERMARK);
    enable_mask |= (1 << IRQ_UART_TX_EMPTY);
    enable_mask |= (1 << IRQ_UART_RX_WATERMARK);
    enable_mask |= (1 << IRQ_UART_TX_DONE);
    enable_mask |= (1 << IRQ_UART_RX_OVERFLOW);
    REG32(U_PLIC_ENABLE) = enable_mask;
    for (int i = 1; i <= 14; i++)
        REG32(U_PLIC_PRIO_BASE + i * 4) = 1;
    REG32(U_PLIC_THRESHOLD) = 0;
}

static unsigned int plic_claim(void)            { return REG32(U_PLIC_CLAIM_COMPLETE); }
static void plic_complete(unsigned int id)      { REG32(U_PLIC_CLAIM_COMPLETE) = id; }

// ── FFT driver ──────────────────────────────────────────────────────────────

static void fft_start(unsigned int length) {
    REG32(U_FFT_FFT_LENGTH) = length;
    REG32(U_FFT_FFT_CTRL) = 0x01;
}

static int fft_is_done(void) {
    return (REG32(U_FFT_FFT_STATUS) & 0x02) != 0;
}

// ── Main ────────────────────────────────────────────────────────────────────

void main(void) {
    uart_init();
    spi_init();
    plic_init();

    // Banner
    uart_puts("\r\n");
    uart_puts(" __     __\r\n");
    uart_puts(" \\ \\   / /   _  __ _  ___  ___\r\n");
    uart_puts("  \\ \\ / / | | |/ _` |/ _ \\/ __|\r\n");
    uart_puts("   \\ V /| |_| | (_| |  __/\\__ \\\r\n");
    uart_puts("    \\_/  \\__, |\\__, |\\___||___/\r\n");
    uart_puts("         |___/ |___/\r\n");
    uart_puts("\r\n");
    uart_puts("  Edge Sensor SoC v1.0\r\n");
    uart_puts("  Powered by Vyges SoC Generator\r\n");
    uart_puts("  (C) 2026 Vyges. All Rights Reserved.\r\n");
    uart_puts("  vyges.com\r\n");
    uart_puts("\r\n");
    uart_puts("CPU: Ibex RV32IMC @ ");
    uart_put_dec(CLK_FREQ_HZ / 1000000);
    uart_puts(" MHz\r\n");
    uart_puts("UART: ");
    uart_put_dec(115200);
    uart_puts(" baud\r\n");
    uart_puts("SPI @ ");
    uart_put_dec(3125);
    uart_puts(" kHz\r\n");

    // Detect ADXL355
    unsigned char devid = adxl355_read_reg(ADXL355_DEVID_AD);
    uart_puts("ADXL355 ID: ");
    uart_put_hex32(devid);
    uart_puts(devid == 0xAD ? " OK\r\n" : " NOT FOUND\r\n");
    if (devid == 0xAD)
        adxl355_write_reg(ADXL355_POWER_CTL, 0x00);  // measurement mode

    // ── Prometheus stream begins ────────────────────────────────────────────
    // Emit metric descriptors ONCE; per-window output is values only. The
    // host-side receiver streams each window to Prometheus via Pushgateway
    // (see scripts/prom_relay.py); wall-clock timestamps are appended on
    // receipt.
    uart_puts("\r\n# === vyges metric stream begin ===\r\n");
    emit_metric_descriptors();

    // Spin-wait delay (~1 s). Used between heartbeats when the sensor is
    // missing so we don't flood UART at 10+ Hz. The loop body reads mcycle
    // rather than relying on a busy count, so the delay stays ~1 s on
    // both silicon (40 MHz) and FPGA (50 MHz) targets.
    //
    // volatile keeps the compiler from hoisting read_mcycle() out.
    #define HEARTBEAT_SPIN_SECONDS 1U

    unsigned int window = 0;
    unsigned char sensor_present = (devid == 0xAD) ? 1 : 0;
    while (1) {
        // Re-probe DEVID at the top of every window. Costs one SPI xfer
        // but gives us hot-plug recovery: if the sensor comes back after
        // a power glitch or retrofit, we resume normal sampling on the
        // next window without a reboot.
        unsigned char d_now = adxl355_read_reg(ADXL355_DEVID_AD);
        unsigned char ok_now = (d_now == 0xAD) ? 1 : 0;
        if (ok_now && !sensor_present) {
            // Sensor just appeared — re-arm measurement mode
            adxl355_write_reg(ADXL355_POWER_CTL, 0x00);
        }
        sensor_present = ok_now;

        unsigned int t0 = read_mcycle();
        unsigned int rate_hz = 0;
        unsigned int temp_raw = 0;
        axis_stats_t sx = { 0, 0, 0 };
        axis_stats_t sy = { 0, 0, 0 };
        axis_stats_t sz = { 0, 0, 0 };

        if (sensor_present) {
            for (int i = 0; i < VIB_N; i++)
                adxl355_read_xyz(&sample_x[i], &sample_y[i], &sample_z[i]);
            unsigned int t1 = read_mcycle();
            unsigned int cycles_per_sample = (t1 - t0) / VIB_N;
            rate_hz = cycles_per_sample ? (CLK_FREQ_HZ / cycles_per_sample) : 0;
            temp_raw = adxl355_read_temp_raw();
            sx = compute_axis_stats(sample_x, rate_hz);
            sy = compute_axis_stats(sample_y, rate_hz);
            sz = compute_axis_stats(sample_z, rate_hz);
        }
        unsigned int t_now = read_mcycle();

        uart_puts("# === window "); uart_put_dec(window); uart_puts(" ===\r\n");
        prom_scalar("vyges_edge_sensor_sensor_ok", sensor_present);
        if (sensor_present) {
            prom_axis("vyges_edge_sensor_vibration_p2p_counts", "x", (unsigned int)sx.p2p);
            prom_axis("vyges_edge_sensor_vibration_p2p_counts", "y", (unsigned int)sy.p2p);
            prom_axis("vyges_edge_sensor_vibration_p2p_counts", "z", (unsigned int)sz.p2p);
            prom_axis("vyges_edge_sensor_vibration_mad_counts", "x", sx.mad);
            prom_axis("vyges_edge_sensor_vibration_mad_counts", "y", sy.mad);
            prom_axis("vyges_edge_sensor_vibration_mad_counts", "z", sz.mad);
            prom_axis("vyges_edge_sensor_freq_estimate_hz", "x", sx.fest_hz);
            prom_axis("vyges_edge_sensor_freq_estimate_hz", "y", sy.fest_hz);
            prom_axis("vyges_edge_sensor_freq_estimate_hz", "z", sz.fest_hz);
            prom_scalar("vyges_edge_sensor_temperature_raw", temp_raw);
        }
        // Always emitted — these are the heartbeat signals a monitoring
        // backend can use to prove the chip is alive even when the sensor
        // is dead. sample_rate_hz is 0 in the sensor-missing case.
        prom_scalar("vyges_edge_sensor_sample_rate_hz", rate_hz);
        prom_scalar("vyges_edge_sensor_mcycle", t_now);
        prom_scalar("vyges_edge_sensor_window_index", window);
        uart_puts("# END_WINDOW "); uart_put_dec(window); uart_puts("\r\n");

        // Post-silicon recovery channel — check for the 'VYDB' magic
        // sequence on UART RX between windows. Side-steps needing a JTAG
        // debug port on this SoC. See debug_cmd_loop() above.
        check_debug_magic();

        window++;

        // Throttle when sensor is missing — otherwise we'd loop at SPI
        // speed emitting empty heartbeats and swamp the UART.
        if (!sensor_present) {
            unsigned int start = read_mcycle();
            while ((read_mcycle() - start) < (HEARTBEAT_SPIN_SECONDS * CLK_FREQ_HZ)) {
                /* spin */
            }
        }
    }
}