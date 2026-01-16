mov ax,cs		; Move segment reg to r/m, 8C C8 = 11 001 000	reg=001, modR/M=11+000=ax
mov ds,ax		; Move r/m to segment reg, 8E D8 = 11 011 000	reg=011, modR/M=11+000=ax

mov ax,0000h	; B8 00 00
mov ss,ax		; 8E D0 - Initialize stack address at 0000:03FFh
mov es,ax		; 8E C0 - Using it later to print string.

mov sp,03ffh	; C7 C4 FF 03 - mov r,imm instruction
MainLoop:		; Address 0x0F

	push 0030		; Save length of my string into stack
	mov bx, 000E	; Set yellow text color
	mov dx, 0000	; Start row=0, col=0

	mov bp,7DB0h	; BD B0 7D - mov r16/32, imm16/32
					; This is the absolute address of my string, since this first
					; sector was loaded at 7C00:0000 or 0000:7C00
	pop cx			; 59h

	mov ax, 1300h
	int 10h			; CD 10 - Print CX chars at ES:(E)BP = ES:7DC0h = CS:7DC0h

					; Set cursor to DH=Row=1, DL=Col, BIOS function 02h, interrupt 10h
	mov dx,0100h	; BA 00 01
	mov ax,0200h	; B8 00 02
	int 10h			; CD 10
		
					; Print "SP: 0x header"
					; BD A0 7D
					; B9 06 00
					; B8 00 13
					; CD 10
					
					; Move cursor ahead CX times
	add dx,cx		; 03 D1
					; B4 02
					; CD 10
					
					; Print SP value (hex)
	mov cx,1		; B9 01 00
	mov ax,sp		; 89 E0
	shr ax,12		; C1 E8 0C
	cmp al,09h		; 3C 09
	ja digit0_is_letter	; 77 04
	add al,0x30		; 04 30 - start from '0' char
	jmp digit0_exit	; EB 02 - jump next to bytes, starting from next instruction already
	digit0_is_letter:
	add al,0x37		; 04 37 - start from 'A' char
	digit0_exit:
	mov ah,09h		; B4 09
	int 10h			; CD 10
	inc dx			; 42
	mov ah,02h		; B4 02
	int 10h			; CD 10

					; Repeat for next chars
					; 89 E0
					; C1 E8 08
					; 24 0F
					; 3C 09
					; 77 04
					; 04 30
					; EB 02
					; 04 37
					; B4 09
					; CD 10
					; 42
					; B4 02
					; CD 10

					; 89 E0
					; C1 E8 08
					; 24 0F
					; 3C 09
					; 77 04
					; 04 30
					; EB 02
					; 04 37
					; B4 09
					; CD 10
					; 42
					; B4 02
					; CD 10
					
					; 89 E0
					; C1 E8 08
					; 24 0F
					; 3C 09
					; 77 04
					; 04 30
					; EB 02
					; 04 37
					; B4 09
					; CD 10
					
					; Move cursor to row 2
	mov dx,0x0200	; BA 00 02
	mov ax,0x0200	; B8 00 02
	int 10h			; CD 10

					; Print AL char = '>'
	mov cx,1		; B9 01 00
	mov ax,0A3Eh	; B8 3E 0A
	int 10h			; CD 10
	
					; Advance cursor
	inc dx			; 42		
	xor di,di		; 33 FF - Zero out DI reg
	mov ax,0200h	;
	int 10h			;
	
	mov ah,00h		;
	int 16h			; Wait for keyboard key
	
	push ax			; Save pressed key
	mov ah,09h		;
	int 10h			; Print same key
	pop				; Restore AX
	
	shr ax,8		; C1 E8 08 - Get key code, not key press
	cmp al,02h		; 3C 02 - Was key pressed '1' ?
	jz key1_process	; 74 15 - If yes then jmp +21 bytes
	
	cmp al,03h		; Was key pressed '2' ?
	jz key2_process	; 74 1E - Yes? the jump to label
	
	cmp al,04h		; Was key pressed '3' ?
	jz key3_process	; 0F 84 00 A2 - If yes then jump signed relative 0x00A2 value
	
	cmp al,05h		; 3C 05
	jz key4_process	; 0F 84 00 AC
	
					; else:
	mov ax,0x7C0F	; B8 0F 7C
	jmp [ax]		; FF E0

	key1_process:
		pause				; F3 90
		mov ah,01h			; B4 01 - Keyboard bios function
		int 16h				; CD 16 - Get keyboard buffer status - was any key pressed? ZF will be zero if no key is in buffer
		jz key1_process		; 74 F8 - jump -8 bytes (relative from next instruction, that is, IP reg)
		mov ax,0x7C0B		; B8 0F 7C - New address = start of program
		jmp [ax]			; FF E0 - Jump to [ax] - Reset program		
	
	key2_process:
		?					; FE C3 81 E3 0F FF ...
		...
		dec dx				; 4A
		dec dx
		dec dx
		dec dx
		dec dx
		mov ah,02h
		int 10h
		mov ah,01h
		int 16h
		jz key2_process		; 0F 84 B3 FF - Jump -77 bytes (0xFFB3 signed value)
		mov cx,0005h		; else: erase message (backward 5 chars and put spaces) and reset program
		mov bx,0000h
		mov ax,0920h		; AL = ' ' - space character
		int 10h
		mov ax,0x7C0F		; B8 0F 7C
		jmp [eax]			; FF E0 - Reset program
		
		nop
		nop
		...
		
	key3_process:
		push ax				; 50
		jmp MainLoop		; E9 9B FE - Unconditional jump -357 bytes (0xFFB3 signed value)
	key4_process:
		pop ax				; 58
		jmp MainLoop		; E9 8B FE - Unconditional jump -373 bytes (0xFFB3 signed value)

Address 1A0h = "SP: 0x"
Address 1B0h = "OS: [1] Spin-loop [2] Color Msg [3] PUSH [4] POP"
Address 1FE = 0x55
Address 1FF = 0xAA