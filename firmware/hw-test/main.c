/**
 *
 */

#include "soc-hw.h"
#define R_SIZE 5
/*
inline void writeint(uint32_t val)
{
	uint32_t i, digit;

	for (i=0; i<8; i++) {
		digit = (val & 0xf0000000) >> 28;
		if (digit >= 0xA)
			uart_putchar('A'+digit-10);
		else
			uart_putchar('0'+digit);
		val <<= 4;
	}
}*/

/*

char glob[] = "Global";

volatile uint32_t *p;
volatile uint8_t *p2;

*/
//
// extern uint32_t tic_msec;



int main()
{
    // spi_lcd_init();
    // char test[] = "a";
    // char *z;
    // z = test;
    spi_lcd_putstring("Hola!", R_SIZE);
    // spi_lcd_putchar('$');
    // spi_lcd_putchar('%');
    // spi_lcd_putchar('&');
    // printf("hola\n");
    	// spi_lcd_putchar1(z);
        // 	spi_lcd_putchar2(z);
	// spi_lcd_putchar(1);
	// spi_lcd_putchar(2);
	// spi_lcd_putchar(3);
	// spi_lcd_putchar1(6);
	// spi_lcd_putchar2('B');
	// spi_lcd_putsendbyte
	// for (i = 0; i < 5; i++)
	// 	spi_sendbyte(ASCII[3][i], 1);
    //
    //
	// for (i = 0; i < 5; i++)
	// 	spi_sendbyte(ASCII[17][i], 1);
    //
	// c = 'a';
		// spi_sendbyte(ASCII[z-32][0], 1);
    //
    // spi_lcd_putchar(c);
    //
	// c = 'z';
	// for (i = 0; i < 5; i++)
	// 	spi_sendbyte(ASCII[c-32][i], 1);

// spi_lcd_putchar('#');
// spi_lcd_putchar('M');


	/*
	spi_t   *spi_0   = (spi_t *)    0x50000000;
	spi_0->rxtx = 0xAA;
	spi_0->cs = 0x01;
	spi_0->divisor = 0xFF;*/

/*
*
* aa=1;
	prueba();
uart_putchar('b');

char test2[] = "Lokalerstr";
char *str = test2;
uint32_t i;

	// Say Hello!
	uart_putstr( "** Spike Test Firmware **\n" );

	// Initialize TIC
	isr_init();
	tic_init();
	irq_set_mask( 0x00000002 );
	irq_enable();

	// Say Hello!
	uart_putstr( "Timer Interrupt instelled.\n" );

	// Do some trivial tests
	uart_putstr( "Subroutine-Return Test: " );
	test();
	uart_putchar('\n');

	uart_putstr( "Local-Pointer Test:" );
	for (;*str; str++) {
	uart_putchar(*str);
	}
	uart_putchar('\n');

	uart_putstr( "Global-Pointer Test:" );
	str = glob;
	for (;*str; str++) {
	uart_putchar(*str);
	}
	uart_putchar('\n');

	uart_putstr( "Stack Pointer : " );
	writeint(get_sp());
	uart_putchar('\n');

	uart_putstr( "Global Pointer: " );
	writeint(get_gp());
	uart_putchar('\n');

	uart_putstr( "Timer Test (1s): " );
	for(i=0; i<4; i++) {
		uart_putstr("tic...");
		msleep(1000);
	}
	uart_putchar('\n');

	uart_putstr( "Timer Interrupt counter: " );
	writeint( tic_msec );
	uart_putchar('\n');

	int val = tic_msec;
	uart_putstr( "Shift: " );
	writeint( val );
	uart_putstr(" <-> ");
	for(i=0; i<32; i++) {
		if (val & 0x80000000)
			uart_putchar( '1' );
		else
			uart_putchar( '0' );

		val <<= 1;
	}
	uart_putstr("\r\n");

	uart_putstr( "GPIO Test..." );
	gpio0->oe = 0x000000ff;
	for(;;) {
		for(i=0; i<8; i++) {
			uint32_t out1, out2;

			out1 = 0x01 << i;
			out2 = 0x80 >> i;
			gpio0->out = out1 | out2;

			msleep(100);
		}
	}


	uart_putstr("Entering Echo Test...\n");
	while (1) {
	uart_putchar(uart_getchar());
	}

	*/
	return 0;
}
