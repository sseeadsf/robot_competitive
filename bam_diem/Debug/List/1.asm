
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Send_Add=R5
	.DEF _Receive_Add=R4
	.DEF _Salt_Add=R7
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF _j=R10
	.DEF _j_msb=R11
	.DEF _milisecond=R12
	.DEF _milisecond_msb=R13
	.DEF _blue=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_interrupt
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xB1,0xB1,0x0,0xAB
	.DB  0x0,0x0,0x0,0x0
	.DB  0x64,0x0

_0x5A:
	.DB  0x37,0x3B,0x3D,0x3E
_0x5B:
	.DB  0x9,0x0,0x0,0x0,0x0,0x0,0xA,0x0
	.DB  0x5,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x6,0x0,0x0,0x0,0x0,0x0,0x2,0x0
	.DB  0x7,0x0,0x0,0x0,0x0,0x0,0x3,0x0
	.DB  0x8,0x0,0x0,0x0,0x0,0x0,0x4
_0x5C:
	.DB  0xB4
_0x0:
	.DB  0x62,0x6C,0x75,0x65,0x0,0x72,0x65,0x64
	.DB  0x0,0x63,0x68,0x61,0x6D,0x20,0x64,0x69
	.DB  0x65,0x6D,0x0,0x74,0x75,0x20,0x64,0x6F
	.DB  0x6E,0x67,0x0,0x25,0x64,0x20,0x0
_0x2100060:
	.DB  0x1
_0x2100000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _key_quet
	.DW  _0x5A*2

	.DW  0x01
	.DW  _second
	.DW  _0x5C*2

	.DW  0x05
	.DW  _0x6F
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x6F+5
	.DW  _0x0*2+5

	.DW  0x0A
	.DW  _0xA0
	.DW  _0x0*2+9

	.DW  0x08
	.DW  _0xA0+10
	.DW  _0x0*2+19

	.DW  0x01
	.DW  __seed_G108
	.DW  _0x2100060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <glcd.h>
;#include <font5x7.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdbool.h>
;
;#define CE PORTB.0
;#define CSN PORTB.1
;#define SCK PORTB.5
;#define MOSI PORTB.3
;#define MISO PINB.4
;#define IRQ PINB.7
;char Send_Add = 0xB1, Receive_Add = 0xB1, Salt_Add = 0xAB;
;#include "rf.c"
;#define CONFIG      	0x00
;#define EN_AA       	0x01
;#define EN_RXADDR   	0x02
;#define SETUP_AW    	0x03
;#define SETUP_RETR  	0x04
;#define RF_CH       	0x05
;#define RF_SETUP    	0x06
;#define STATUS  		0x07
;#define OBSERVE_TX  	0x08
;#define RPD          	0x09
;#define RX_ADDR_P0  	0x0A
;#define RX_ADDR_P1  	0x0B
;#define RX_ADDR_P2  	0x0C
;#define RX_ADDR_P3  	0x0D
;#define RX_ADDR_P4  	0x0E
;#define RX_ADDR_P5  	0x0F
;#define TX_ADDR     	0x10
;#define RX_PW_P0    	0x11
;#define RX_PW_P1    	0x12
;#define RX_PW_P2    	0x13
;#define RX_PW_P3    	0x14
;#define RX_PW_P4    	0x15
;#define RX_PW_P5    	0x16
;#define FIFO_STATUS 	0x17
;#define DYNPD	    	0x1C
;#define FEATURE	    	0x1D
;
;void SPI_Write(unsigned char Buff){
; 0000 0010 void SPI_Write(unsigned char Buff){

	.CSEG
_SPI_Write:
; .FSTART _SPI_Write
;    unsigned char bit_ctr;
;    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
	RCALL SUBOPT_0x0
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x4:
	CPI  R17,8
	BRSH _0x5
;        MOSI = (Buff & 0x80);
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x6
	CBI  0x18,3
	RJMP _0x7
_0x6:
	SBI  0x18,3
_0x7:
;        delay_us(5);
	__DELAY_USB 13
;        Buff = (Buff << 1);
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
;        SCK = 1;
	SBI  0x18,5
;        delay_us(5);
	__DELAY_USB 13
;        Buff |= MISO;
	LDI  R30,0
	SBIC 0x16,4
	LDI  R30,1
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
;        SCK = 0;
	CBI  0x18,5
;    }
	SUBI R17,-1
	RJMP _0x4
_0x5:
;}
	LDD  R17,Y+0
	RJMP _0x2120003
