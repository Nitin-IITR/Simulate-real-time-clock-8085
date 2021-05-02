AM_PM:      MVI D,00H
START:      LXI H,0000H      ; Load 0000H value in HL register pair

	    MOV A,D          ; Move content of regiter D to accumulator  => 00H or 01H
	    CMA		     ; Take complement of content in accumulator => 11H or 10H
	    ANI 01H          ; A = A AND 01H			         => 01H or 00H
	    STA 5003H	     ; Store content of accumulator to 5003H
	    
Hour_Min:   SHLD 5001H       ; Store HL pair value at 5001H(L)and 5002H(H)
            XRA A  	     ; XOR between A and A => Clear register A

sec_min_hr: STA 5000H        ; Store accumulator content at 5000H
	    CALL sec_delay   ; Delay of 1 sec
	    LDA 5000H        ; Load content from location 5000H to accumulator
	    ADI 01H	     ; Add 01H to accumulator
	    DAA		     ; Ajust decimal => To convert HEX to Decimal format
	    CPI 60H          ; Compare accumulator value with 60H (In decimal here) i.e.60 sec
	    JNZ sec_min_hr   ; If false,then go to sec_min_hr,otherwise continue below

	    XRA A            ; Clear value of accumulator
            STA 5000H        ; Store the value of accumulator to 5000H
	      
	    LHLD 5001H	     ; Load HL pair value from address 5001H(L) and 5002H(H)
	    MOV A,L          ; Move value of L to accumulator
	    ADI 01H          ; Add 01H to accumulator
	    DAA		     ; Ajust decimal => To convert HEX to Decimal format
	    MOV L,A          ; Move value of accumulator to L
	    CPI 60H          ; Compare accumulator value with 60H (In decimal here) i.e.60 min
	    JNZ Hour_Min     ; If false,then go to Hour_Min,otherwise continue below

	    XRA A            ; Clear value of accumulator
            STA 5001H        ; Store the value of accumulator to 5001H
 
	    MOV A,H	     ; Move value of H to accumulator
	    ADI 01H	     ; Add 01H to accumulator
	    DAA		     ; Ajust decimal => To convert HEX to Decimal format
	    CPI 12H          ; Compare accumulator value with 12H (In decimal here) i.e.12 hour
	    JNZ Hour_Min     ; If flase,then go to Hour_Min otherwise continue below
	    

	    JMP START  	     ; Jump to the beginning of program


; Delay program ==> To make a delay of 1 sec when called

sec_delay:  MVI E,02H        ; 7T     Move value 02H to register D => Outer loop
Outer_loop: LXI B,0FFFFH     ; 10T    Move value FFFFH (65535) to register pair BC => Inner loop
Inner_loop: DCX B            ; 6T     Decrease value of BC pair (Inner loop)
	    MOV A,B          ; 4T     Delay time: Move value of register B to Accumulator
	    ORA C            ; 4T     Performs OR operation between Accumulator and regsiter C
	    JNZ Inner_loop   ; 10/7T  If value of BC pair is still not zero,then go to Inner_loop,otherwise continue
	    DCR E            ; 4T     If value of BC pair is zero,then decrese value of register D
	    JNZ Outer_loop   ; 10/7T  If value of register D is not zero,then go to Outer_loop,otherwise continue
	    RET		     ; 10T    Return from sub-routine => program control is transferred back to main program

; Calculation: (7+2*(10+65535*(6+4+4+10)-3+4+10)-3+10)T = 3145736T
; 1 T = 1/3*10^6 sec
; So,3145736T = 1.04857 seconds,which is approximately 1 Sec



