DATA SEGMENT USE16
    FIRSTTEXT DB 'Enter first number: ', '$'
    SECONDTEXT DB 'Enter second number: ', '$'
    RESULTTEXT DB 'The sum of the numbers is: ', '$'
    NEWLINE DB 13, 10, '$'
    BUFFER DB 20, 0, 20 DUP('$')    
    RESULT DB 6 DUP(0), '$'
DATA ENDS

CODE SEGMENT USE16
    ASSUME CS:CODE, DS:DATA
    
BEG:
    MOV AX, DATA
    MOV DS, AX
    
    ; Display first prompt
    MOV AH, 9
    MOV DX, OFFSET FIRSTTEXT
    INT 21H
    
    ; Read first number
    MOV AH, 0AH
    MOV DX, OFFSET BUFFER
    INT 21H
    
    ; Convert first number to integer
    LEA SI, BUFFER+2
    CALL STR_TO_NUM
    MOV BX, AX 
    
    ; Display newline
    MOV AH, 9
    MOV DX, OFFSET NEWLINE
    INT 21H
    
    ; Display second prompt
    MOV AH, 9
    MOV DX, OFFSET SECONDTEXT
    INT 21H
    
    ; Read second number
    MOV AH, 0AH
    MOV DX, OFFSET BUFFER
    INT 21H
    
    ; Convert second number to integer
    LEA SI, BUFFER+2
    CALL STR_TO_NUM
    ADD AX, BX 
    MOV BX, AX 
    
    ; Convert sum to string
    MOV AX, BX
    LEA DI, RESULT
    CALL NUM_TO_STR
    
    ; Display newline
    MOV AH, 9
    MOV DX, OFFSET NEWLINE
    INT 21H
    
    ; Display result text
    MOV AH, 9                       
    MOV DX, OFFSET RESULTTEXT
    INT 21H
    
    ; Display the result
    MOV AH, 9
    MOV DX, OFFSET RESULT
    INT 21H
    
    ; Exit program
    MOV AH, 4CH
    INT 21H
    
STR_TO_NUM:
    XOR AX, AX
    XOR CX, CX
    MOV CX, 10
    

STR_TO_NUM_LOOP:
    LODSB                                   
    CMP AL, 13
    JE STR_TO_NUM_DONE
    SUB AL, '0'
    MUL CX
    ADD AX, AX
    JMP STR_TO_NUM_LOOP
    
STR_TO_NUM_DONE:
    RET
    
NUM_TO_STR:
    XOR CX, CX    
    MOV BX, 10     

    LEA DI, RESULT + 6 
    DEC DI          

    TEST AX, AX      
    JNZ NUM_TO_STR_LOOP
    MOV DL, '0'       
    MOV [DI], DL      
    DEC DI            
    JMP NUM_TO_STR_DONE

NUM_TO_STR_LOOP:
    XOR DX, DX       
    DIV BX            
    ADD DL, '0'       
    MOV [DI], DL     
    DEC DI            
    TEST AX, AX       
    JNZ NUM_TO_STR_LOOP

NUM_TO_STR_DONE:
    MOV BYTE PTR [DI], '$'
    RET  

CODE ENDS
END BEG
