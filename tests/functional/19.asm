	org 32768
__START_PROGRAM:
	di
	push ix
	push iy
	exx
	push hl
	exx
	ld hl, 0
	add hl, sp
	ld (__CALL_BACK__), hl
	ei
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call SIN
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call COS
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call TAN
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call ASIN
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call ACOS
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call ATAN
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call LN
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call EXP
	ld hl, _x
	call __STOREF
	ld a, (_x)
	ld de, (_x + 1)
	ld bc, (_x + 3)
	call SQRT
	ld hl, _x
	call __STOREF
	ld hl, 0
	ld b, h
	ld c, l
__END_PROGRAM:
	di
	ld hl, (__CALL_BACK__)
	ld sp, hl
	exx
	pop hl
	exx
	pop iy
	pop ix
	ei
	ret
__CALL_BACK__:
	DEFW 0
#line 1 "acos.asm"
#line 1 "stackf.asm"
	; -------------------------------------------------------------
	; Functions to manage FP-Stack of the ZX Spectrum ROM CALC
	; -------------------------------------------------------------
	
	
	__FPSTACK_PUSH EQU 2AB6h	; Stores an FP number into the ROM FP stack (A, ED CB)
	__FPSTACK_POP  EQU 2BF1h	; Pops an FP number out of the ROM FP stack (A, ED CB)
	
__FPSTACK_PUSH2: ; Pushes Current A ED CB registers and top of the stack on (SP + 4)
	                 ; Second argument to push into the stack calculator is popped out of the stack
	                 ; Since the caller routine also receives the parameters into the top of the stack
	                 ; four bytes must be removed from SP before pop them out
	
	    call __FPSTACK_PUSH ; Pushes A ED CB into the FP-STACK
	    exx
	    pop hl       ; Caller-Caller return addr
	    exx
	    pop hl       ; Caller return addr
	
	    pop af
	    pop de
	    pop bc
	
	    push hl      ; Caller return addr
	    exx
	    push hl      ; Caller-Caller return addr
	    exx
	 
	    jp __FPSTACK_PUSH
	
	
__FPSTACK_I16:	; Pushes 16 bits integer in HL into the FP ROM STACK
					; This format is specified in the ZX 48K Manual
					; You can push a 16 bit signed integer as
					; 0 SS LL HH 0, being SS the sign and LL HH the low
					; and High byte respectively
		ld a, h
		rla			; sign to Carry
		sbc	a, a	; 0 if positive, FF if negative
		ld e, a
		ld d, l
		ld c, h
		xor a
		ld b, a
		jp __FPSTACK_PUSH
#line 2 "acos.asm"
	
ACOS: ; Computes ACOS using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 23h ; ACOS
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 72 "19.bas"
#line 1 "asin.asm"
	
	
ASIN: ; Computes ASIN using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 22h ; ASIN
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 73 "19.bas"
#line 1 "atan.asm"
	
	
ATAN: ; Computes ATAN using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 24h ; ATAN
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 74 "19.bas"
#line 1 "cos.asm"
	
	
COS: ; Computes COS using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 20h ; COS
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 75 "19.bas"
#line 1 "exp.asm"
	
	
EXP: ; Computes e^n using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 26h ; E^n
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 76 "19.bas"
#line 1 "logn.asm"
	
	
LN: ; Computes Ln(x) using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 20h ; 25h
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 77 "19.bas"
#line 1 "sin.asm"
	
	
SIN: ; Computes SIN using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 1Fh
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 78 "19.bas"
#line 1 "sqrt.asm"
	
	
SQRT: ; Computes SQRT(x) using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 28h ; SQRT
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 79 "19.bas"
#line 1 "storef.asm"
__PISTOREF:	; Indect Stores a float (A, E, D, C, B) at location stored in memory, pointed by (IX + HL)
			push de
			ex de, hl	; DE <- HL
			push ix
			pop hl		; HL <- IX
			add hl, de  ; HL <- IX + HL
			pop de
	
__ISTOREF:  ; Load address at hl, and stores A,E,D,C,B registers at that address. Modifies A' register
	        ex af, af'
			ld a, (hl)
			inc hl
			ld h, (hl)
			ld l, a     ; HL = (HL)
	        ex af, af'
	
__STOREF:	; Stores the given FP number in A EDCB at address HL
			ld (hl), a
			inc hl
			ld (hl), e
			inc hl
			ld (hl), d
			inc hl
			ld (hl), c
			inc hl
			ld (hl), b
			ret
			
#line 80 "19.bas"
#line 1 "tan.asm"
	
	
TAN: ; Computes TAN using ROM FP-CALC
		call __FPSTACK_PUSH
	
		rst 28h	; ROM CALC
		defb 21h ; TAN
		defb 38h ; END CALC
	
		jp __FPSTACK_POP
	
#line 81 "19.bas"
	
ZXBASIC_USER_DATA:
_x:
	DEFB 00, 00, 00, 00, 00
	; Defines DATA END --> HEAP size is 0
ZXBASIC_USER_DATA_END EQU ZXBASIC_MEM_HEAP
	; Defines USER DATA Length in bytes
ZXBASIC_USER_DATA_LEN EQU ZXBASIC_USER_DATA_END - ZXBASIC_USER_DATA
	END
