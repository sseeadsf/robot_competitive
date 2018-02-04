
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
;Global 'const' stored in FLASH: No
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
	.DEF _score=R8
	.DEF _score_msb=R9
	.DEF _milisecond=R6
	.DEF _second=R11
	.DEF _led=R10
	.DEF _red_score=R13
	.DEF _blue_score=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_interrupt
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xB1,0xC0,0x64,0xAB
	.DB  0x0,0x0,0x1,0xB4
	.DB  0x0,0x0

_0x57:
	.DB  0xFE,0xF0,0xED,0xF9,0xF3,0xDB,0xDF,0xF0
	.DB  0xFF,0xFB
_0x58:
	.DB  0x1,0x0,0x1,0x1,0x0,0x1,0x1,0x1
	.DB  0x1,0x1
_0x59:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _number
	.DW  _0x57*2

	.DW  0x0A
	.DW  _numberA
	.DW  _0x58*2

	.DW  0x01
	.DW  _time_out
	.DW  _0x59*2

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
;#include <io.h>
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
;#include <delay.h>
;#include <string.h>
;#include <stdbool.h>
;
;#define LED_SEG             PORTB
;#define LED_A               PORTC.0
;#define LED_TIME1           PORTD.7
;#define LED_TIME2           PORTD.6
;#define LED_TIME3           PORTD.5
;#define LED_RED_SCORE1      PORTD.4
;#define LED_RED_SCORE2      PORTB.6
;#define LED_RED_SCORE3      PORTB.7
;#define LED_BLUE_SCORE1     PORTD.1
;#define LED_BLUE_SCORE2     PORTD.2
;#define LED_BLUE_SCORE3     PORTD.3
;
;#define CE                  PORTD.0
;#define CSN                 PORTC.1
;#define SCK                 PORTC.5
;#define MOSI                PORTC.2
;#define MISO                PINC.4
;#define IRQ                 PINC.3
;char Send_Add = 0xC0, Receive_Add = 0xB1, Salt_Add = 0xAB;
;int score;
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
; 0000 001B void SPI_Write(unsigned char Buff){

	.CSEG
_SPI_Write:
; .FSTART _SPI_Write
;    unsigned char bit_ctr;
;    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
	ST   -Y,R26
	ST   -Y,R17
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
	CBI  0x15,2
	RJMP _0x7
_0x6:
	SBI  0x15,2
_0x7:
;        delay_us(5);
	RCALL SUBOPT_0x0
;        Buff = (Buff << 1);
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
;        SCK = 1;
	RCALL SUBOPT_0x1
;        delay_us(5);
;        Buff |= MISO;
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
;        SCK = 0;
	CBI  0x15,5
;    }
	SUBI R17,-1
	RJMP _0x4
_0x5:
;}
	LDD  R17,Y+0
	RJMP _0x2020004
; .FEND
;
;unsigned char SPI_Read(void){
_SPI_Read:
; .FSTART _SPI_Read
;    unsigned char Buff=0;
;    unsigned char bit_ctr;
;    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
	RCALL __SAVELOCR2
;	Buff -> R17
;	bit_ctr -> R16
	LDI  R17,0
	LDI  R16,LOW(0)
_0xD:
	CPI  R16,8
	BRSH _0xE
;        delay_us(5);
	RCALL SUBOPT_0x0
;        Buff = (Buff << 1);
	LSL  R17
;        SCK = 1;
	RCALL SUBOPT_0x1
;        delay_us(5);
;        Buff |= MISO;
	OR   R17,R30
;        SCK = 0;
	CBI  0x15,5
;    }
	SUBI R16,-1
	RJMP _0xD
_0xE:
;    return(Buff);
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
;}
; .FEND
;
;
;void RF_Command(unsigned char command){
_RF_Command:
; .FSTART _RF_Command
;    CSN=0;
	RCALL SUBOPT_0x2
;	command -> Y+0
;    SPI_Write(command);
	RCALL SUBOPT_0x3
;    CSN=1;
	RCALL SUBOPT_0x4
;    delay_us(10);
;}
	RJMP _0x2020002
