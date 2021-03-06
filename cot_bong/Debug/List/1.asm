
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
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

	#pragma AVRPART ADMIN PART_NAME ATmega8
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
	.DEF _dem=R10
	.DEF _dem_msb=R11
	.DEF _rc=R12
	.DEF _rc_msb=R13

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
	RJMP _timer0_interrput
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
	.DB  0xC0,0xB1,0x0,0xAB


__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

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
;#include <stdbool.h>
;
;#define tiem_can PIND.3
;#define servo PORTD.2
;#define CE      PORTC.0
;#define SCK     PORTC.2
;#define MISO    PINC.4
;#define CSN     PORTC.1
;#define MOSI    PORTC.3
;#define IRQ     PINC.5
;char Send_Add = 0xB1, Receive_Add = 0xC0, Salt_Add = 0xAB;
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
; 0000 0011 void SPI_Write(unsigned char Buff){

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
	CBI  0x15,3
	RJMP _0x7
_0x6:
	SBI  0x15,3
_0x7:
;        delay_us(5);
	__DELAY_USB 13
;        Buff = (Buff << 1);
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
;        SCK = 1;
	SBI  0x15,2
;        delay_us(5);
	__DELAY_USB 13
;        Buff |= MISO;
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
;        SCK = 0;
	CBI  0x15,2
;    }
	SUBI R17,-1
	RJMP _0x4
_0x5:
;}
	LDD  R17,Y+0
	RJMP _0x2000001
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
	RCALL SUBOPT_0x0
