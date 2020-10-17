PROCESSOR 16F887
    #include <xc.inc>
   
    CONFIG FOSC=INTRC_NOCLKOUT
    CONFIG WDTE=OFF
    CONFIG PWRTE=ON
    CONFIG MCLRE=ON
    CONFIG CP=OFF
    CONFIG CPD=OFF
    CONFIG BOREN=OFF
    CONFIG IESO=OFF
    CONFIG FCMEN=OFF
    CONFIG LVP=OFF
    CONFIG DEBUG=ON
     
    CONFIG BOR4V=BOR40V
    CONFIG WRT=OFF
    
    PSECT udata
 tick:
    DS 1
 counter:
    DS 1
 counter2:
    DS 1
   
    PSECT code
    delay:
    movlw 0xFF
    movwf counter
    counter_loop:
    movlw 0xFF
    movwf tick
    tick_loop:
    decfsz tick,f
    goto tick_loop
    decfsz counter,f
    goto counter_loop
    return
    
PSECT resetVec,class=CODE,delta=2
	PAGESEL main
	goto main
	
PSECT isr,class=CODE,delta=2
    isr:
    btfss INTCON,1
    retfie
    btfss PORTD,0
    goto ledon
    goto ledof
    ledon:
    bcf INTCON,1
    movlw 0b00000001
    movwf PORTD
    retfie
    ledof:
    bcf INTCON,1
    movlw 0b00000000
    movwf PORTD
    retfie
    
PSECT main,class=CODE,delta=2
    main:
    BANKSEL OPTION_REG
    movlw 0b01000000
    movwf OPTION_REG
    BANKSEL WPUB
    movlw 0b11111111
    movwf WPUB
    clrf INTCON
    movlw 0b11010000
    movwf INTCON
    BANKSEL OSCCON
    movlw 0B01110000;
    Movwf OSCCON
    BANKSEL ANSELH
    clrf ANSELH
    BANKSEL ANSEL
    clrf ANSEL
    BANKSEL TRISB
    movlw 0xFF
    movwf TRISB    
    clrf TRISD
    movlw 0x00
    movwf TRISA 
    BANKSEL PORTB
    clrf PORTB
    movlw 0b00000000
    movwf PORTD
    movlw 0b00000001
    movwf PORTA
loop:
    BANKSEL PORTA
    call delay
    movlw 0x01
    xorwf PORTA,f
    goto loop
    END

