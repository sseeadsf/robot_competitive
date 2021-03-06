
#include <mega8.h>
#include <glcd.h>
#include <font5x7.h>
#include <delay.h>
#include <stdio.h>
#include <stdbool.h>

#define CE PORTB.0
#define CSN PORTB.1
#define SCK PORTB.5
#define MOSI PORTB.3
#define MISO PINB.4
#define IRQ PINB.7
char Send_Add = 0xB1, Receive_Add = 0xB1, Salt_Add = 0xAB;
#include "rf.c"

#define R1  PINC.4
#define R2  PINC.5
#define R3  PINB.6
#define R4  PINB.2
#define R5  PIND.0
#define PR1 PORTC.4
#define PR2 PORTC.5
#define PR3 PORTB.6
#define PR4 PORTB.2
#define PR5 PORTD.0

#define C1  PORTC.0
#define C2  PORTC.1
#define C3  PORTC.2
#define C4  PORTC.3

#define PORT_COT PORTC

unsigned char key_quet[4] = {0x37, 0x3B, 0x3D, 0x3E};
int i, j;
int ma[5][4] = {9, 0, 0, 10,
                5, 0, 0, 1,
                6, 0, 0, 2,
                7, 0, 0, 3,
                8, 0, 0, 4}; 
unsigned char buff[20];
int milisecond = 100, second = 180;
unsigned char blue = 0b0000, red = 0b0000;
bool is_start;
int blue_score, red_score;
int current_blue, current_red;
int pre_blue, pre_red;

void reset(){
    WDTCR=0x18;
    WDTCR=0x08;   
    while(1);    
}

void quet_ban_phim(){
    for(i=0;i<4;i++){
        PORT_COT = key_quet[i];        
        PR1 = 1;
        PR2 = 1;
        PR3 = 1;
        PR4 = 1;
        PR5 = 1;
        if(R1 == 0){       
            if(i == 3){
                TX_Send(10);
                delay_ms(10); 
                TX_Send(10);
                delay_ms(10);
                TX_Send(10);
                delay_ms(10);
                clear();
                is_start = true;
                glcd_clear();
                TIMSK = (1<<TOIE0);
                glcd_outtextxy(5, 0, "blue");
                glcd_outtextxy(60, 0, "red"); 
                glcd_line(42, 10, 42, 48);
            }
            else if(i == 0){
                TX_Send(9);  
                delay_ms(10);
                TX_Send(9);  
                delay_ms(10);
                TX_Send(9);  
                delay_ms(10);
                clear();
                reset();            
            }
        }
        else if(R2 == 0 && is_start){  
            if(i == 3){     
                TX_Send(1);
                delay_ms(10);
                TX_Send(1);
                delay_ms(10);
                TX_Send(1);
                delay_ms(10);
                clear();
                blue_score = pre_blue + 2; 
                current_blue = 2;
            }
            else if(i == 0){ 
                TX_Send(5);
                delay_ms(10);
                TX_Send(5);
                delay_ms(10);
                TX_Send(5);
                delay_ms(10);
                clear();
                red_score = pre_red + 2;
                current_red = 2;    
            }
        }                    
        else if(R3 == 0 && is_start){ 
            if(i == 3){      
                TX_Send(2); 
                delay_ms(10);
                TX_Send(2); 
                delay_ms(10);
                TX_Send(2); 
                delay_ms(10);
                clear();
                blue_score = pre_blue + 3;
                current_blue = 3; 
            }
            else if(i == 0){ 
                TX_Send(6); 
                delay_ms(10);
                TX_Send(6); 
                delay_ms(10);
                TX_Send(6); 
                delay_ms(10);
                clear();
                red_score = pre_red + 3;
                current_red = 3;
            }
        }
        else if(R4 == 0 && is_start){ 
            if(i == 3){      
                TX_Send(3);
                delay_ms(10);
                TX_Send(3);
                delay_ms(10);
                TX_Send(3);
                delay_ms(10);
                clear();
                blue_score = pre_blue + 5;
                current_blue = 5; 
            }
            else if(i == 0){ 
                TX_Send(7);  
                delay_ms(10);
                TX_Send(7);  
                delay_ms(10);
                TX_Send(7);  
                delay_ms(10);
                clear();
                red_score = pre_red + 5;
                current_red = 5;
                clear();
            }
        }       
        else if(R5 == 0 && is_start){ 
            if(i == 3){      
                TX_Send(4); 
                delay_ms(10);
                TX_Send(4); 
                delay_ms(10);
                TX_Send(4); 
                delay_ms(10);
                clear();
                blue_score = pre_blue + 10;
                current_blue = 10;  
            }
            else if(i == 0){ 
                TX_Send(8); 
                delay_ms(10); 
                TX_Send(8); 
                delay_ms(10);
                TX_Send(8); 
                delay_ms(10);
                clear();
                red_score = pre_red + 10;
                current_red = 10;
            }    
        }
    }    
}

bool no_button(){
    for(i=0;i<4;i++){
        PORT_COT = key_quet[i];        
        PR1 = 1;
        PR2 = 1;
        PR3 = 1;
        PR4 = 1;
        PR5 = 1;
        if(R1 == 0 || R2 == 0 || R3 == 0 || R4 == 0 || R5 == 0)
            return false;
    }
    return true;
}

interrupt [TIM0_OVF] void timer0_interrupt(){
    TCNT0 = 0xB2;
    milisecond--; 
    if(milisecond == 0){
        second--;
        milisecond = 100;         
    }     
    if(second == 0)
        reset();
}

void main(void)
{
GLCDINIT_t glcd_init_data;

// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (1<<PORTD0);

TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0xB2;

TIMSK = (0<<TOIE0);

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;
// Set the LCD temperature coefficient
glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
// Set the LCD bias
glcd_init_data.bias=4;
// Set the LCD contrast control voltage VLCD
glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;

glcd_init(&glcd_init_data);

#asm("sei")
#asm("wdr")

Common_Config();
delay_us(10);
Common_Init();
delay_us(10);
TX_Config();
delay_us(10);
TX_Mode();

glcd_outtextxy(16, 0, "cham diem");
glcd_outtextxy(22, 10, "tu dong");
is_start = false;

while (1){
    quet_ban_phim();
    clear();
    if(no_button()){
        pre_blue = blue_score;
        pre_red = red_score;
    }
    if(is_start){
        sprintf(buff, "%d ", second);
        glcd_outtextxy(36, 0, buff);
        sprintf(buff, "%d ", blue_score);
        glcd_outtextxy(12, 40, buff);
        sprintf(buff, "%d ", red_score);
        glcd_outtextxy(64, 40, buff); 
        sprintf(buff, "%d ", current_blue);
        glcd_outtextxy(12, 24, buff);
        sprintf(buff, "%d ", current_red);
        glcd_outtextxy(64, 24, buff);   
                         
    }     
}
}
