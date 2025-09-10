mov ax, cs
mov ss, ax
mov sp, 01FCh
mov ax, 0400h
nop
nop

mov bx, 000Eh
mov dx, 0001h
mov cx, 0001h
mov ax, 024Fh
int 10h
mov ah, 09h
int 10h
inc dx
mov ah, 02h
int 10h
mov ax, 0953h
int 10h
inc dx
inc dx
mov ah, 02h
int 10h
mov ax, 092Fh
int 10h
inc dx
inc dx
mov ah, 02h
int 10h

mov ax, 0963h
int 10h
inc dx
mov ah, 02h
int 10h
mov ax, 0973h
int 10h
inc dx
mov ah, 02h
int 10h

mov ax, 093Ah
int 10h
inc dx
mov ah, 02h
int 10h

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

mov dx, 0100h
mov ah, 02h
int 10h
mov ax, 093Ah
int 10h

loop:
	pause
jmp loop

01E0h:
	ret
