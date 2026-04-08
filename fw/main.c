// @generated — vyges-soc-generator  DO NOT EDIT
// main.c — edge_sensor boot firmware (sensor_demo)
//
// Generated from soc-spec.yaml firmware section.
// Regenerate with: soc-generator generate soc-spec.yaml

#include "edge_sensor.h"

#define REG32(addr) (*(volatile unsigned int *)(addr))

// ── UART driver ─────────────────────────────────────────────────────────────

// NCO = round(baud * 2^20 / clk_hz) = 2416
#define UART_NCO 2416U

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

// SPI clock divider: SCLK = 50 MHz / (2*(7+1)) = 3.125 MHz
#define SPI_CLK_DIV 7U

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
    unsigned char b0 = adxl355_read_reg(addr_hi);
    unsigned char b1 = adxl355_read_reg(addr_hi + 1);
    unsigned char b2 = adxl355_read_reg(addr_hi + 2);
    int raw = ((int)b0 << 12) | ((int)b1 << 4) | (b2 >> 4);
    if (raw & 0x80000) raw |= 0xFFF00000;  // sign extend 20-bit
    return raw;
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
    uart_puts("  (C) 2026 Vyges Inc. All Rights Reserved.\r\n");
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

    // Main loop
    for (int iter = 0; iter < 10; iter++) {
        uart_puts("\r\n--- Iter ");
        uart_put_dec(iter);
        uart_puts(" ---\r\n");

        if (devid == 0xAD) {
            int x = adxl355_read_axis(ADXL355_XDATA3);
            uart_puts("X="); uart_put_dec(x > 0 ? x : -x);
            int y = adxl355_read_axis(ADXL355_YDATA3);
            uart_puts(" Y="); uart_put_dec(y > 0 ? y : -y);
            int z = adxl355_read_axis(ADXL355_ZDATA3);
            uart_puts(" Z="); uart_put_dec(z > 0 ? z : -z);
            uart_puts("\r\n");
        }

        uart_puts("FFT 1024-pt...");
        fft_start(1024);
        while (!fft_is_done()) ;
        uart_puts(" DONE\r\n");
    }

    uart_puts("\r\n=== 10 iterations complete ===\r\n");

    while (1) __asm__ volatile("wfi");
}