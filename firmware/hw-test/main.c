/**
 * 
 */

#include "soc-hw.h"

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
}

void test2() {
    uart_putchar('b');   
}

void test() {
    uart_putchar('a');
    test2();
    uart_putchar('c');
} 

char glob[] = "Global";

volatile uint32_t *p;
volatile uint8_t *p2;

extern uint32_t tic_msec;

int main()
{
	uint32_t aa,bb;

	volatile uint8_t *p1;
	volatile short *p3;
	volatile uint32_t *p4;
    
	*p1=100;
        p1=20;
  	p1++;
        p1=22;
  	p1++;
        p1=23;
  	p1++;

	*p3=200;
        p3=0x4040;
  	p3++;
        p3=0x5050;
  	p3++;
  
	*p4=300;
        p4=0x80808080;
  	p4++;
        p4=0x50504040;

	
	 uart_putchar('1');
	 uart_putchar('2');
	 uart_putchar('3');
	 uart_putchar('1');
	  aa=1;
	  for(;;)
	  {
			  uart_putchar(2);
	  }

	   prueba();
   uart_putchar('b');

   char test2[] = "Lokalerstr";
   char *str = test2;
   uint32_t i;
    
//    for (i = 0; i < 4; i++)
 //       test2[i] = 'l';
  //  glob[0]  = 'g';
    
 	// Initialize stuff
	uart_init();

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


/*
	uart_putstr( "Memory Dump: " );
	uint32_t *start = (uint32_t *)0x40000000;
	uint32_t *end   = (uint32_t *)0x40000100;
	uint32_t *p;
	for (p=start; p<end; p++) {
		if (((uint32_t)p & 12) == 0) {
			uart_putstr("\r\n[");
			writeint((uint32_t) p);
			uart_putchar(']');    
		}

		uart_putchar(' ');    
		writeint(*p);
	}
*/

	uart_putstr("Entering Echo Test...\n");
	while (1) {
	   uart_putchar(uart_getchar());
	}
}
