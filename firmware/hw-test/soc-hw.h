#ifndef SPIKEHW_H
#define SPIKEHW_H

#define PROMSTART 0x00000000
#define RAMSTART  0x00000800
#define RAMSIZE   0x400
#define RAMEND    (RAMSTART + RAMSIZE)

#define RAM_START 0x40000000
#define RAM_SIZE  0x04000000

#define FCPU      100000000

#define UART_RXBUFSIZE 32


/****************************************************************************
 * Types
 */
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit

typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit

/****************************************************************************
 * Interrupt handling
 */
typedef void(*isr_ptr_t)(void);

void     irq_enable();
void     irq_disable();
void     irq_set_mask(uint32_t mask);
uint32_t irq_get_mak();

void     isr_init();
void     isr_register(int irq, isr_ptr_t isr);
void     isr_unregister(int irq);

/****************************************************************************
 * General Stuff
 */
void     halt();
void     jump(uint32_t addr);


/****************************************************************************
 * Timer
 */
#define TIMER_EN     0x08    // Enable Timer
#define TIMER_AR     0x04    // Auto-Reload
#define TIMER_IRQEN  0x02    // IRQ Enable
#define TIMER_TRIG   0x01    // Triggered (reset when writing to TCR)

typedef struct {
	volatile uint32_t tcr0;
	volatile uint32_t compare0;
	volatile uint32_t counter0;
	volatile uint32_t tcr1;
	volatile uint32_t compare1;
	volatile uint32_t counter1;
} timer_t;

void msleep(uint32_t msec);
void nsleep(uint32_t nsec);

void prueba();
void tic_init();


/***************************************************************************
 * GPIO0
 */
typedef struct {
	volatile uint32_t ctrl;
	volatile uint32_t dummy1;
	volatile uint32_t dummy2;
	volatile uint32_t dummy3;
	volatile uint32_t in;
	volatile uint32_t out;
	volatile uint32_t oe;
} gpio_t;

/***************************************************************************
 * UART0
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart_t;

void uart_init();
void uart_putchar(char c);
void uart_putstr(char *str);
char uart_getchar();


/***************************************************************************
 * SPI0
 */
#define SPI_RST_DONE 0x01 // spi startup reset done
#define SPI_STATE 0x00 // spi transmission state finished
// lcd commands
#define EXTENDED_ISET 0x21 // change to extended instructions (check datasheet)
#define BIAS_VAL 0x14//  set bias value (check datasheet)
#define CONTRAST_VAL 0xbf// set contrast value (check datasheet)
#define BASIC_ISET 0x20// return to basic instructions (check datasheet)
#define NORMAL_MODE 0x0c// black over white (check datasheet)
#define INVERSE_MODE 0x0d// white over black (check datasheet)
#define BLANK_LCD 0x08// all pixels in blank (check datasheet)


// extern char *ASCII[100][5];

typedef struct {
	volatile uint32_t rst_done;	// state of the startup lcd reset
	volatile uint32_t dc;	// data or command interpreted byte
	volatile uint32_t rxtx;	// data byte
	volatile uint32_t x_pos; 	// x column position
	volatile uint32_t y_pos;	// y row position
	volatile uint32_t spi_cs;	// slave selection
	volatile uint32_t divisor;	// freq divisor value
	volatile uint32_t state;	// spi busy state
} spi_t;

void spi_lcd_init();
void spi_sendbyte(uint8_t c, uint8_t d_c);
void spi_lcd_putchar(char *c);
void spi_lcd_putchar1(char *c);
void spi_lcd_putchar2(char *c);
void spi_lcd_putstring(char *str);
void spi_lcd_blank();
void spi_lcd_invert();
uint8_t spi_lcd_getx();
uint8_t spi_lcd_gety();
void spi_lcd_setx();
void spi_lcd_sety();

/***************************************************************************
 * I2C0
 */

typedef struct {
   volatile uint32_t rxtx;
   volatile uint32_t divisor;
} i2c_t;



/***************************************************************************
 * Pointer to actual components
 */
extern timer_t  *timer0;
extern uart_t   *uart0;
extern gpio_t   *gpio0;
extern uint32_t *sram0;
extern spi_t *spi0;

#endif // SPIKEHW_H
