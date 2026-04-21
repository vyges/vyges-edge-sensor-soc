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
    uart_puts("# HELP vyges_edge_sensor_vibration_p2p_counts Peak-to-peak ADC counts per axis (20-bit, +/-2g)\r\n");
    uart_puts("# TYPE vyges_edge_sensor_vibration_p2p_counts gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_vibration_mad_counts Mean absolute deviation from mean per axis\r\n");
    uart_puts("# TYPE vyges_edge_sensor_vibration_mad_counts gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_freq_estimate_hz Zero-crossing fundamental frequency estimate per axis\r\n");
    uart_puts("# TYPE vyges_edge_sensor_freq_estimate_hz gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_temperature_raw On-chip ADXL355 12-bit temperature ADC code (apply client-side scaling)\r\n");
    uart_puts("# TYPE vyges_edge_sensor_temperature_raw gauge\r\n");
    uart_puts("# HELP vyges_edge_sensor_sample_rate_hz Measured SPI sample rate this window\r\n");
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

    if (devid != 0xAD) {
        uart_puts("# ADXL355 NOT FOUND — sensor stream disabled\r\n");
        while (1) __asm__ volatile("wfi");
    }

    unsigned int window = 0;
    while (1) {
        unsigned int t0 = read_mcycle();
        for (int i = 0; i < VIB_N; i++)
            adxl355_read_xyz(&sample_x[i], &sample_y[i], &sample_z[i]);
        unsigned int t1 = read_mcycle();

        unsigned int cycles_per_sample = (t1 - t0) / VIB_N;
        unsigned int rate_hz = cycles_per_sample ? (CLK_FREQ_HZ / cycles_per_sample) : 0;
        unsigned int temp_raw = adxl355_read_temp_raw();

        axis_stats_t sx = compute_axis_stats(sample_x, rate_hz);
        axis_stats_t sy = compute_axis_stats(sample_y, rate_hz);
        axis_stats_t sz = compute_axis_stats(sample_z, rate_hz);

        uart_puts("# === window "); uart_put_dec(window); uart_puts(" ===\r\n");
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
        prom_scalar("vyges_edge_sensor_sample_rate_hz", rate_hz);
        prom_scalar("vyges_edge_sensor_mcycle", t1);
        prom_scalar("vyges_edge_sensor_window_index", window);
        uart_puts("# END_WINDOW "); uart_put_dec(window); uart_puts("\r\n");

        window++;
    }
}