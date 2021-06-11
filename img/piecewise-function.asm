DATA SEGMENT
    TEMP_DX DW ?
    CNT_CX DW ?
    LOOP_CX DW ?
    X DW 12
    Y DW ?
DATA ENDS
STACK SEGMENT PARA STACK
    DB 256 DUP (?)
STACK ENDS
CODE SEGMENT
    MAIN PROC FAR
        ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    PUSH DS
    MOV AX,0
    PUSH AX
    MOV AX,DATA
    MOV DS,AX
    MOV AX,STACK
    MOV SS,AX

    MOV BX,0H
    MOV AX,X
    CMP AX,1
    JL FA
    CMP AX,10
    JG FC
    JMP FB
FA:
    MOV BL,2
    MUL BL
    JMP OVER
FB:
    ADD AX,2
    JMP OVER
FC:
    SUB AX,4
    JMP OVER
OVER:
    MOV Y,AX
    MOV DX,Y
    CALL PRINT_REG
    MOV AX,4C00H
    INT 21H
    MAIN ENDP
    PRINT_REG PROC; print HEX number in DX
        MOV CX,4
        MOV CNT_CX,12
        START_1:
            MOV LOOP_CX,CX
            MOV TEMP_DX,DX
            MOV CX,CNT_CX
            SHR DX,CL
            CALL PRINT_NUM
            SUB CX,4
            MOV CNT_CX,CX
            MOV CX,LOOP_CX
            MOV DX,TEMP_DX
        LOOP START_1
        MOV DL,10
        MOV AH,02H
        INT 21H
        RET
    PRINT_REG ENDP

    PRINT_NUM PROC; print HEX number in DL's lowest byte
        AND DL,0FH
        CMP DL,0AH
        JC NUM
        JNC ALPHA
    NUM:
        ADD DL,30H
        JMP OUT1
    ALPHA:
        ADD DL,37H
        JMP OUT1
    OUT1:
        MOV AH,02H
        INT 21H
        RET
    PRINT_NUM ENDP
CODE ENDS
    END START