; .FEND
;
;unsigned char SPI_Read(void){
;    unsigned char Buff=0;
;    unsigned char bit_ctr;
;    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
;	Buff -> R17
;	bit_ctr -> R16
;        delay_us(5);
;        Buff = (Buff << 1);
;        SCK = 1;
;        delay_us(5);
;        Buff |= MISO;
;        SCK = 0;
;    }
;    return(Buff);
;}
;
;
;void RF_Command(unsigned char command){
_RF_Command:
; .FSTART _RF_Command
;    CSN=0;
	RCALL SUBOPT_0x1
;	command -> Y+0
;    SPI_Write(command);
	RCALL SUBOPT_0x2
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x212000B
; .FEND
;
;
;void RF_Write(unsigned char Reg_Add, unsigned char Value){
_RF_Write:
; .FSTART _RF_Write
;    CSN=0;
	RCALL SUBOPT_0x1
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	RCALL SUBOPT_0x2
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x2120003
; .FEND
;
;void RF_Write_Add(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register address
;{
_RF_Write_Add:
; .FSTART _RF_Write_Add
;    CSN=0;
	RCALL SUBOPT_0x1
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
	RCALL SUBOPT_0x3
;    SPI_Write(Salt_Add);
	MOV  R26,R7
	RCALL SUBOPT_0x4
;    SPI_Write(Value);
	RCALL SUBOPT_0x4
;    SPI_Write(Value);
	RCALL SUBOPT_0x4
;    SPI_Write(Value);
	RCALL SUBOPT_0x4
;    SPI_Write(Value);
	RCALL SUBOPT_0x5
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x2120003
; .FEND
;
;void TX_Address(unsigned char Address){
_TX_Address:
; .FSTART _TX_Address
;    CSN=0;
	RCALL SUBOPT_0x1
;	Address -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write
;    CSN=1;
	RCALL SUBOPT_0x6
;    delay_us(10);
;    CSN=0;
;    //RF_Write_Add(RX_ADDR_P0, Address);
;    RF_Write_Add(TX_ADDR, Address);
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _RF_Write_Add
;}
	RJMP _0x212000B
; .FEND
;
;void RX_Address(unsigned char Address){
;    CSN=0;
;	Address -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    RF_Write_Add(RX_ADDR_P0, Address);
;    //RF_Write_Add(RX_PW_P0, Address);
;}
;
;
;void Common_Config(){
_Common_Config:
; .FSTART _Common_Config
;    CE=0;
	CBI  0x18,0
;    CSN=1;
	SBI  0x18,1
;    SCK=0;
	CBI  0x18,5
;    delay_us(10);
	RCALL SUBOPT_0x7
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0x8
;    RF_Command(0b11100010);
	LDI  R26,LOW(226)
	RCALL _RF_Command
;    RF_Write(CONFIG,0b00011111);
	RCALL SUBOPT_0x9
	LDI  R26,LOW(31)
	RCALL _RF_Write
;    delay_ms(2);
	RCALL SUBOPT_0xA
	RCALL _delay_ms
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0xB
;    RF_Write(FEATURE, 0b00000100);
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _RF_Write
;    RF_Write(RF_CH,0b00000010);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _RF_Write
;    RF_Write(RF_SETUP, 0b00000110);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL _RF_Write
;    RF_Write(DYNPD,0b00000001);
	LDI  R30,LOW(28)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _RF_Write
;    RF_Write(EN_RXADDR,0b00000001);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _0x212000C
;}
; .FEND
;
;void Common_Init(){
_Common_Init:
; .FSTART _Common_Init
;    CE=1;
	SBI  0x18,0
;    delay_us(700);
	__DELAY_USW 1400
;    CE=0;
	CBI  0x18,0
;    CSN=1;
	SBI  0x18,1
;}
	RET
; .FEND
;
;
;void TX_Mode(){
_TX_Mode:
; .FSTART _TX_Mode
;    CE=0;
	CBI  0x18,0
;    RF_Write(CONFIG,0b00011110);
	RCALL SUBOPT_0x9
	LDI  R26,LOW(30)
_0x212000C:
	RCALL _RF_Write
;}
	RET
; .FEND
;
;void RX_Mode(){
;    RF_Write(CONFIG,0b00011111);
;    CE=1;
;}
;
;void TX_Config(){
_TX_Config:
; .FSTART _TX_Config
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0xB
;    RF_Command(0b11100010);
	LDI  R26,LOW(226)
	RCALL _RF_Command
;    TX_Address(Send_Add);
	MOV  R26,R5
	RCALL _TX_Address
;}
	RET
; .FEND
;
;void RX_Config(){
;    RF_Write(STATUS,0b01111110);
;    RF_Command(0b11100010);
;    RX_Address(Receive_Add);
;}
; void clear(){
_clear:
; .FSTART _clear
;  CSN=0;//nghe lenh
	CBI  0x18,1
;    delay_us(10);
	RCALL SUBOPT_0x7
;	RF_Write(STATUS,0x70);
	LDI  R26,LOW(112)
	RCALL _RF_Write
;    RF_Write(CONFIG,0b00011110);
	RCALL SUBOPT_0x9
	LDI  R26,LOW(30)
	RCALL _RF_Write
;   // RF_Command(0b11100010);
;	delay_us(10);
	RCALL SUBOPT_0xC
;        RF_Write(CONFIG,0b00011110);
	RCALL SUBOPT_0x9
	LDI  R26,LOW(30)
	RCALL _RF_Write
;
;    CSN=1;
	SBI  0x18,1
;    delay_ms(10);
	RCALL SUBOPT_0xD
	RCALL _delay_ms
;    }
	RET
; .FEND
;
;void TX_Send(int diem){
_TX_Send:
; .FSTART _TX_Send
;    TX_Address(Send_Add);
	RCALL SUBOPT_0xE
;	diem -> Y+0
	MOV  R26,R5
	RCALL _TX_Address
;    CSN=1;
	RCALL SUBOPT_0x6
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b11100001);
	LDI  R26,LOW(225)
	RCALL SUBOPT_0x5
;    CSN=1;
;    delay_us(10);
;    CSN=0;
	CBI  0x18,1
;    SPI_Write(0b10100000);
	LDI  R26,LOW(160)
	RCALL SUBOPT_0x4
;    SPI_Write(diem);
	RCALL _SPI_Write
;    CSN=1;
	SBI  0x18,1
;    CE=1;
	SBI  0x18,0
;    delay_us(500);
	__DELAY_USW 1000
;    CE=0;
	CBI  0x18,0
;    RF_Write(0x07,0b01111110);
	RCALL SUBOPT_0xB
;    TX_Address(Send_Add);
	MOV  R26,R5
	RCALL _TX_Address
;    RF_Command(0b11100001);
	LDI  R26,LOW(225)
	RCALL _RF_Command
;}
	RJMP _0x2120003
; .FEND
;
;void RX_Read(int score){
;    CE=0;
;	score -> Y+0
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b01100001);
;    delay_us(10);
;    score = SPI_Read();
;    CSN=1;
;    CE=1;
;    RF_Write(STATUS,0b01111110);
;    RF_Command(0b11100010);
;}
;
;void TX_Send_(int so_lan, int score){
;    int i;
;    for(i=0;i<so_lan;i++){
;	so_lan -> Y+4
;	score -> Y+2
;	i -> R16,R17
;        TX_Send(score);
;    }
;}
;
;#define R1  PINC.4
;#define R2  PINC.5
;#define R3  PINB.6
;#define R4  PINB.2
;#define R5  PIND.0
;#define PR1 PORTC.4
;#define PR2 PORTC.5
;#define PR3 PORTB.6
;#define PR4 PORTB.2
;#define PR5 PORTD.0
;
;#define C1  PORTC.0
;#define C2  PORTC.1
;#define C3  PORTC.2
;#define C4  PORTC.3
;
;#define PORT_COT PORTC
;
;unsigned char key_quet[4] = {0x37, 0x3B, 0x3D, 0x3E};

	.DSEG
;int i, j;
;int ma[5][4] = {9, 0, 0, 10,
;                5, 0, 0, 1,
;                6, 0, 0, 2,
;                7, 0, 0, 3,
;                8, 0, 0, 4};
;unsigned char buff[20];
;int milisecond = 100, second = 180;
;unsigned char blue = 0b0000, red = 0b0000;
;bool is_start;
;int blue_score, red_score;
;int current_blue, current_red;
;int pre_blue, pre_red;
;
;void reset(){
; 0000 0033 void reset(){

	.CSEG
_reset:
; .FSTART _reset
; 0000 0034     WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 0035     WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 0036     while(1);
_0x5D:
	RJMP _0x5D
; 0000 0037 }
; .FEND
;
;void quet_ban_phim(){
; 0000 0039 void quet_ban_phim(){
_quet_ban_phim:
; .FSTART _quet_ban_phim
; 0000 003A     for(i=0;i<4;i++){
	CLR  R8
	CLR  R9
_0x61:
	RCALL SUBOPT_0xF
	BRLT PC+2
	RJMP _0x62
; 0000 003B         PORT_COT = key_quet[i];
	RCALL SUBOPT_0x10
; 0000 003C         PR1 = 1;
; 0000 003D         PR2 = 1;
; 0000 003E         PR3 = 1;
; 0000 003F         PR4 = 1;
; 0000 0040         PR5 = 1;
; 0000 0041         if(R1 == 0){
	SBIC 0x13,4
	RJMP _0x6D
; 0000 0042             if(i == 3){
	RCALL SUBOPT_0x11
	BRNE _0x6E
; 0000 0043                 TX_Send(10);
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x12
; 0000 0044                 delay_ms(10);
	RCALL _delay_ms
; 0000 0045                 TX_Send(10);
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x12
; 0000 0046                 delay_ms(10);
	RCALL _delay_ms
; 0000 0047                 TX_Send(10);
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x12
; 0000 0048                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 0049                 clear();
; 0000 004A                 is_start = true;
	LDI  R30,LOW(1)
	STS  _is_start,R30
; 0000 004B                 glcd_clear();
	RCALL _glcd_clear
; 0000 004C                 TIMSK = (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 004D                 glcd_outtextxy(5, 0, "blue");
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x14
	__POINTW2MN _0x6F,0
	RCALL _glcd_outtextxy
; 0000 004E                 glcd_outtextxy(60, 0, "red");
	LDI  R30,LOW(60)
	RCALL SUBOPT_0x14
	__POINTW2MN _0x6F,5
	RCALL _glcd_outtextxy
; 0000 004F                 glcd_line(42, 10, 42, 48);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(48)
	RCALL _glcd_line
; 0000 0050             }
; 0000 0051             else if(i == 0){
	RJMP _0x70
_0x6E:
	RCALL SUBOPT_0x15
	BRNE _0x71
; 0000 0052                 TX_Send(9);
	RCALL SUBOPT_0x16
; 0000 0053                 delay_ms(10);
	RCALL _delay_ms
; 0000 0054                 TX_Send(9);
	RCALL SUBOPT_0x16
; 0000 0055                 delay_ms(10);
	RCALL _delay_ms
; 0000 0056                 TX_Send(9);
	RCALL SUBOPT_0x16
; 0000 0057                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 0058                 clear();
; 0000 0059                 reset();
	RCALL _reset
; 0000 005A             }
; 0000 005B         }
_0x71:
_0x70:
; 0000 005C         else if(R2 == 0 && is_start){
	RJMP _0x72
_0x6D:
	SBIC 0x13,5
	RJMP _0x74
	RCALL SUBOPT_0x17
	BRNE _0x75
_0x74:
	RJMP _0x73
_0x75:
; 0000 005D             if(i == 3){
	RCALL SUBOPT_0x11
	BRNE _0x76
; 0000 005E                 TX_Send(1);
	RCALL SUBOPT_0x18
; 0000 005F                 delay_ms(10);
	RCALL _delay_ms
; 0000 0060                 TX_Send(1);
	RCALL SUBOPT_0x18
; 0000 0061                 delay_ms(10);
	RCALL _delay_ms
; 0000 0062                 TX_Send(1);
	RCALL SUBOPT_0x18
; 0000 0063                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 0064                 clear();
; 0000 0065                 blue_score = pre_blue + 2;
	RCALL SUBOPT_0x19
	ADIW R30,2
	RCALL SUBOPT_0x1A
; 0000 0066                 current_blue = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x1B
; 0000 0067             }
; 0000 0068             else if(i == 0){
	RJMP _0x77
_0x76:
	RCALL SUBOPT_0x15
	BRNE _0x78
; 0000 0069                 TX_Send(5);
	RCALL SUBOPT_0x1C
; 0000 006A                 delay_ms(10);
	RCALL _delay_ms
; 0000 006B                 TX_Send(5);
	RCALL SUBOPT_0x1C
; 0000 006C                 delay_ms(10);
	RCALL _delay_ms
; 0000 006D                 TX_Send(5);
	RCALL SUBOPT_0x1C
; 0000 006E                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 006F                 clear();
; 0000 0070                 red_score = pre_red + 2;
	RCALL SUBOPT_0x1D
	ADIW R30,2
	RCALL SUBOPT_0x1E
; 0000 0071                 current_red = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x1F
; 0000 0072             }
; 0000 0073         }
_0x78:
_0x77:
; 0000 0074         else if(R3 == 0 && is_start){
	RJMP _0x79
_0x73:
	SBIC 0x16,6
	RJMP _0x7B
	RCALL SUBOPT_0x17
	BRNE _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
; 0000 0075             if(i == 3){
	RCALL SUBOPT_0x11
	BRNE _0x7D
; 0000 0076                 TX_Send(2);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x12
; 0000 0077                 delay_ms(10);
	RCALL _delay_ms
; 0000 0078                 TX_Send(2);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x12
; 0000 0079                 delay_ms(10);
	RCALL _delay_ms
; 0000 007A                 TX_Send(2);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x12
; 0000 007B                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 007C                 clear();
; 0000 007D                 blue_score = pre_blue + 3;
	RCALL SUBOPT_0x19
	ADIW R30,3
	RCALL SUBOPT_0x1A
; 0000 007E                 current_blue = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1B
; 0000 007F             }
; 0000 0080             else if(i == 0){
	RJMP _0x7E
_0x7D:
	RCALL SUBOPT_0x15
	BRNE _0x7F
; 0000 0081                 TX_Send(6);
	RCALL SUBOPT_0x20
; 0000 0082                 delay_ms(10);
	RCALL _delay_ms
; 0000 0083                 TX_Send(6);
	RCALL SUBOPT_0x20
; 0000 0084                 delay_ms(10);
	RCALL _delay_ms
; 0000 0085                 TX_Send(6);
	RCALL SUBOPT_0x20
; 0000 0086                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 0087                 clear();
; 0000 0088                 red_score = pre_red + 3;
	RCALL SUBOPT_0x1D
	ADIW R30,3
	RCALL SUBOPT_0x1E
; 0000 0089                 current_red = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1F
; 0000 008A             }
; 0000 008B         }
_0x7F:
_0x7E:
; 0000 008C         else if(R4 == 0 && is_start){
	RJMP _0x80
_0x7A:
	SBIC 0x16,2
	RJMP _0x82
	RCALL SUBOPT_0x17
	BRNE _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 008D             if(i == 3){
	RCALL SUBOPT_0x11
	BRNE _0x84
; 0000 008E                 TX_Send(3);
	RCALL SUBOPT_0x21
; 0000 008F                 delay_ms(10);
	RCALL _delay_ms
; 0000 0090                 TX_Send(3);
	RCALL SUBOPT_0x21
; 0000 0091                 delay_ms(10);
	RCALL _delay_ms
; 0000 0092                 TX_Send(3);
	RCALL SUBOPT_0x21
; 0000 0093                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 0094                 clear();
; 0000 0095                 blue_score = pre_blue + 5;
	RCALL SUBOPT_0x19
	ADIW R30,5
	RCALL SUBOPT_0x1A
; 0000 0096                 current_blue = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x1B
; 0000 0097             }
; 0000 0098             else if(i == 0){
	RJMP _0x85
_0x84:
	RCALL SUBOPT_0x15
	BRNE _0x86
; 0000 0099                 TX_Send(7);
	RCALL SUBOPT_0x22
; 0000 009A                 delay_ms(10);
	RCALL _delay_ms
; 0000 009B                 TX_Send(7);
	RCALL SUBOPT_0x22
; 0000 009C                 delay_ms(10);
	RCALL _delay_ms
; 0000 009D                 TX_Send(7);
	RCALL SUBOPT_0x22
; 0000 009E                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 009F                 clear();
; 0000 00A0                 red_score = pre_red + 5;
	RCALL SUBOPT_0x1D
	ADIW R30,5
	RCALL SUBOPT_0x1E
; 0000 00A1                 current_red = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x1F
; 0000 00A2                 clear();
	RCALL _clear
; 0000 00A3             }
; 0000 00A4         }
_0x86:
_0x85:
; 0000 00A5         else if(R5 == 0 && is_start){
	RJMP _0x87
_0x81:
	SBIC 0x10,0
	RJMP _0x89
	RCALL SUBOPT_0x17
	BRNE _0x8A
_0x89:
	RJMP _0x88
_0x8A:
; 0000 00A6             if(i == 3){
	RCALL SUBOPT_0x11
	BRNE _0x8B
; 0000 00A7                 TX_Send(4);
	RCALL SUBOPT_0x23
; 0000 00A8                 delay_ms(10);
	RCALL _delay_ms
; 0000 00A9                 TX_Send(4);
	RCALL SUBOPT_0x23
; 0000 00AA                 delay_ms(10);
	RCALL _delay_ms
; 0000 00AB                 TX_Send(4);
	RCALL SUBOPT_0x23
; 0000 00AC                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 00AD                 clear();
; 0000 00AE                 blue_score = pre_blue + 10;
	RCALL SUBOPT_0x19
	ADIW R30,10
	RCALL SUBOPT_0x1A
; 0000 00AF                 current_blue = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x1B
; 0000 00B0             }
; 0000 00B1             else if(i == 0){
	RJMP _0x8C
_0x8B:
	RCALL SUBOPT_0x15
	BRNE _0x8D
; 0000 00B2                 TX_Send(8);
	RCALL SUBOPT_0x24
; 0000 00B3                 delay_ms(10);
	RCALL _delay_ms
; 0000 00B4                 TX_Send(8);
	RCALL SUBOPT_0x24
; 0000 00B5                 delay_ms(10);
	RCALL _delay_ms
; 0000 00B6                 TX_Send(8);
	RCALL SUBOPT_0x24
; 0000 00B7                 delay_ms(10);
	RCALL SUBOPT_0x13
; 0000 00B8                 clear();
; 0000 00B9                 red_score = pre_red + 10;
	RCALL SUBOPT_0x1D
	ADIW R30,10
	RCALL SUBOPT_0x1E
; 0000 00BA                 current_red = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x1F
; 0000 00BB             }
; 0000 00BC         }
_0x8D:
_0x8C:
; 0000 00BD     }
_0x88:
_0x87:
_0x80:
_0x79:
_0x72:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x61
_0x62:
; 0000 00BE }
	RET
; .FEND

	.DSEG
_0x6F:
	.BYTE 0x9
;
;bool no_button(){
; 0000 00C0 _Bool no_button(){

	.CSEG
_no_button:
; .FSTART _no_button
; 0000 00C1     for(i=0;i<4;i++){
	CLR  R8
	CLR  R9
_0x8F:
	RCALL SUBOPT_0xF
	BRGE _0x90
; 0000 00C2         PORT_COT = key_quet[i];
	RCALL SUBOPT_0x10
; 0000 00C3         PR1 = 1;
; 0000 00C4         PR2 = 1;
; 0000 00C5         PR3 = 1;
; 0000 00C6         PR4 = 1;
; 0000 00C7         PR5 = 1;
; 0000 00C8         if(R1 == 0 || R2 == 0 || R3 == 0 || R4 == 0 || R5 == 0)
	SBIS 0x13,4
	RJMP _0x9C
	SBIS 0x13,5
	RJMP _0x9C
	SBIS 0x16,6
	RJMP _0x9C
	SBIS 0x16,2
	RJMP _0x9C
	SBIC 0x10,0
	RJMP _0x9B
_0x9C:
; 0000 00C9             return false;
	LDI  R30,LOW(0)
	RET
; 0000 00CA     }
_0x9B:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x8F
_0x90:
; 0000 00CB     return true;
	LDI  R30,LOW(1)
	RET
; 0000 00CC }
; .FEND
;
;interrupt [TIM0_OVF] void timer0_interrupt(){
; 0000 00CE interrupt [10] void timer0_interrupt(){
_timer0_interrupt:
; .FSTART _timer0_interrupt
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00CF     TCNT0 = 0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 00D0     milisecond--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0000 00D1     if(milisecond == 0){
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x9E
; 0000 00D2         second--;
	LDI  R26,LOW(_second)
	LDI  R27,HIGH(_second)
	RCALL SUBOPT_0x25
	SBIW R30,1
	RCALL SUBOPT_0x26
; 0000 00D3         milisecond = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	MOVW R12,R30
; 0000 00D4     }
; 0000 00D5     if(second == 0)
_0x9E:
	RCALL SUBOPT_0x27
	SBIW R30,0
	BRNE _0x9F
; 0000 00D6         reset();
	RCALL _reset
; 0000 00D7 }
_0x9F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00DA {
_main:
; .FSTART _main
; 0000 00DB GLCDINIT_t glcd_init_data;
; 0000 00DC 
; 0000 00DD // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00DE DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(43)
	OUT  0x17,R30
; 0000 00DF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00E0 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00E1 
; 0000 00E2 // Port C initialization
; 0000 00E3 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00E4 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00E5 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00E6 PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(48)
	OUT  0x15,R30
; 0000 00E7 
; 0000 00E8 // Port D initialization
; 0000 00E9 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00EA DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 00EB // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00EC PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(129)
	OUT  0x12,R30
; 0000 00ED 
; 0000 00EE TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00EF TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 00F0 
; 0000 00F1 TIMSK = (0<<TOIE0);
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00F2 
; 0000 00F3 // Specify the current font for displaying text
; 0000 00F4 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00F5 // No function is used for reading
; 0000 00F6 // image data from external memory
; 0000 00F7 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00F8 // No function is used for writing
; 0000 00F9 // image data to external memory
; 0000 00FA glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00FB // Set the LCD temperature coefficient
; 0000 00FC glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 00FD // Set the LCD bias
; 0000 00FE glcd_init_data.bias=4;
	ANDI R30,LOW(0xE3)
	ORI  R30,0x10
	STD  Y+6,R30
; 0000 00FF // Set the LCD contrast control voltage VLCD
; 0000 0100 glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 0101 
; 0000 0102 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0103 
; 0000 0104 #asm("sei")
	sei
; 0000 0105 #asm("wdr")
	wdr
; 0000 0106 
; 0000 0107 Common_Config();
	RCALL _Common_Config
; 0000 0108 delay_us(10);
	RCALL SUBOPT_0xC
; 0000 0109 Common_Init();
	RCALL _Common_Init
; 0000 010A delay_us(10);
	RCALL SUBOPT_0xC
; 0000 010B TX_Config();
	RCALL _TX_Config
; 0000 010C delay_us(10);
	RCALL SUBOPT_0xC
; 0000 010D TX_Mode();
	RCALL _TX_Mode
; 0000 010E 
; 0000 010F glcd_outtextxy(16, 0, "cham diem");
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x14
	__POINTW2MN _0xA0,0
	RCALL _glcd_outtextxy
; 0000 0110 glcd_outtextxy(22, 10, "tu dong");
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2MN _0xA0,10
	RCALL _glcd_outtextxy
; 0000 0111 is_start = false;
	LDI  R30,LOW(0)
	STS  _is_start,R30
; 0000 0112 
; 0000 0113 while (1){
_0xA1:
; 0000 0114     quet_ban_phim();
	RCALL _quet_ban_phim
; 0000 0115     clear();
	RCALL _clear
; 0000 0116     if(no_button()){
	RCALL _no_button
	CPI  R30,0
	BREQ _0xA4
; 0000 0117         pre_blue = blue_score;
	RCALL SUBOPT_0x28
	STS  _pre_blue,R30
	STS  _pre_blue+1,R31
; 0000 0118         pre_red = red_score;
	RCALL SUBOPT_0x29
	STS  _pre_red,R30
	STS  _pre_red+1,R31
; 0000 0119     }
; 0000 011A     if(is_start){
_0xA4:
	RCALL SUBOPT_0x17
	BREQ _0xA5
; 0000 011B         sprintf(buff, "%d ", second);
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x2B
; 0000 011C         glcd_outtextxy(36, 0, buff);
	LDI  R30,LOW(36)
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x2C
; 0000 011D         sprintf(buff, "%d ", blue_score);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2B
; 0000 011E         glcd_outtextxy(12, 40, buff);
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x2D
; 0000 011F         sprintf(buff, "%d ", red_score);
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2B
; 0000 0120         glcd_outtextxy(64, 40, buff);
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x2D
; 0000 0121         sprintf(buff, "%d ", current_blue);
	LDS  R30,_current_blue
	LDS  R31,_current_blue+1
	RCALL SUBOPT_0x2B
; 0000 0122         glcd_outtextxy(12, 24, buff);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(24)
	ST   -Y,R30
	RCALL SUBOPT_0x2C
; 0000 0123         sprintf(buff, "%d ", current_red);
	LDS  R30,_current_red
	LDS  R31,_current_red+1
	RCALL SUBOPT_0x2B
; 0000 0124         glcd_outtextxy(64, 24, buff);
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R30,LOW(24)
	ST   -Y,R30
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _glcd_outtextxy
; 0000 0125 
; 0000 0126     }
; 0000 0127 }
_0xA5:
	RJMP _0xA1
; 0000 0128 }
_0xA6:
	RJMP _0xA6
; .FEND

	.DSEG
_0xA0:
	.BYTE 0x12
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G100:
; .FSTART _pcd8544_delay_G100
	RET
; .FEND
_pcd8544_wrbus_G100:
; .FSTART _pcd8544_wrbus_G100
	RCALL SUBOPT_0x0
	CBI  0x12,2
	LDI  R17,LOW(8)
_0x2000004:
	RCALL _pcd8544_delay_G100
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000006
	SBI  0x12,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x12,4
_0x2000007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G100
	SBI  0x12,5
	RCALL _pcd8544_delay_G100
	CBI  0x12,5
	SUBI R17,LOW(1)
	BRNE _0x2000004
	SBI  0x12,2
	LDD  R17,Y+0
	RJMP _0x2120003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x12,3
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x212000B
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	SBI  0x12,3
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x212000B
; .FEND
_pcd8544_setaddr_G100:
; .FSTART _pcd8544_setaddr_G100
	RCALL SUBOPT_0x0
	LDD  R30,Y+1
	RCALL SUBOPT_0x2E
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	RCALL SUBOPT_0x2F
	STS  _gfx_addr_G100,R30
	STS  _gfx_addr_G100+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	RCALL SUBOPT_0x30
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G100
	ORI  R30,0x40
	RCALL SUBOPT_0x30
	RJMP _0x2120003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G100
	LDS  R31,_gfx_addr_G100+1
	RCALL SUBOPT_0x31
	LD   R30,Z
	RJMP _0x2120003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	RCALL SUBOPT_0x32
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x212000B
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0xE
	RCALL __SAVELOCR4
	SBI  0x11,2
	SBI  0x12,2
	SBI  0x11,5
	CBI  0x12,5
	SBI  0x11,4
	SBI  0x11,3
	SBI  0x11,1
	CBI  0x12,1
	RCALL SUBOPT_0xD
	RCALL _delay_ms
	SBI  0x12,1
	RCALL SUBOPT_0x33
	SBIW R30,0
	BREQ _0x2000008
	RCALL SUBOPT_0x33
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0x33
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	RCALL SUBOPT_0x33
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	RCALL SUBOPT_0x34
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0x35
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x36
	RJMP _0x20000A0
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x37
_0x20000A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	RCALL SUBOPT_0x30
	MOV  R30,R16
	ORI  R30,0x10
	RCALL SUBOPT_0x30
	MOV  R30,R19
	ORI  R30,0x80
	RCALL SUBOPT_0x30
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0x38
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x212000A
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(12)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(8)
_0x200000B:
	RCALL SUBOPT_0x30
_0x212000B:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	RCALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	RCALL SUBOPT_0x9
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x200000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x200000E
_0x2000010:
	RCALL SUBOPT_0x9
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x2120001
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2000012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2000011
_0x2000012:
	RCALL __LOADLOCR2
	RJMP _0x2120004
_0x2000011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2000014
	OR   R17,R16
	RJMP _0x2000015
_0x2000014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	RCALL __LOADLOCR2
	RJMP _0x2120004
; .FEND
_pcd8544_wrmasked_G100:
; .FSTART _pcd8544_wrmasked_G100
	RCALL SUBOPT_0x0
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2000020
	CPI  R30,LOW(0x8)
	BRNE _0x2000021
_0x2000020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2000022
_0x2000021:
	CPI  R30,LOW(0x3)
	BRNE _0x2000024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000025
_0x2000024:
	CPI  R30,0
	BRNE _0x2000026
_0x2000025:
_0x2000022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000027
_0x2000026:
	CPI  R30,LOW(0x2)
	BRNE _0x2000028
_0x2000027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x200001E
_0x2000028:
	CPI  R30,LOW(0x1)
	BRNE _0x2000029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x200001E
_0x2000029:
	CPI  R30,LOW(0x4)
	BRNE _0x200001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x200001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x212000A:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	RCALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x200002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x200002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x200002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x200002B
_0x200002C:
	RJMP _0x2120009
_0x200002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	RCALL SUBOPT_0x39
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x200002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x200002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	RCALL SUBOPT_0x39
	SBIW R26,49
	BRLO _0x200002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x200002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	RJMP _0x2120009
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x2120009
_0x2000036:
_0x2000037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	RCALL SUBOPT_0x2E
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000038
_0x2000039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x3C
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x200003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x200003D
	MOV  R17,R16
_0x200003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000040
	RCALL SUBOPT_0x3D
	RJMP _0x200003E
_0x2000040:
	RJMP _0x200003B
_0x200003D:
_0x2000038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2000041
	LDD  R30,Y+14
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x3C
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2000042
	SUBI R19,-LOW(1)
_0x2000042:
	LDI  R18,LOW(0)
_0x2000043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000045
	LDD  R17,Y+14
_0x2000046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000048
	RCALL SUBOPT_0x3D
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x3C
	RJMP _0x2000043
_0x2000045:
_0x2000041:
_0x2000030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x3C
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x200004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x200004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2000052
	CPI  R30,LOW(0x3)
	BRNE _0x2000053
_0x2000052:
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x7)
	BRNE _0x2000055
_0x2000054:
	RJMP _0x2000056
_0x2000055:
	CPI  R30,LOW(0x8)
	BRNE _0x2000057
_0x2000056:
	RJMP _0x2000058
_0x2000057:
	CPI  R30,LOW(0x9)
	BRNE _0x2000059
_0x2000058:
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x200005A:
	RCALL SUBOPT_0x3F
	RCALL _pcd8544_gotoxy
	RJMP _0x2000050
_0x200005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2000050
	RCALL SUBOPT_0x3F
	RCALL _pcd8544_setaddr_G100
_0x2000050:
_0x200005D:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x200005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2000060
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x32
	LD   R26,Z
	RCALL _glcd_writemem
	RJMP _0x2000061
_0x2000060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000065
	LDI  R21,LOW(0)
	RJMP _0x2000066
_0x2000065:
	CPI  R30,LOW(0xA)
	BRNE _0x2000064
	LDI  R21,LOW(255)
	RJMP _0x2000066
_0x2000064:
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	RCALL SUBOPT_0x43
	MOV  R21,R30
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2000071
	COM  R21
	RJMP _0x2000072
_0x2000071:
	CPI  R30,0
	BRNE _0x2000074
_0x2000072:
_0x200006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G100
	RJMP _0x200006B
_0x2000074:
	RCALL SUBOPT_0x44
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
_0x200006B:
_0x2000061:
	RJMP _0x200005D
_0x200005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000075
_0x200004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000076
_0x200004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000078
_0x2000077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000078:
	ST   -Y,R19
	MOV  R26,R18
	RCALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200007C
	RCALL SUBOPT_0x3F
	RCALL _pcd8544_setaddr_G100
_0x200007D:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	RCALL SUBOPT_0x32
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	RCALL SUBOPT_0x45
	MOV  R30,R19
	MOV  R26,R20
	RCALL __LSRB12
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x38
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x200007D
_0x200007F:
	RJMP _0x200007B
_0x200007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2000080
	LDI  R21,LOW(0)
	RJMP _0x2000081
_0x2000080:
	CPI  R30,LOW(0xA)
	BRNE _0x2000087
	LDI  R21,LOW(255)
_0x2000081:
	RCALL SUBOPT_0x43
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	MOV  R21,R30
_0x2000084:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x2000086
	RCALL SUBOPT_0x44
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000084
_0x2000086:
	RJMP _0x200007B
_0x2000087:
_0x2000088:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x200008A
	RCALL SUBOPT_0x47
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	RCALL SUBOPT_0x48
	RJMP _0x2000088
_0x200008A:
_0x200007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x200008B
	RJMP _0x200004B
_0x200008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x200008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000A1
_0x200008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x3C
_0x2000076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000091
	RCALL SUBOPT_0x3F
	RCALL _pcd8544_setaddr_G100
_0x2000092:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	RCALL SUBOPT_0x32
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSLB12
	RCALL SUBOPT_0x45
	MOV  R30,R18
	MOV  R26,R20
	RCALL __LSLB12
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x38
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x2000092
_0x2000094:
	RJMP _0x2000090
_0x2000091:
	CPI  R30,LOW(0x9)
	BRNE _0x2000095
	LDI  R21,LOW(0)
	RJMP _0x2000096
_0x2000095:
	CPI  R30,LOW(0xA)
	BRNE _0x200009C
	LDI  R21,LOW(255)
_0x2000096:
	RCALL SUBOPT_0x43
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	MOV  R21,R30
_0x2000099:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x200009B
	RCALL SUBOPT_0x44
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000099
_0x200009B:
	RJMP _0x2000090
_0x200009C:
_0x200009D:
	PUSH R17
	RCALL SUBOPT_0x40
	POP  R26
	CP   R26,R30
	BRSH _0x200009F
	RCALL SUBOPT_0x47
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	RCALL SUBOPT_0x48
	RJMP _0x200009D
_0x200009F:
_0x2000090:
_0x2000075:
	LDD  R30,Y+8
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x49
	RJMP _0x2000049
_0x200004B:
_0x2120009:
	RCALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x4A
	BRLT _0x2020003
	RCALL SUBOPT_0x37
	RJMP _0x2120003
_0x2020003:
	RCALL SUBOPT_0x4B
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x2120003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x4A
	BRLT _0x2020005
	RCALL SUBOPT_0x37
	RJMP _0x2120003
_0x2020005:
	RCALL SUBOPT_0x4B
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x2120003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	RCALL SUBOPT_0xE
	SBIW R28,3
	RCALL SUBOPT_0x4C
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	RCALL SUBOPT_0x37
	RJMP _0x2120008
_0x202000B:
	RCALL SUBOPT_0x4D
	STD  Y+7,R0
	RCALL SUBOPT_0x4D
	STD  Y+6,R0
	RCALL SUBOPT_0x4D
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	RCALL SUBOPT_0x37
	RJMP _0x2120008
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	RCALL SUBOPT_0x37
	RJMP _0x2120008
_0x202000D:
	LDD  R30,Y+6
	RCALL SUBOPT_0x2E
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	RCALL SUBOPT_0x3A
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x3A
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120008
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	RCALL SUBOPT_0x3A
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	RCALL SUBOPT_0x4E
	ST   X,R30
	MOVW R30,R16
_0x2120008:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x39
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x39
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x4C
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2120007
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	RCALL SUBOPT_0x2F
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	RCALL SUBOPT_0x50
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x4F
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x50
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x51
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x4F
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x51
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2120007
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2120007:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	RCALL SUBOPT_0xE
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
	RJMP _0x2120004
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
	RJMP _0x2120002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2120003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	RCALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x2120006
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	RCALL SUBOPT_0x52
	BRSH _0x202004B
	RCALL SUBOPT_0x53
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	RCALL SUBOPT_0x52
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	ST   -Y,R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	RCALL SUBOPT_0x52
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	RCALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	RCALL SUBOPT_0x53
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	RCALL SUBOPT_0x54
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x4E
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	RCALL SUBOPT_0x56
_0x2020060:
	RCALL SUBOPT_0x53
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x55
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x4E
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RCALL SUBOPT_0x56
_0x2020065:
	RCALL SUBOPT_0x53
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x2120006:
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	RCALL SUBOPT_0xE
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x58
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x36
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	RCALL SUBOPT_0x58
	ADIW R26,2
	RCALL SUBOPT_0x25
	ADIW R30,1
	RCALL SUBOPT_0x26
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	RCALL SUBOPT_0x58
	RCALL __GETW1P
	TST  R31
	BRMI _0x2060014
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x25
	ADIW R30,1
	RCALL SUBOPT_0x26
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	RCALL SUBOPT_0x58
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	RCALL __LOADLOCR2
	RJMP _0x2120004
; .FEND
__print_G103:
; .FSTART __print_G103
	RCALL SUBOPT_0xE
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x37
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	RCALL SUBOPT_0x59
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	RCALL SUBOPT_0x59
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5A
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x5C
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3E
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3E
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	RCALL SUBOPT_0x3C
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	RCALL SUBOPT_0x3C
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x49
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x49
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x49
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	RCALL SUBOPT_0x59
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x3C
	RJMP _0x2060054
_0x2060053:
	RCALL SUBOPT_0x3E
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	RCALL SUBOPT_0x59
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x3C
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x3B
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x49
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x5C
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	RCALL SUBOPT_0x59
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x5C
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x5F
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120005
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x3C
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x38
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	RCALL SUBOPT_0x38
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	RCALL SUBOPT_0x3E
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120005:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	RCALL SUBOPT_0xE
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120004:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0xE
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0xE
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	RCALL SUBOPT_0x0
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20A0007
	CPI  R30,LOW(0xA)
	BRNE _0x20A0008
_0x20A0007:
	LDS  R17,_glcd_state
	RJMP _0x20A0009
_0x20A0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20A000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20A0009
_0x20A000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20A0005
	__GETBRMN 17,_glcd_state,16
_0x20A0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20A000E
	CPI  R17,0
	BREQ _0x20A000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A000E:
	CPI  R17,0
	BRNE _0x20A0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A0011:
_0x20A0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0xE
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20A0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x20A0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20A0016
	RCALL SUBOPT_0x4B
	RCALL __EEPROMRDB
	RJMP _0x2120002
_0x20A0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20A0018
	RCALL SUBOPT_0x4B
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x20A0018:
	RCALL SUBOPT_0x4B
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20A001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20A001B
_0x20A001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20A001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL __EEPROMWRB
	RJMP _0x20A001B
_0x20A001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20A001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x38
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20A001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_key_quet:
	.BYTE 0x4
_buff:
	.BYTE 0x14
_second:
	.BYTE 0x2
_is_start:
	.BYTE 0x1
_blue_score:
	.BYTE 0x2
_red_score:
	.BYTE 0x2
_current_blue:
	.BYTE 0x2
_current_red:
	.BYTE 0x2
_pre_blue:
	.BYTE 0x2
_pre_red:
	.BYTE 0x2
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G108:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R26
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LD   R26,Y
	RCALL _SPI_Write
	SBI  0x18,1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RJMP _SPI_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	RCALL _SPI_Write
	LD   R26,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	RCALL _SPI_Write
	SBI  0x18,1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	SBI  0x18,1
	__DELAY_USB 27
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	__DELAY_USB 27
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(126)
	RJMP _RF_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(2)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(7)
	ST   -Y,R30
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(10)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_key_quet)
	LDI  R27,HIGH(_key_quet)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	OUT  0x15,R30
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x18,6
	SBI  0x18,2
	SBI  0x12,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x12:
	RCALL _TX_Send
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	RCALL _delay_ms
	RJMP _clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	MOV  R0,R8
	OR   R0,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(9)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LDS  R30,_is_start
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDS  R30,_pre_blue
	LDS  R31,_pre_blue+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	STS  _blue_score,R30
	STS  _blue_score+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	STS  _current_blue,R30
	STS  _current_blue+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(5)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	LDS  R30,_pre_red
	LDS  R31,_pre_red+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	STS  _red_score,R30
	STS  _red_score+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	STS  _current_red,R30
	STS  _current_red+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(6)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(7)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(4)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(8)
	LDI  R27,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDS  R30,_second
	LDS  R31,_second+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDS  R30,_blue_score
	LDS  R31,_blue_score+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDS  R30,_red_score
	LDS  R31,_red_score+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,27
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2B:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(_buff)
	LDI  R27,HIGH(_buff)
	RCALL _glcd_outtextxy
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	MOV  R26,R30
	RJMP _pcd8544_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(_gfx_addr_G100)
	LDI  R27,HIGH(_gfx_addr_G100)
	RCALL SUBOPT_0x25
	ADIW R30,1
	RCALL SUBOPT_0x26
	SBIW R30,1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x38:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3C:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x38
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	ST   -Y,R16
	LDD  R26,Y+16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	SUBI R17,-1
	LDD  R30,Y+14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x41:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x43:
	ST   -Y,R21
	LDD  R26,Y+10
	RJMP _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x44:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x45:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RCALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	COM  R30
	AND  R30,R1
	OR   R21,R30
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x47:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RJMP _pcd8544_wrmasked_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0xE
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4D:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4F:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x38
	LDI  R26,LOW(9)
	RJMP _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x52:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	ST   -Y,R17
	ST   -Y,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x54:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x55:
	RCALL SUBOPT_0x4E
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x57:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x59:
	ST   -Y,R18
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x57
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5B:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5C:
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x57
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	RCALL SUBOPT_0x5A
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
