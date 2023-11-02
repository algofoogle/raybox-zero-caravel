#include <defs.h>
#include <stub.c>


void wait(int w) { for (int j=0; j<w; ++j); }

void main() {
    // Start with gpio=0:
    reg_gpio_out = 0;
    // Enable gpio OUTPUT:
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oe = 1;
    // Pulse gpio:
    reg_gpio_out = 1;
    reg_gpio_out = 0;

    int w = 125000;
    // Blink gpio pin four times quickly:
    for (int i=0; i<4; ++i) {
        reg_gpio_out = 1; wait(w); reg_gpio_out = 0; wait(w);
    }

    // Blink gpio pin four times slowly:
    w = 250000;
    for (int i=0; i<4; ++i) {
        reg_gpio_out = 1;
        wait(w);
        reg_gpio_out = 0;
        wait(w);
    }

    // MAIN TEST 1: Activate PLL, then configure:
    reg_hkspi_pll_ena = 1;
    reg_hkspi_pll_bypass = 0;
    reg_hkspi_pll_source = 0b00001111;

    // Now blink gpio forever at the slower speed from before:
    w = 250000;
    while (true) {
        reg_gpio_out = 1; wait(w); reg_gpio_out = 0; wait(w);
    }
}
