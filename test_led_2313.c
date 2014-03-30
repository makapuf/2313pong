#define F_CPU 8000000UL
#include <avr/io.h>
#include <util/delay.h>

#define outD  1<<PD2 | 1<<PD6
#define outB  1<<PB3 | 1<<PB7

void wait()
{
    if (PINB & (1<<PB0))
        _delay_ms(300);
    else 
        _delay_ms(100);
}
void blink()
{
        PORTD &= ~(outD); 
        wait();

        PORTD |= outD; 
        wait();
}


void copy()
{
    if (PINB & (1<<PB0)) 
        PORTD &= ~(outD); 
    else 
        PORTD |= outD; 

}
int main(void) {
    DDRD |= outD; // pd6 audio pd2 led 
    DDRB |= outB; // pb3 sync pb7 video 
    DDRB &= ~(1<<0); // PB0 button : pullup externe

    while(1) {
        blink();


    }
    return 0;
}
