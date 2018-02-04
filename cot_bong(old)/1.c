

#include <io.h>
#include <delay.h>
#include <stdbool.h>

#define tiem_can PIND.3
#define servo PORTD.2
#define CE      PORTC.0
#define SCK     PORTC.2
#define MISO    PINC.4
#define CSN     PORTC.1
#define MOSI    PORTC.3
#define IRQ     PINC.5
char Send_Add = 0xB1, Receive_Add = 0xC0, Salt_Add = 0xAB; 
int score;
#include "rf.c"
int dem, rc;


interrupt [TIM0_OVF] void timer0_interrput(){
    TCNT0 = 0x9C;
    dem++;
    if(dem == 200)
        dem = 0;
    if(dem < rc)
        servo = 1;
    else 
        servo = 0;
}


void main(){
    DDRC = 0b00001110;
    PORTC = 0b00111111;
    
    DDRD = 0x04;
    PORTD = 0x08;   
    
    TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
    TCNT0=0x9C;                                                                                      
    

    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);  
        
    Common_Config(); 
    delay_us(100);
    Common_Init();
    delay_us(100);
    TX_Config(); 
    delay_us(100);
    TX_Mode();  
    
    #asm("sei")
    #asm("wdr")
            
    score = 5;
    
    delay_ms(200);
    while(1){   
        rc = 11; 
        if(tiem_can == 1){
            delay_ms(100);
            rc = 17;
            TX_Send();
            delay_ms(200);
            while(tiem_can == 1);       
        }
        TX_Config();
    }           
}