;	command -> Y+0
;    SPI_Write(command);
	RCALL SUBOPT_0x1
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x2000003
; .FEND
;
;
;void RF_Write(unsigned char Reg_Add, unsigned char Value){
_RF_Write:
; .FSTART _RF_Write
;    CSN=0;
	RCALL SUBOPT_0x0
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
	RCALL SUBOPT_0x2
;    SPI_Write(Value);
	RCALL SUBOPT_0x1
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x2000001
; .FEND
;
;void RF_Write_Add(unsigned char Reg_Add, unsigned char Value)         //Function to write a value to a register address
;{
_RF_Write_Add:
; .FSTART _RF_Write_Add
;    CSN=0;
	RCALL SUBOPT_0x0
;	Reg_Add -> Y+1
;	Value -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
	RCALL SUBOPT_0x2
;    SPI_Write(Salt_Add);
	MOV  R26,R7
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	RCALL SUBOPT_0x3
;    SPI_Write(Value);
	RCALL SUBOPT_0x4
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x2000001
; .FEND
;
;void TX_Address(unsigned char Address){
_TX_Address:
; .FSTART _TX_Address
;    CSN=0;
	RCALL SUBOPT_0x0
;	Address -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write
;    CSN=1;
	RCALL SUBOPT_0x5
;    delay_us(10);
;    CSN=0;
;    //RF_Write_Add(RX_ADDR_P0, Address);
;    RF_Write_Add(TX_ADDR, Address);
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _RF_Write_Add
;}
_0x2000003:
	ADIW R28,1
	RET
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
	CBI  0x15,0
;    CSN=1;
	SBI  0x15,1
;    SCK=0;
	CBI  0x15,2
;    delay_us(10);
	__DELAY_USB 27
;    RF_Write(STATUS,0b01111110);
	RCALL SUBOPT_0x6
;    RF_Command(0b11100010);
	LDI  R26,LOW(226)
	RCALL _RF_Command
;    RF_Write(CONFIG,0b00011111);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _RF_Write
;    delay_ms(2);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x7
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
	RJMP _0x2000002
;}
; .FEND
;
;void Common_Init(){
_Common_Init:
; .FSTART _Common_Init
;    CE=1;
	SBI  0x15,0
;    delay_us(700);
	__DELAY_USW 1400
;    CE=0;
	CBI  0x15,0
;    CSN=1;
	SBI  0x15,1
;}
	RET
; .FEND
;
;
;void TX_Mode(){
_TX_Mode:
; .FSTART _TX_Mode
;    CE=0;
	CBI  0x15,0
;    RF_Write(CONFIG,0b00011110);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(30)
_0x2000002:
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
	RCALL SUBOPT_0x6
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
;  CSN=0;//nghe lenh
;    delay_us(10);
;	RF_Write(STATUS,0x70);
;    RF_Write(CONFIG,0b00011110);
;   // RF_Command(0b11100010);
;	delay_us(10);
;        RF_Write(CONFIG,0b00011110);
;
;    CSN=1;
;    delay_ms(10);
;    }
;
;void TX_Send(int diem){
_TX_Send:
; .FSTART _TX_Send
;    TX_Address(Send_Add);
	ST   -Y,R27
	ST   -Y,R26
;	diem -> Y+0
	MOV  R26,R5
	RCALL _TX_Address
;    CSN=1;
	RCALL SUBOPT_0x5
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b11100001);
	LDI  R26,LOW(225)
	RCALL SUBOPT_0x4
;    CSN=1;
;    delay_us(10);
;    CSN=0;
	CBI  0x15,1
;    SPI_Write(0b10100000);
	LDI  R26,LOW(160)
	RCALL SUBOPT_0x3
;    SPI_Write(diem);
	RCALL _SPI_Write
;    CSN=1;
	SBI  0x15,1
;    CE=1;
	SBI  0x15,0
;    delay_us(500);
	__DELAY_USW 1000
;    CE=0;
	CBI  0x15,0
;    RF_Write(0x07,0b01111110);
	RCALL SUBOPT_0x6
;    TX_Address(Send_Add);
	MOV  R26,R5
	RCALL _TX_Address
;    RF_Command(0b11100001);
	LDI  R26,LOW(225)
	RCALL _RF_Command
;}
_0x2000001:
	ADIW R28,2
	RET
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
;int dem, rc;
;
;
;interrupt [TIM0_OVF] void timer0_interrput(){
; 0000 0015 interrupt [10] void timer0_interrput(){
_timer0_interrput:
; .FSTART _timer0_interrput
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0016     TCNT0 = 0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 0017     dem++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0018     if(dem == 200)
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x5A
; 0000 0019         dem = 0;
	CLR  R10
	CLR  R11
; 0000 001A     if(dem < rc)
_0x5A:
	__CPWRR 10,11,12,13
	BRGE _0x5B
; 0000 001B         servo = 1;
	SBI  0x12,2
; 0000 001C     else
	RJMP _0x5E
_0x5B:
; 0000 001D         servo = 0;
	CBI  0x12,2
; 0000 001E }
_0x5E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;
;void main(){
; 0000 0021 void main(){
_main:
; .FSTART _main
; 0000 0022     DDRC = 0b00001110;
	LDI  R30,LOW(14)
	OUT  0x14,R30
; 0000 0023     PORTC = 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 0024 
; 0000 0025     DDRD = 0x04;
	LDI  R30,LOW(4)
	OUT  0x11,R30
; 0000 0026     PORTD = 0x08;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 0027 
; 0000 0028     TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0029     TCNT0=0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 002A 
; 0000 002B 
; 0000 002C     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 002D 
; 0000 002E     Common_Config();
	RCALL _Common_Config
; 0000 002F     delay_us(100);
	RCALL SUBOPT_0x8
; 0000 0030     Common_Init();
	RCALL _Common_Init
; 0000 0031     delay_us(100);
	RCALL SUBOPT_0x8
; 0000 0032     TX_Config();
	RCALL _TX_Config
; 0000 0033     delay_us(100);
	RCALL SUBOPT_0x8
; 0000 0034     TX_Mode();
	RCALL _TX_Mode
; 0000 0035 
; 0000 0036     #asm("sei")
	sei
; 0000 0037     #asm("wdr")
	wdr
; 0000 0038 
; 0000 0039     score = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 003A     rc = 11;
	RCALL SUBOPT_0x9
; 0000 003B     delay_ms(200);
; 0000 003C     while(1){
_0x61:
; 0000 003D       //  TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
; 0000 003E         rc = 11;
	RCALL SUBOPT_0x9
; 0000 003F         delay_ms(200);
; 0000 0040         TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 0041         if(tiem_can == 1){
	SBIS 0x10,3
	RJMP _0x64
; 0000 0042             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0043             TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 0044             rc = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	MOVW R12,R30
; 0000 0045             delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x7
; 0000 0046             TX_Mode();
	RCALL _TX_Mode
; 0000 0047             TX_Config();
	RCALL _TX_Config
; 0000 0048             TX_Send(7);
	RCALL SUBOPT_0xA
; 0000 0049             delay_ms(10);
; 0000 004A             TX_Send(7);
	RCALL SUBOPT_0xA
; 0000 004B             delay_ms(10);
; 0000 004C             TX_Send(7);
	RCALL SUBOPT_0xA
; 0000 004D             delay_ms(10);
; 0000 004E             TX_Send(7);
	RCALL SUBOPT_0xA
; 0000 004F             delay_ms(10);
; 0000 0050             TX_Send(7);
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _TX_Send
; 0000 0051             delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0052             rc = 11;
	RCALL SUBOPT_0x9
; 0000 0053                     delay_ms(200);
; 0000 0054 
; 0000 0055            while(tiem_can == 1);
_0x65:
	SBIC 0x10,3
	RJMP _0x65
; 0000 0056            TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 0057           // clear();
; 0000 0058         }
; 0000 0059 
; 0000 005A     }
_0x64:
	RJMP _0x61
; 0000 005B }
_0x68:
	RJMP _0x68
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	CBI  0x15,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LD   R26,Y
	RCALL _SPI_Write
	SBI  0x15,1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RJMP _SPI_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL _SPI_Write
	LD   R26,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	RCALL _SPI_Write
	SBI  0x15,1
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	SBI  0x15,1
	__DELAY_USB 27
	CBI  0x15,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	RJMP _RF_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R12,R30
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _TX_Send
	LDI  R26,LOW(10)
	RJMP SUBOPT_0x7


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

;END OF CODE MARKER
__END_OF_CODE:
