// @generated — vyges-soc-generator  DO NOT EDIT
// main.c — edge_sensor boot firmware (sensor_demo)
//
// Generated from soc-spec.yaml firmware section.
// Regenerate with: soc-generator generate soc-spec.yaml

#include "edge_sensor.h"

#define REG32(addr) (*(volatile unsigned int *)(addr))

// ── UART driver ─────────────────────────────────────────────────────────────

// NCO = round(baud * 2^20 / clk_hz) = 3020
#define UART_NCO 3020U

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
#define ADXL355_POWER_CTL   0x2D
#define ADXL355_XDATA3      0x08
#define ADXL355_YDATA3      0x0B
#define ADXL355_ZDATA3      0x0E

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

static int adxl355_read_axis(unsigned char addr_hi) {
    // Burst read -- CS held across all 3 bytes so ADXL355 returns a
    // coherent sample. Per-byte CS cycles would let the sensor update
    // mid-read and produce mixed-sample garbage.
    spi_cs_assert();
    spi_xfer8((addr_hi << 1) | 0x01);
    unsigned char b0 = spi_xfer8(0x00);
    unsigned char b1 = spi_xfer8(0x00);
    unsigned char b2 = spi_xfer8(0x00);
    spi_cs_deassert();
    int raw = ((int)b0 << 12) | ((int)b1 << 4) | (b2 >> 4);
    if (raw & 0x80000) raw |= 0xFFF00000;  // sign extend 20-bit
    return raw;
}

// ── Vibration analysis (CPU-side, fixed-point) ─────────────────────────────
// Collects N samples of the Z axis in a tight SPI poll then computes:
//   peak_to_peak : max - min (raw 20-bit counts)
//   mean_abs_dev : sum(|s - mean|) / N  (proxy for RMS vibration)
//   zero_cross   : sign changes of (s - mean)  (fundamental-frequency proxy)
//   sample_rate  : measured via mcycle CSR (validates SPI host throughput)
//
// 1 LSB at +/-2g full scale = 4/2^20 = 3.815 uG. Values are kept as
// integers because the core has no F extension and a demo banner does
// not need floating point.

#define VIB_N 256
static int sample_buf[VIB_N];

static unsigned int read_mcycle(void) {
    unsigned int v;
    __asm__ volatile("csrr %0, mcycle" : "=r"(v));
    return v;
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

    // Main loop -- vibration window per iteration
    uart_puts("\r\nvibration analysis: 10 windows of ");
    uart_put_dec(VIB_N);
    uart_puts(" samples each (Z axis)\r\n");

    for (int iter = 0; iter < 10 && devid == 0xAD; iter++) {
        unsigned int t0 = read_mcycle();
        for (int i = 0; i < VIB_N; i++)
            sample_buf[i] = adxl355_read_axis(ADXL355_ZDATA3);
        unsigned int t1 = read_mcycle();

        int smin = sample_buf[0], smax = sample_buf[0];
        long sum = 0;
        for (int i = 0; i < VIB_N; i++) {
            int s = sample_buf[i];
            sum += s;
            if (s < smin) smin = s;
            if (s > smax) smax = s;
        }
        int mean = (int)(sum / VIB_N);

        long mad_sum = 0;
        int zc = 0;
        int prev_d = sample_buf[0] - mean;
        for (int i = 1; i < VIB_N; i++) {
            int d = sample_buf[i] - mean;
            mad_sum += (d < 0) ? -d : d;
            if ((prev_d ^ d) < 0) zc++;
            prev_d = d;
        }
        unsigned int mad = (unsigned int)(mad_sum / VIB_N);
        unsigned int cycles_per_sample = (t1 - t0) / VIB_N;
        unsigned int rate_hz = cycles_per_sample ? (CLK_FREQ_HZ / cycles_per_sample) : 0;
        unsigned int freq_est_hz = ((unsigned int)zc * rate_hz) / (2U * VIB_N);

        uart_puts("  ["); uart_put_dec(iter); uart_puts("]  rate=");
        uart_put_dec(rate_hz); uart_puts("Hz  p2p=");
        uart_put_dec((unsigned int)(smax - smin));
        uart_puts("  vib="); uart_put_dec(mad);
        uart_puts("  fest="); uart_put_dec(freq_est_hz);
        uart_puts("Hz\r\n");
    }

    uart_puts("\r\n=== vibration scan complete ===\r\n");
    uart_puts("legend: rate = SPI sample rate, p2p = peak-to-peak counts,\r\n");
    uart_puts("        vib = mean-abs deviation, fest = zero-crossing freq est.\r\n");

    while (1) __asm__ volatile("wfi");
}