; .FEND
;
;
;void RF_Write(unsigned char Reg_Add, unsigned char Value){
_RF_Write:
; .FSTART _RF_Write
;    CSN=0;
	RCALL SUBOPT_0x2
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RJMP _0x2020003
;    SPI_Write(Value);
;    CSN=1;
;    delay_us(10);
;}
; .FEND
;
;void RF_Write_Add(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register address
;{
_RF_Write_Add:
; .FSTART _RF_Write_Add
;    CSN=0;
	RCALL SUBOPT_0x2
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RCALL _SPI_Write
;    SPI_Write(Salt_Add);
	MOV  R26,R7
	RCALL _SPI_Write
;    SPI_Write(Value);
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	LD   R26,Y
_0x2020003:
	RCALL _SPI_Write
;    SPI_Write(Value);
	RCALL SUBOPT_0x3
;    CSN=1;
	RCALL SUBOPT_0x4
;    delay_us(10);
;}
_0x2020004:
	ADIW R28,2
	RET
; .FEND
;
;void TX_Address(unsigned char Address){
;    CSN=0;
;	Address -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    //RF_Write_Add(RX_ADDR_P0, Address);
;    RF_Write_Add(TX_ADDR, Address);
;}
;
;void RX_Address(unsigned char Address){
_RX_Address:
; .FSTART _RX_Address
;    CSN=0;
	RCALL SUBOPT_0x2
;	Address -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write
;    CSN=1;
	RCALL SUBOPT_0x4
;    delay_us(10);
;    CSN=0;
	CBI  0x15,1
;    RF_Write_Add(RX_ADDR_P0, Address);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _RF_Write_Add
;    //RF_Write_Add(RX_PW_P0, Address);
;}
	RJMP _0x2020002
; .FEND
;
;
;void Common_Config(){
_Common_Config:
; .FSTART _Common_Config
;    CE=0;
	CBI  0x12,0
;    CSN=1;
	SBI  0x15,1
;    SCK=0;
	CBI  0x15,5
;    delay_us(10);
	RCALL SUBOPT_0x5
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0x6
;    RF_Command(0b11100010);
	LDI  R26,LOW(226)
	RCALL _RF_Command
;    RF_Write(CONFIG,0b00011111);
	RCALL SUBOPT_0x7
;    delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0x6
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
;	RF_Write(0x11,0b00000001);
	LDI  R30,LOW(17)
	RCALL SUBOPT_0x8
;    RF_Write(RF_SETUP, 0b00000110);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL _RF_Write
;    RF_Write(DYNPD,0b00000001);
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x8
;    RF_Write(EN_RXADDR,0b00000001);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x8
;}
	RET
; .FEND
;
;void Common_Init(){
_Common_Init:
; .FSTART _Common_Init
;    CE=1;
	SBI  0x12,0
;    delay_us(700);
	__DELAY_USW 1400
;    CE=0;
	CBI  0x12,0
;    CSN=1;
	SBI  0x15,1
;}
	RET
; .FEND
;
;
;void TX_Mode(){
;    CE=0;
;    RF_Write(CONFIG,0b00011110);
;}
;
;void RX_Mode(){
_RX_Mode:
; .FSTART _RX_Mode
;    RF_Write(CONFIG,0b00011111);
	RCALL SUBOPT_0x7
;    CE=1;
	SBI  0x12,0
;}
	RET
; .FEND
;
;void TX_Config(){
;    RF_Write(STATUS,0b01111110);
;    RF_Command(0b11100010);
;    TX_Address(Send_Add);
;}
;
;void RX_Config(){
_RX_Config:
; .FSTART _RX_Config
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0x6
;    RF_Command(0b11100010);
	LDI  R26,LOW(226)
	RCALL _RF_Command
;    RX_Address(Receive_Add);
	MOV  R26,R4
	RCALL _RX_Address
;}
	RET
; .FEND
;
;void clear(){
;    CSN=0;//nghe lenh
;    delay_us(10);
;	RF_Write(STATUS,0x70);
;    RF_Write(CONFIG,0b00011110);
;	delay_us(10);
;    RF_Write(CONFIG,0b00011110);
;    CSN=1;
;    delay_ms(10);
;}
;
;void TX_Send(){
;    TX_Address(Send_Add);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b11100001);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b10100000);
;    SPI_Write(score);
;    CSN=1;
;    CE=1;
;    delay_us(500);
;    CE=0;
;    RF_Write(0x07,0b01111110);
;    TX_Address(Send_Add);
;    RF_Command(0b11100001);
;}
;
;void RX_Read(){
_RX_Read:
; .FSTART _RX_Read
;    CE=0;
	CBI  0x12,0
;    CSN=1;
	RCALL SUBOPT_0x4
;    delay_us(10);
;    CSN=0;
	CBI  0x15,1
;    SPI_Write(0b01100001);
	LDI  R26,LOW(97)
	RCALL _SPI_Write
;    delay_us(10);
	RCALL SUBOPT_0x5
;    score = SPI_Read();
	RCALL _SPI_Read
	MOV  R8,R30
	CLR  R9
;    CSN=1;
	SBI  0x15,1
;    CE=1;
	SBI  0x12,0
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0x6
;    RF_Command(0b11100010);
	LDI  R26,LOW(226)
	RCALL _RF_Command
;}
	RET
