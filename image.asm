mov ax,cs		; Move segment reg to r/m, 8C C8 = 11 001 000	reg=001, modR/M=11+000=ax
mov ds,ax		; Move r/m to segment reg, 8E D8 = 11 011 000	reg=011, modR/M=11+000=ax
nop
nop

mov ax,0000h
mov ss,ax		; 8E D0, Initialize stack address at 0000:03FFh
mov es,ax		; 8E C0, Using it later to print string.
mov sp,03ffh	; C7 C4 FF 03 - mov r,imm instruction

push 001C		; Save length of my string into stack
mov bx, 000f	; Set white text color
mov ax, 0b00	; B8 00 0B, bios function = set colors	
int 10h			; CD 10, Call BIOS interrput 10h

mov bx, 000e	; set yellow color
mov dx, 0000	; star row=0, col=0

mov bp,7DC0h	; BD C0 7D, mov r16/32, imm16/32
				; This is the absolute address of my string, since this first
				; sector was loaded at 7C00:0000 or 0000:7C00
pop cx			; 59h
mov ax, 1300h
int 10h			; CD 10, Print CX chars at ES:(E)BP = ES:7DC0h = CS:7DC0h

				; Set cursor to DH=Row, DL=Col, BIOS function 02h, interrupt 10h
mov dx,0100h	; BA 00 01
mov ax,0200h	; B8 00 02
int 10h			; CD 10
		
				; Print AL char = '>'
mov cx,1		; B9 01 00
				; B8 3E 0A
int 10h			; CD 10
				
				; Advance cursor
inc dx			; 42
				; B8 00 02
int 10h			; CD 10
				
SpinLoop:
	pause		; F3 90
	jmp SpinLoop; EB FC = Jump -4
nop				; 90
nop				; 90
				; ...
Address 1C0h = "OS: 1. Pause loop / 2. Count"