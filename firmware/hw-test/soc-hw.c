#include "soc-hw.h"

uart_t  *uart0  = (uart_t *)   0x20000000;
timer_t *timer0 = (timer_t *)  0x30000000;
gpio_t  *gpio0  = (gpio_t *)   0x40000000;
//uart_t  *uart1  = (uart_t *)   0x20000000;
spi_t   *spi0   = (spi_t *)    0x50000000;
i2c_t   *i2c0   = (i2c_t *)    0x60000000;

isr_ptr_t isr_table[32];

// void prueba()
// {
// 	   uart0->rxtx=30;
// 	   timer0->tcr0 = 0xAA;
// 	   gpio0->ctrl=0x55;
// 	   spi0->rxtx=1;
// 	   spi0->nop1=2;
// 	   spi0->cs=3;
// 	   spi0->nop2=5;
// 	   spi0->divisor=4;
// 	   i2c0->rxtx=5;
// 	   i2c0->divisor=5;
//
// }
void tic_isr();
/***************************************************************************
 * IRQ handling
 */
void isr_null()
{
}

void irq_handler(uint32_t pending)
{
	int i;

	for(i=0; i<32; i++) {
		if (pending & 0x01) (*isr_table[i])();
		pending >>= 1;
	}
}

void isr_init()
{
	int i;
	for(i=0; i<32; i++)
		isr_table[i] = &isr_null;
}

void isr_register(int irq, isr_ptr_t isr)
{
	isr_table[irq] = isr;
}

void isr_unregister(int irq)
{
	isr_table[irq] = &isr_null;
}

/***************************************************************************
 * TIMER Functions
 */
void msleep(uint32_t msec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000)*msec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}

void nsleep(uint32_t nsec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000000)*nsec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}


uint32_t tic_msec;

void tic_isr()
{
	tic_msec++;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;
}

void tic_init()
{
	tic_msec = 0;

	// Setup timer0.0
	timer0->compare0 = (FCPU/10000);
	timer0->counter0 = 0;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;

	isr_register(1, &tic_isr);
}


/***************************************************************************
 * UART Functions
 */
void uart_init()
{
	//uart0->ier = 0x00;  // Interrupt Enable Register
	//uart0->lcr = 0x03;  // Line Control Register:    8N1
	//uart0->mcr = 0x00;  // Modem Control Register

	// Setup Divisor register (Fclk / Baud)
	//uart0->div = (FCPU/(57600*16));
}

char uart_getchar()
{
	while (! (uart0->ucr & UART_DR)) ;
	return uart0->rxtx;
}

void uart_putchar(char c)
{
	while (uart0->ucr & UART_BUSY) ;
	uart0->rxtx = c;
}

void uart_putstr(char *str)
{
	char *c = str;
	while(*c) {
		uart_putchar(*c);
		c++;
	}
}

/***************************************************************************
 * SPI Functions
 */



// ok, it's working as it should
void spi_sendbyte(uint8_t c, uint8_t d_c)
{
	while (!(spi0->rst_done & SPI_RST_DONE) || (spi0->state)) ;
	// todo cambiar a un solo registro
	spi0->divisor = 0xFF;
	spi0->spi_cs = 0;
	spi0->dc = d_c;
	spi0->rxtx = c;
}

// void spi_lcd_putstring(char *str)
// {
//  char *c = str;
//   while (*c)
//   {
//     spi_lcd_putchar(*c);
// 	c++;
//   }
// }

// void spi_lcd_putchar(char *c)
// {
// 	int i;
//   for (i = 0; i < 5; i++)
//   {
//     spi_sendbyte(ASCII[*c-32][i], 1);
//   }
//   // spi_sendbyte(0x00, 1);
// }

// void spi_lcd_putchar1(char *c)
// {
// 	int i;
//   for (i = 0; i < 5; i++)
//   {
//     spi_sendbyte(ASCII[*c-31][i], 1);
//   }
//   // spi_sendbyte(0x00, 1);
// }
//
// void spi_lcd_putchar2(char *c)
// {
// 	int i;
//   for (i = 0; i < 5; i++)
//   {
//     spi_sendbyte(ASCII[*c-28][i], 1);
//   }
//   // spi_sendbyte(0x00, 1);
// }
//
// void spi_lcd_putchar1(const char c[])
// {
//
//     spi_sendbyte(ASCII[c[0]][0], 1);
// 	spi_sendbyte(ASCII[c[0]][1], 1);
// 	spi_sendbyte(ASCII[c[0]][2], 1);
// 	spi_sendbyte(ASCII[c[0]][3], 1);
// 	spi_sendbyte(ASCII[c[0]][4], 1);
//
// 	spi_sendbyte(ASCII[(int) c[0]][0], 1);
// 	spi_sendbyte(ASCII[(int) c[0]][1], 1);
// 	spi_sendbyte(ASCII[(int) c[0]][2], 1);
// 	spi_sendbyte(ASCII[(int) c[0]][3], 1);
// 	spi_sendbyte(ASCII[(int) c[0]][4], 1);
//
//
//   // spi_sendbyte(0x00, 1);
// }



// ok, it's working as it should
void spi_lcd_blank(void)
{
	int i;
  for ( i = 0; i < 504; i++)
  {
    spi_sendbyte(0x00, 1);
  }
}

// ok, it's working as it should
void spi_lcd_init(void)
{
	spi_sendbyte(EXTENDED_ISET,0);
	spi_sendbyte(BIAS_VAL,0);
	spi_sendbyte(CONTRAST_VAL,0);
	spi_sendbyte(BASIC_ISET,0);
	spi_sendbyte(NORMAL_MODE,0);
}
// ok, it's working as it should
void spi_lcd_invert()
{
	spi_sendbyte(INVERSE_MODE, 0);
}

uint8_t spi_lcd_getx()
{
	return spi0->x_pos;
}

uint8_t spi_lcd_gety()
{
	return spi0->y_pos;
}
//
// void spi_lcd_setx(uint8_t x)
// {
// 	spi_sendbyte(,0);
// }
//
// void spi_lcd_sety(uint8_t y)
// {
// 	spi_sendbyte(,0);
// }