; .FEND
;
;unsigned char number[10] = {0xFE, 0xF0, 0xED, 0xF9, 0xF3, 0xDB, 0xDF, 0xF0, 0xFF, 0xFB};

	.DSEG
;unsigned char numberA[10] = {1, 0, 1, 1, 0, 1, 1, 1, 1, 1};
;unsigned char milisecond = 100, second = 180;
;unsigned char led = 1;
;unsigned char red_score = 0b0000;
;unsigned char blue_score = 0b0000;
;int red_scores = 0, blue_scores = 0;
;bool time_out = true;
;int a;
;
;bool check_finish(unsigned char input){
; 0000 0027 _Bool check_finish(unsigned char input){

	.CSEG
_check_finish:
; .FSTART _check_finish
; 0000 0028     if(input == 0b1111)
	ST   -Y,R26
;	input -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0x5A
; 0000 0029         return true;
	LDI  R30,LOW(1)
	RJMP _0x2020002
; 0000 002A     else
_0x5A:
; 0000 002B         return false;
	LDI  R30,LOW(0)
; 0000 002C }
_0x2020002:
	ADIW R28,1
	RET
; .FEND
;
;void get_score(){
; 0000 002E void get_score(){
_get_score:
; .FSTART _get_score
; 0000 002F     if(score == 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x9
	BRNE _0x5C
; 0000 0030         blue_scores += 2;
	RCALL SUBOPT_0xA
	ADIW R30,2
	RCALL SUBOPT_0xB
; 0000 0031         blue_score |= 0b0001;
	LDI  R30,LOW(1)
	OR   R12,R30
; 0000 0032     }
; 0000 0033     else if(score == 2){
	RJMP _0x5D
_0x5C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x9
	BRNE _0x5E
; 0000 0034         blue_scores += 3;
	RCALL SUBOPT_0xA
	ADIW R30,3
	RCALL SUBOPT_0xB
; 0000 0035         blue_score |= 0b0010;
	LDI  R30,LOW(2)
	OR   R12,R30
; 0000 0036     }
; 0000 0037     else if(score == 3){
	RJMP _0x5F
_0x5E:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x9
	BRNE _0x60
; 0000 0038         blue_scores += 5;
	RCALL SUBOPT_0xA
	ADIW R30,5
	RCALL SUBOPT_0xB
; 0000 0039         blue_score |= 0b0100;
	LDI  R30,LOW(4)
	OR   R12,R30
; 0000 003A     }
; 0000 003B     else if(score == 4){
	RJMP _0x61
_0x60:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x9
	BRNE _0x62
; 0000 003C         blue_scores += 10;
	RCALL SUBOPT_0xA
	ADIW R30,10
	RCALL SUBOPT_0xB
; 0000 003D         blue_score |= 0b1000;
	LDI  R30,LOW(8)
	OR   R12,R30
; 0000 003E     }
; 0000 003F     else if(score == 5){
	RJMP _0x63
_0x62:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x9
	BRNE _0x64
; 0000 0040         red_scores += 2;
	RCALL SUBOPT_0xC
	ADIW R30,2
	RCALL SUBOPT_0xD
; 0000 0041         red_score |= 0b0001;
	LDI  R30,LOW(1)
	RJMP _0x141
; 0000 0042     }
; 0000 0043     else if(score == 6){
_0x64:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x9
	BRNE _0x66
; 0000 0044         red_scores += 3;
	RCALL SUBOPT_0xC
	ADIW R30,3
	RCALL SUBOPT_0xD
; 0000 0045         red_score |= 0b0010;
	LDI  R30,LOW(2)
	RJMP _0x141
; 0000 0046     }
; 0000 0047     else if(score == 7){
_0x66:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x9
	BRNE _0x68
; 0000 0048         red_scores += 5;
	RCALL SUBOPT_0xC
	ADIW R30,5
	RCALL SUBOPT_0xD
; 0000 0049         red_score |= 0b0100;
	LDI  R30,LOW(4)
	RJMP _0x141
; 0000 004A     }
; 0000 004B     else if(score == 8){
_0x68:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x9
	BRNE _0x6A
; 0000 004C         red_scores += 10;
	RCALL SUBOPT_0xC
	ADIW R30,10
	RCALL SUBOPT_0xD
; 0000 004D         red_score |= 0b1000;
	LDI  R30,LOW(8)
_0x141:
	OR   R13,R30
; 0000 004E     }
; 0000 004F }
_0x6A:
_0x63:
_0x61:
_0x5F:
_0x5D:
	RET
; .FEND
;
;void stop_game(){
; 0000 0051 void stop_game(){
_stop_game:
; .FSTART _stop_game
; 0000 0052     time_out = true;
	LDI  R30,LOW(1)
	STS  _time_out,R30
; 0000 0053     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(5)
	RJMP _0x2020001
; 0000 0054 }
; .FEND
;
;void start_game(){
; 0000 0056 void start_game(){
_start_game:
; .FSTART _start_game
; 0000 0057     time_out = false;
	LDI  R30,LOW(0)
	STS  _time_out,R30
; 0000 0058     TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(69)
_0x2020001:
	OUT  0x39,R30
; 0000 0059 }
	RET
; .FEND
;
;void reset_game(){
; 0000 005B void reset_game(){
_reset_game:
; .FSTART _reset_game
; 0000 005C     WDTCR=0x18;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 005D     WDTCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x21,R30
; 0000 005E     while(1);
_0x6B:
	RJMP _0x6B
; 0000 005F }
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0061 interrupt [10] void timer0_ovf_isr(void){
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0062     TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0063     if(led == 1){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x6E
; 0000 0064         LED_SEG = number[second/100];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
; 0000 0065         LED_A = numberA[second/100];
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x10
	BRNE _0x6F
	CBI  0x15,0
	RJMP _0x70
_0x6F:
	SBI  0x15,0
_0x70:
; 0000 0066         LED_TIME1 =         0;
	CBI  0x12,7
; 0000 0067         LED_TIME2 =         1;
	RCALL SUBOPT_0x11
; 0000 0068         LED_TIME3 =         1;
; 0000 0069         LED_RED_SCORE1 =    1;
	RCALL SUBOPT_0x12
; 0000 006A         LED_RED_SCORE2 =    1;
; 0000 006B         LED_RED_SCORE3 =    1;
; 0000 006C         LED_BLUE_SCORE1 =   1;
; 0000 006D         LED_BLUE_SCORE2 =   1;
; 0000 006E         LED_BLUE_SCORE3 =   1;
; 0000 006F 
; 0000 0070     }
; 0000 0071 
; 0000 0072     else if(led == 2){
	RJMP _0x83
_0x6E:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x84
; 0000 0073         LED_SEG = number[(second%100)/10];
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xF
; 0000 0074         LED_A = numberA[(second%100)/10];
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x10
	BRNE _0x85
	CBI  0x15,0
	RJMP _0x86
_0x85:
	SBI  0x15,0
_0x86:
; 0000 0075         LED_TIME1 =         1;
	SBI  0x12,7
; 0000 0076         LED_TIME2 =         0;
	CBI  0x12,6
; 0000 0077         LED_TIME3 =         1;
	SBI  0x12,5
; 0000 0078         LED_RED_SCORE1 =    1;
	RCALL SUBOPT_0x12
; 0000 0079         LED_RED_SCORE2 =    1;
; 0000 007A         LED_RED_SCORE3 =    1;
; 0000 007B         LED_BLUE_SCORE1 =   1;
; 0000 007C         LED_BLUE_SCORE2 =   1;
; 0000 007D         LED_BLUE_SCORE3 =   1;
; 0000 007E     }
; 0000 007F 
; 0000 0080     else if(led == 3){
	RJMP _0x99
_0x84:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x9A
; 0000 0081         LED_SEG = number[second%10];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xF
; 0000 0082         LED_A = numberA[second%10];
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x10
	BRNE _0x9B
	CBI  0x15,0
	RJMP _0x9C
_0x9B:
	SBI  0x15,0
_0x9C:
; 0000 0083         LED_TIME1 =         1;
	SBI  0x12,7
; 0000 0084         LED_TIME2 =         1;
	SBI  0x12,6
; 0000 0085         LED_TIME3 =         0;
	CBI  0x12,5
; 0000 0086         LED_RED_SCORE1 =    1;
	RCALL SUBOPT_0x12
; 0000 0087         LED_RED_SCORE2 =    1;
; 0000 0088         LED_RED_SCORE3 =    1;
; 0000 0089         LED_BLUE_SCORE1 =   1;
; 0000 008A         LED_BLUE_SCORE2 =   1;
; 0000 008B         LED_BLUE_SCORE3 =   1;
; 0000 008C     }
; 0000 008D 
; 0000 008E     else if(led == 4){
	RJMP _0xAF
_0x9A:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xB0
; 0000 008F         LED_SEG = number[red_scores/100];
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xF
; 0000 0090         LED_A = numberA[red_scores/100];
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	BRNE _0xB1
	CBI  0x15,0
	RJMP _0xB2
_0xB1:
	SBI  0x15,0
_0xB2:
; 0000 0091         LED_TIME1 =         1;
	RCALL SUBOPT_0x16
; 0000 0092         LED_TIME2 =         1;
; 0000 0093         LED_TIME3 =         1;
; 0000 0094         LED_RED_SCORE1 =    0;
	CBI  0x12,4
; 0000 0095         LED_RED_SCORE2 =    1;
	RCALL SUBOPT_0x17
; 0000 0096         LED_RED_SCORE3 =    1;
; 0000 0097         LED_BLUE_SCORE1 =   1;
	RCALL SUBOPT_0x18
; 0000 0098         LED_BLUE_SCORE2 =   1;
; 0000 0099         LED_BLUE_SCORE3 =   1;
; 0000 009A     }
; 0000 009B 
; 0000 009C     else if(led == 5){
	RJMP _0xC5
_0xB0:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0xC6
; 0000 009D         LED_SEG = number[(red_scores%100)/10];
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0xF
; 0000 009E         LED_A = numberA[(red_scores%100)/10];
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x10
	BRNE _0xC7
	CBI  0x15,0
	RJMP _0xC8
_0xC7:
	SBI  0x15,0
_0xC8:
; 0000 009F         LED_TIME1 =         1;
	RCALL SUBOPT_0x16
; 0000 00A0         LED_TIME2 =         1;
; 0000 00A1         LED_TIME3 =         1;
; 0000 00A2         LED_RED_SCORE1 =    1;
	SBI  0x12,4
; 0000 00A3         LED_RED_SCORE2 =    0;
	CBI  0x18,6
; 0000 00A4         LED_RED_SCORE3 =    1;
	SBI  0x18,7
; 0000 00A5         LED_BLUE_SCORE1 =   1;
	RCALL SUBOPT_0x18
; 0000 00A6         LED_BLUE_SCORE2 =   1;
; 0000 00A7         LED_BLUE_SCORE3 =   1;
; 0000 00A8     }
; 0000 00A9 
; 0000 00AA     else if(led == 6){
	RJMP _0xDB
_0xC6:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0xDC
; 0000 00AB         LED_SEG = number[red_scores%10];
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0xF
; 0000 00AC         LED_A = numberA[red_scores%10];
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x10
	BRNE _0xDD
	CBI  0x15,0
	RJMP _0xDE
_0xDD:
	SBI  0x15,0
_0xDE:
; 0000 00AD         LED_TIME1 =         1;
	RCALL SUBOPT_0x16
; 0000 00AE         LED_TIME2 =         1;
; 0000 00AF         LED_TIME3 =         1;
; 0000 00B0         LED_RED_SCORE1 =    1;
	SBI  0x12,4
; 0000 00B1         LED_RED_SCORE2 =    1;
	SBI  0x18,6
; 0000 00B2         LED_RED_SCORE3 =    0;
	CBI  0x18,7
; 0000 00B3         LED_BLUE_SCORE1 =   1;
	RCALL SUBOPT_0x18
; 0000 00B4         LED_BLUE_SCORE2 =   1;
; 0000 00B5         LED_BLUE_SCORE3 =   1;
; 0000 00B6     }
; 0000 00B7 
; 0000 00B8     else if(led == 7){
	RJMP _0xF1
_0xDC:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0xF2
; 0000 00B9         LED_SEG = number[blue_scores/100];
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0xF
; 0000 00BA         LED_A = numberA[blue_scores/100];
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x10
	BRNE _0xF3
	CBI  0x15,0
	RJMP _0xF4
_0xF3:
	SBI  0x15,0
_0xF4:
; 0000 00BB         LED_TIME1 =         1;
	RCALL SUBOPT_0x16
; 0000 00BC         LED_TIME2 =         1;
; 0000 00BD         LED_TIME3 =         1;
; 0000 00BE         LED_RED_SCORE1 =    1;
	SBI  0x12,4
; 0000 00BF         LED_RED_SCORE2 =    1;
	RCALL SUBOPT_0x17
; 0000 00C0         LED_RED_SCORE3 =    1;
; 0000 00C1         LED_BLUE_SCORE1 =   0;
	CBI  0x12,1
; 0000 00C2         LED_BLUE_SCORE2 =   1;
	SBI  0x12,2
; 0000 00C3         LED_BLUE_SCORE3 =   1;
	SBI  0x12,3
; 0000 00C4     }
; 0000 00C5 
; 0000 00C6     else if(led == 8){
	RJMP _0x107
_0xF2:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x108
; 0000 00C7         LED_SEG = number[(blue_scores%100)/10];
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0xF
; 0000 00C8         LED_A = numberA[(blue_scores%100)/10];
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x10
	BRNE _0x109
	CBI  0x15,0
	RJMP _0x10A
_0x109:
	SBI  0x15,0
_0x10A:
; 0000 00C9         LED_TIME1 =         1;
	RCALL SUBOPT_0x16
; 0000 00CA         LED_TIME2 =         1;
; 0000 00CB         LED_TIME3 =         1;
; 0000 00CC         LED_RED_SCORE1 =    1;
	SBI  0x12,4
; 0000 00CD         LED_RED_SCORE2 =    1;
	RCALL SUBOPT_0x17
; 0000 00CE         LED_RED_SCORE3 =    1;
; 0000 00CF         LED_BLUE_SCORE1 =   1;
	SBI  0x12,1
; 0000 00D0         LED_BLUE_SCORE2 =   0;
	CBI  0x12,2
; 0000 00D1         LED_BLUE_SCORE3 =   1;
	SBI  0x12,3
; 0000 00D2     }
; 0000 00D3 
; 0000 00D4     else if(led == 9){
	RJMP _0x11D
_0x108:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0x11E
; 0000 00D5         LED_SEG = number[blue_scores%10];
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0xF
; 0000 00D6         LED_A = numberA[blue_scores%10];
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x10
	BRNE _0x11F
	CBI  0x15,0
	RJMP _0x120
_0x11F:
	SBI  0x15,0
_0x120:
; 0000 00D7         LED_TIME1 =         1;
	RCALL SUBOPT_0x16
; 0000 00D8         LED_TIME2 =         1;
; 0000 00D9         LED_TIME3 =         1;
; 0000 00DA         LED_RED_SCORE1 =    1;
	SBI  0x12,4
; 0000 00DB         LED_RED_SCORE2 =    1;
	RCALL SUBOPT_0x17
; 0000 00DC         LED_RED_SCORE3 =    1;
; 0000 00DD         LED_BLUE_SCORE1 =   1;
	SBI  0x12,1
; 0000 00DE         LED_BLUE_SCORE2 =   1;
	SBI  0x12,2
; 0000 00DF         LED_BLUE_SCORE3 =   0;
	CBI  0x12,3
; 0000 00E0         led = 0;
	CLR  R10
; 0000 00E1     }
; 0000 00E2 
; 0000 00E3     led++;
_0x11E:
_0x11D:
_0x107:
_0xF1:
_0xDB:
_0xC5:
_0xAF:
_0x99:
_0x83:
	INC  R10
; 0000 00E4 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM2_OVF] void timer2_interrupt(){
; 0000 00E6 interrupt [5] void timer2_interrupt(){
_timer2_interrupt:
; .FSTART _timer2_interrupt
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
; 0000 00E7     TCNT2 = 0xB2;
	LDI  R30,LOW(178)
	OUT  0x24,R30
; 0000 00E8     milisecond--;
	DEC  R6
; 0000 00E9     a++;
	LDI  R26,LOW(_a)
	LDI  R27,HIGH(_a)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00EA     if(a == 40)
	LDS  R26,_a
	LDS  R27,_a+1
	SBIW R26,40
	BRNE _0x133
; 0000 00EB         a = 0;
	LDI  R30,LOW(0)
	STS  _a,R30
	STS  _a+1,R30
; 0000 00EC 
; 0000 00ED     if(milisecond == 0){
_0x133:
	TST  R6
	BRNE _0x134
; 0000 00EE         second--;
	DEC  R11
; 0000 00EF         milisecond = 100;
	LDI  R30,LOW(100)
	MOV  R6,R30
; 0000 00F0     }
; 0000 00F1     if(second == 0){
_0x134:
	TST  R11
	BRNE _0x135
; 0000 00F2         stop_game();
	RCALL _stop_game
; 0000 00F3     }
; 0000 00F4 }
_0x135:
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
;void main(void){
; 0000 00F6 void main(void){
_main:
; .FSTART _main
; 0000 00F7 
; 0000 00F8 DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00F9 PORTB= 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00FA 
; 0000 00FB DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00FC PORTD= 0xFF;
	OUT  0x12,R30
; 0000 00FD 
; 0000 00FE DDRC = 0x27;
	LDI  R30,LOW(39)
	OUT  0x14,R30
; 0000 00FF PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0100 
; 0000 0101 
; 0000 0102 TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0103 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0104 
; 0000 0105 
; 0000 0106 //10ms
; 0000 0107 ASSR=0<<AS2;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 0108 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(7)
	OUT  0x25,R30
; 0000 0109 TCNT2=0xB2;
	LDI  R30,LOW(178)
	OUT  0x24,R30
; 0000 010A OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 010B 
; 0000 010C 
; 0000 010D TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 010E 
; 0000 010F #asm("sei")
	sei
; 0000 0110 
; 0000 0111 Common_Config();
	RCALL _Common_Config
; 0000 0112 delay_us(10);
	RCALL SUBOPT_0x5
; 0000 0113 Common_Init();
	RCALL _Common_Init
; 0000 0114 delay_us(10);
	RCALL SUBOPT_0x5
; 0000 0115 RX_Config();
	RCALL _RX_Config
; 0000 0116 delay_us(10);
	RCALL SUBOPT_0x5
; 0000 0117 RX_Mode();
	RCALL _RX_Mode
; 0000 0118 
; 0000 0119 
; 0000 011A while (1){
_0x136:
; 0000 011B     if(IRQ == 0){
	SBIC 0x13,3
	RJMP _0x139
; 0000 011C         RX_Read();
	RCALL _RX_Read
; 0000 011D         if(score == 9)
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x9
	BRNE _0x13A
; 0000 011E             reset_game();
	RCALL _reset_game
; 0000 011F         else if(score == 10){
	RJMP _0x13B
_0x13A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x9
	BRNE _0x13C
; 0000 0120             start_game();
	RCALL _start_game
; 0000 0121             RX_Config();
	RCALL _RX_Config
; 0000 0122         }
; 0000 0123         if(!time_out){
_0x13C:
_0x13B:
	LDS  R30,_time_out
	CPI  R30,0
	BRNE _0x13D
; 0000 0124             get_score();
	RCALL _get_score
; 0000 0125             delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0126         }
; 0000 0127 
; 0000 0128         if(check_finish(red_score)){
_0x13D:
	MOV  R26,R13
	RCALL _check_finish
	CPI  R30,0
	BREQ _0x13E
; 0000 0129             TIMSK = (0<<TOIE2) | (1<<TOIE0);
	RCALL SUBOPT_0x1E
; 0000 012A             red_scores = 999;
	RCALL SUBOPT_0xD
; 0000 012B             stop_game();
	RCALL _stop_game
; 0000 012C         }
; 0000 012D         if(check_finish(blue_score)){
_0x13E:
	MOV  R26,R12
	RCALL _check_finish
	CPI  R30,0
	BREQ _0x13F
; 0000 012E             TIMSK = (0<<TOIE2) | (1<<TOIE0);
	RCALL SUBOPT_0x1E
; 0000 012F             blue_scores = 999;
	RCALL SUBOPT_0xB
; 0000 0130             stop_game();
	RCALL _stop_game
; 0000 0131         }
; 0000 0132         RX_Config();
_0x13F:
	RCALL _RX_Config
; 0000 0133     }
; 0000 0134 }
_0x139:
	RJMP _0x136
; 0000 0135 }
_0x140:
	RJMP _0x140
; .FEND

	.CSEG

	.DSEG
_number:
	.BYTE 0xA
_numberA:
	.BYTE 0xA
_red_scores:
	.BYTE 0x2
_blue_scores:
	.BYTE 0x2
_time_out:
	.BYTE 0x1
_a:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	SBI  0x15,5
	RCALL SUBOPT_0x0
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R26
	CBI  0x15,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LD   R26,Y
	RJMP _SPI_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	SBI  0x15,1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	RJMP _RF_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RJMP _RF_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _RF_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDS  R30,_blue_scores
	LDS  R31,_blue_scores+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	STS  _blue_scores,R30
	STS  _blue_scores+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDS  R30,_red_scores
	LDS  R31,_red_scores+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	STS  _red_scores,R30
	STS  _red_scores+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	MOV  R26,R11
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(-_number)
	SBCI R31,HIGH(-_number)
	LD   R30,Z
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x10:
	SUBI R30,LOW(-_numberA)
	SBCI R31,HIGH(-_numberA)
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	SBI  0x12,6
	SBI  0x12,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	SBI  0x12,4
	SBI  0x18,6
	SBI  0x18,7
	SBI  0x12,1
	SBI  0x12,2
	SBI  0x12,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	MOV  R26,R11
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	MOV  R26,R11
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	LDS  R26,_red_scores
	LDS  R27,_red_scores+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	SBI  0x12,7
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	SBI  0x18,6
	SBI  0x18,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	SBI  0x12,1
	SBI  0x12,2
	SBI  0x12,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	LDS  R26,_red_scores
	LDS  R27,_red_scores+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	LDS  R26,_red_scores
	LDS  R27,_red_scores+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDS  R26,_blue_scores
	LDS  R27,_blue_scores+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1C:
	LDS  R26,_blue_scores
	LDS  R27,_blue_scores+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDS  R26,_blue_scores
	LDS  R27,_blue_scores+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(1)
	OUT  0x39,R30
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
