TITLE super_mario_random_generator_rafail_nikou_1695

DEDOMENA SEGMENT
    
 seed1 DB 066h;αυτο ειναι το πρωτο seed 148B
 seed2 DB 08FH;αυτο ειναι το δευτερο seed 148C
 apotelesma1 DB 0E9H;αυτη ειναι η πρωτη εξοδος 148D
 apotelesma2 DB 0A6H;αυτη ειναι η δευτερη εξοδος 148E 
 NL DB 10,13,'$';μια μεταβλητη για την συναρτηση για να αλλαξουμε γραμμη 
 temp db 0;μια μεταβλητη temp στο μηδεν
 
DEDOMENA ENDS

KODIKAS SEGMENT
ARXH: 

 MOV AX,DEDOMENA
 MOV DS,AX 
 ;απο εδω και κατω θα φτιαξουμε τον κωδικα 
 ;θελουμε να καλουμε τις συναρτησεις μας εδω και θα πηγαινουμε συνεχως στην ετικετα arxizoyme_tyxaioys_numbers
 
 arxizoyme_tyxaioys_numbers:
 
 call get_rand_numbers ;καλω την συναρτηση για τους τυχαιους αριθμους 
 
 MOV AL,apotelesma1 ;κανω Mov το πρωτο αποτελεσμα στον al καιτο εκτυπωνω με την συναρτηση απο προηγουμενο μαθημα print_two_hex_digits
 call print2digits

 MOV AL,apotelesma2 ;κανω Mov το δευτερο αποτελεσμα στον al καιτο εκτυπωνω με την συναρτηση απο προηγουμενο μαθημα print_two_hex_digits
 call print2digits
 call PRINTNL ;αλλαξουμε και μια γραμμη καθε φορα με την συναρτηση αυτη 
 
 JMP arxizoyme_tyxaioys_numbers  ;κανουμε jump στην ετικετα οποτε ξαναρχιζουν ολα απο την αρχη 
 
 MOV AH,4CH
 INT 21H                                   
 
;//////////////////////////////////////////
get_rand_numbers proc             
    
    push AX
    push BX
    
    MOV BL,01h;o bl einai gia index 
    
    call tickrng;για να κανω το πρωτο αποτελεσμα
    
    DEC BL;prepei na meiono kata ena kaye fora
    
    call tickrng;για να κανω το δευτερο αποτελεσμα

    pop BX
    pop AX
ret
get_rand_numbers endp
;/////////////////////////////////////////

tickrng proc
    PUSH AX
    PUSH BX
    
    MOV AL,seed1 ;bale to seed1 ston al kai meta kane shift left 2 ueseis
    SHL AL,2
    
    STC;Bale to Carry Flag == CF <- 1
    
    ADC AL,seed1 ;kane add the most significant words
    MOV seed1,AL   ;kai apouikeyse to sto seed1 
    
    SHL seed2,1 ;kane shift left to seed2 kata mia uesi ayth thn fora   
    
    MOV AL,20H   ;apouikeyo carry kai mov cl,al 
    
    RCL CH,1       
    ;The left rotate instruction shifts all bits in the register or memory operand specified. The carry flag (CF) is included in the rotation. The most significant bit is rotated to the carry flag, 
    ;the carry flag is rotated to the least significant bit position, all other bits are shifted to the left.
    ;The result includes the original value of the carry flag.
    
    AND AL,seed2;me to and allazo to zero flag 
    
    RCR CH,1
    ;The right rotate instruction shifts all bits in the register or memory operand specified. The carry flag (CF) is included in the rotation. 
    ;The least significant bit is rotated to the carry flag, the carry flag is
    ;rotated to the most significant bit position, all other bits are shifted to the right. The result includes the original value of the carry flag
    
    JNC LabelA  ;jump if not zero 
    JZ LabelC   ;jump if zero 
    JNE LabelB  ;Jump short if not equal (ZF=0)
    
    LabelA:JNE LabelC
    LabelB:INC seed2
    LabelC:MOV AL,seed2
    
    XOR AL,seed1
    
    CMP BL,1
    JZ METAFORA_APOTELESMA2 ;jump if zero 
    MOV apotelesma1,AL  
    
    JMP TELEIOSE
    
    METAFORA_APOTELESMA2:
    MOV apotelesma2,AL
    
    
    TELEIOSE:
    POP AX
    POP BX
ret 

tickrng endp
   
;////////////////////////////////////////////////////////   
print2digits proc
    
 PUSH AX
 PUSH BX 
  
  MOV AH,0
  
  MOV BL,16
  DIV BL
  
  MOV temp,AL
  
  call print1digit
  
  MOV temp,AH
  
  call print1digit
 
 POP BX
 POP AX
ret     

print2digits endp                   

;/////////////////////////////////////////////////////////

print1digit proc
    push AX
    push DX
    
    CMP temp,09H
    JBE mikrotero_toy_9
 
    ;ekane ton elegxo kai einai megalitero toy 9
    MOV DL,temp
    ADD DL,37H   ;prosuetoyme to 37h apo ton pinaka ascii
    MOV AH,02
    INT 21H
    JMP OVER
 
    mikrotero_toy_9:
    MOV DL,temp
    ADD DL,30H    ;prosuetoyme to 30h apo ton pinaka ascii
    MOV AH,02
    INT 21H    
    
    OVER:
    pop DX
    pop AX
    ret
print1digit endp

;/////////////////////////////////////////////////
PRINTNL PROC
PUSH DX
PUSH AX
LEA DX, NL ;EKTIPONO MINIMA
MOV AH,09   
INT 21H  
POP AX
POP DX    
RET
PRINTNL ENDP    
;///////////////////////////////////////////////

KODIKAS ENDS

SOROS SEGMENT STACK
db 256 dup(0)
SOROS ENDS

END ARXH