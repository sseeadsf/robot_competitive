
#include <io.h>
#include <delay.h>
#include <string.h>
#include <stdbool.h>

#define LED_SEG             PORTB
#define LED_A               PORTC.0
#define LED_TIME1           PORTD.7 
#define LED_TIME2           PORTD.6
#define LED_TIME3           PORTD.5
#define LED_RED_SCORE1      PORTD.4
#define LED_RED_SCORE2      PORTB.6
#define LED_RED_SCORE3      PORTB.7
#define LED_BLUE_SCORE1     PORTD.1
#define LED_BLUE_SCORE2     PORTD.2
#define LED_BLUE_SCORE3     PORTD.3

#define CE                  PORTD.0
#define CSN                 PORTC.1
#define SCK                 PORTC.5
#define MOSI                PORTC.2
#define MISO                PINC.4
#define IRQ                 PINC.3
char Send_Add = 0xC0, Receive_Add = 0xB1, Salt_Add = 0xAB; 
int score;
#include "rf.c"

unsigned char number[10] = {0xFE, 0xF0, 0xED, 0xF9, 0xF3, 0xDB, 0xDF, 0xF0, 0xFF, 0xFB}; 
unsigned char numberA[10] = {1, 0, 1, 1, 0, 1, 1, 1, 1, 1};  
unsigned char milisecond = 100, second = 180;
unsigned char led = 1;
unsigned char red_score = 0b0000;
unsigned char blue_score = 0b0000;
int red_scores = 0, blue_scores = 0;
bool time_out = true;
int a;

bool check_finish(unsigned char input){
    if(input == 0b1111)
        return true;
    else 
        return false;   
}

void get_score(){
    if(score == 1){
        blue_scores += 2;
        blue_score |= 0b0001;
    }
    else if(score == 2){
        blue_scores += 3;
        blue_score |= 0b0010;
    }                     
    else if(score == 3){
        blue_scores += 5;
        blue_score |= 0b0100;
    }                     
    else if(score == 4){
        blue_scores += 10;
        blue_score |= 0b1000;
    }                     
    else if(score == 5){
        red_scores += 2;
        red_score |= 0b0001;
    }                    
    else if(score == 6){
        red_scores += 3;
        red_score |= 0b0010;
    }                       
    else if(score == 7){
        red_scores += 5;
        red_score |= 0b0100;
    }                       
    else if(score == 8){
        red_scores += 10;
        red_score |= 0b1000;
    }                        
}

void stop_game(){
    time_out = true;
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);    
}

void start_game(){
    time_out = false;
    TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);    
}

void reset_game(){
    WDTCR=0x18;
    WDTCR=0x08;   
    while(1);    
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void){
    TCNT0=0x06;  
    if(led == 1){
        LED_SEG = number[second/100];
        LED_A = numberA[second/100];
        LED_TIME1 =         0;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1;
                     
    }
    
    else if(led == 2){
        LED_SEG = number[(second%100)/10];
        LED_A = numberA[(second%100)/10];
        LED_TIME1 =         1;
        LED_TIME2 =         0;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1;     
    }
    
    else if(led == 3){
        LED_SEG = number[second%10];  
        LED_A = numberA[second%10];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         0;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1;     
    }                                
    
    else if(led == 4){
        LED_SEG = number[red_scores/100];
        LED_A = numberA[red_scores/100];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    0;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1; 
    }
    
    else if(led == 5){
        LED_SEG = number[(red_scores%100)/10]; 
        LED_A = numberA[(red_scores%100)/10];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    0;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1;    
    }
    
    else if(led == 6){
        LED_SEG = number[red_scores%10];
        LED_A = numberA[red_scores%10];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    0;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1;    
    }
    
    else if(led == 7){
        LED_SEG = number[blue_scores/100]; 
        LED_A = numberA[blue_scores/100];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   0;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   1;
    }
    
    else if(led == 8){
        LED_SEG = number[(blue_scores%100)/10];
        LED_A = numberA[(blue_scores%100)/10];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   0;
        LED_BLUE_SCORE3 =   1;    
    }  
    
    else if(led == 9){
        LED_SEG = number[blue_scores%10];
        LED_A = numberA[blue_scores%10];
        LED_TIME1 =         1;
        LED_TIME2 =         1;
        LED_TIME3 =         1;
        LED_RED_SCORE1 =    1;
        LED_RED_SCORE2 =    1;
        LED_RED_SCORE3 =    1;
        LED_BLUE_SCORE1 =   1;
        LED_BLUE_SCORE2 =   1;
        LED_BLUE_SCORE3 =   0; 
        led = 0;   
    }   
    
    led++;
}

interrupt [TIM2_OVF] void timer2_interrupt(){
    TCNT2 = 0xB2;   
    milisecond--; 
    a++;
    if(a == 40)
        a = 0;

    if(milisecond == 0){
        second--;
        milisecond = 100;         
    }
    if(second == 0){
        stop_game();
    }  
}

void main(void){

DDRB = 0xFF;
PORTB= 0x00;

DDRD = 0xFF;
PORTD= 0xFF;

DDRC = 0x27;
PORTC = 0x00;


TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x06;


//10ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
TCNT2=0xB2;
OCR2=0x00;


TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

#asm("sei")

Common_Config();
delay_us(10);
Common_Init();
delay_us(10);
RX_Config();
delay_us(10);
RX_Mode();


while (1){    
    if(IRQ == 0){
        RX_Read();           
        if(score == 9)
            reset_game();
        else if(score == 10){
            start_game();
            RX_Config();    
        }
        if(!time_out){  
            get_score();
            delay_ms(500);
        }
                           
        if(check_finish(red_score)){ 
            TIMSK = (0<<TOIE2) | (1<<TOIE0);
            red_scores = 999;
            stop_game();
        }           
        if(check_finish(blue_score)){  
            TIMSK = (0<<TOIE2) | (1<<TOIE0);
            blue_scores = 999;
            stop_game();
        }
        RX_Config();
    }      
}
}