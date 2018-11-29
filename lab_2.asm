.include "m16def.inc"

.cseg

.def temp = r19
.def pwd = r20
.def SW4 = r23
.def SW3 = r24
.def SW2 = r25
.def SW1 = r26
.def pwd_check = r27
.def temp2 = r28
.def counter = r29
.def flag = r30

LDI counter, 0
LDI temp,0
out DDRD,temp; setting the D ports as INPUTS
LDI temp, 0xFF
out DDRB, temp; setting the B ports as OUTPUTS
out PORTB, temp; Ensuring that with the start of the program, all LEDs are switched off.

	


Insert_Code:	
				IN pwd, PIND
				ANDI pwd, 0x8F
				OR r21, pwd
				ANDI r21, 0x80
				CPI r21, 0x80
				BREQ Alarm_Code
				BRNE Insert_Code


Alarm_Code:
				IN r22, PIND
				ANDI r22, 1
				CPI r22, 1
				BREQ Alarm_ON
				BRNE Alarm_Code

Alarm_ON:
				OUT PORTB, r22
				LSR pwd
				OR SW4, pwd
				ANDI SW4, 0x8
				OR SW3, pwd
				ANDI SW3, 0x4
				OR SW2, pwd
				ANDI SW2, 0x2
				OR SW1, pwd
				ANDI SW1, 1
				rjmp Alarm_Check

Alarm_Check:
				ORI temp, 0
				IN temp, PIND
				OR temp2, temp; Save the inputs of PIND to a temp2
				AND temp, SW4
				OR pwd_check, pwd
				ANDI pwd_check, 0x8

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ PWD_SW3

PWD_SW3:		
				ORI temp, 0
				OR temp, temp2
				AND temp, SW3
				LDI pwd_check, 0
				OR pwd_check, pwd
				ANDI pwd_check, 0x4

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ PWD_SW2

PWD_SW2:
				ORI temp, 0
				OR temp, temp2
				AND temp, SW2
				LDI pwd_check, 0
				OR pwd_check, pwd
				ANDI pwd_check, 0x2

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ PWD_SW1
				
PWD_SW1:				
				ORI temp, 0
				OR temp, temp2
				AND temp, SW1
				LDI pwd_check, 0
				OR pwd_check, pwd
				ANDI pwd_check, 1

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ Alarm_Correct

Alarm_Correct: 	
				LDI temp, 0x10
				OUT PORTB, temp		
				// TODO: Needs something to do afterwards		

Wrong_Pass: 	
				ORI temp2, 0
				LDI temp2, 0xFE
				OUT PORTB, temp2
				rjmp Delay_1_sec				

Pass_Check:		
				rjmp Alarm_Check_B

Pass_Verif:
				CPI counter, 0x5
				BREQ Alarm_Fire
				CPI flag, 1
				BREQ Alarm_Fire
				ORI temp2, 0
				LDI temp2, 0xFF
				OUT PORTB, temp2
				rjmp Delay_1_sec_off

Again_Wrong_B:
				CPI counter, 0x5
				BREQ Alarm_Fire
				CPI flag, 1
				BREQ Alarm_Fire
				rjmp Wrong_Pass
				


Delay_1_sec_on:	
				INC counter
				ldi  r16, 21
    			ldi  r17, 75
   				ldi  r18, 191
L1: 			dec  r18
			    brne L1
			    dec  r17
			    brne L1
			    dec  r16
			    brne L1
			    nop
				rjmp Again_Wrong


Delay_1_sec_off:
				INC counter	
				ldi  r16, 21
    			ldi  r17, 75
   				ldi  r18, 191
L2: 			dec  r18
			    brne L2
			    dec  r17
			    brne L2
			    dec  r16
			    brne L2
			    nop
				rjmp Loop


Alarm_Fire:

Alarm_Check_B:
				ORI temp, 0
				IN temp, PIND
				OR temp2, temp; Save the inputs of PIND to a temp2
				AND temp, SW4
				OR pwd_check, pwd
				ANDI pwd_check, 0x8

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ PWD_SW3_B

PWD_SW3_B:		
				ORI temp, 0
				OR temp, temp2
				AND temp, SW3
				LDI pwd_check, 0
				OR pwd_check, pwd
				ANDI pwd_check, 0x4

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ PWD_SW2_B

PWD_SW2_B:
				ORI temp, 0
				OR temp, temp2
				AND temp, SW2
				LDI pwd_check, 0
				OR pwd_check, pwd
				ANDI pwd_check, 0x2

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ PWD_SW1_B
				
PWD_SW1_B:				
				ORI temp, 0
				OR temp, temp2
				AND temp, SW1
				LDI pwd_check, 0
				OR pwd_check, pwd
				ANDI pwd_check, 1

				CP pwd_check, temp
				BRNE Wrong_Pass
				BREQ Alarm_Correct

				


						
				
