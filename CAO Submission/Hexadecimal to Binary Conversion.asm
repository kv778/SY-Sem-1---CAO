section .data

menumsg db 10,"************MENU*************"
	db 10,"1.HEX to BCD"
	db 10,"2.EXIT"
	db 10,"Enter U r Choice:"
menul equ $-menumsg

h2b db 10,"HEX to BCD"
    db 10,"Enter 4 digit Hex Number:"
h2bl equ $-h2b


bmsg db 10,13,"Equivalent BCD number is:"
bmsgl equ $-bmsg


dmsg db 10,"Do u Want to cnt...."
dmsgl equ $-dmsg

section .bss

choice resb 2
buf resb 6
bufl equ $-buf

digitcount resb 1

ans resw 1

char_ans resb 4
fact resw 1

%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro


%macro exit 0
	mov rax,60
	xor rdi,rdi
	syscall
%endm
section .text

global _start

_start:
menu:
	scall 01,01,h2b,h2bl
	call accept_16

	
	
	mov ax,bx

	mov rbx,10
back:
	xor rdx,rdx
	div rbx
	push dx
	inc byte[digitcount]
	cmp rax,0h
	jne back
	
	scall 01,01,bmsg,bmsgl

print_bcd:
	pop dx
	add dl,30h
	mov [char_ans],dl
	scall 01,01,char_ans,1
	dec byte[digitcount]
	jnz print_bcd
	ret

accept_16:
	scall 0,0,buf,5
	xor bx,bx
	mov rcx,4
	mov rsi,buf
next_digit:
	shl bx,04
	mov al,[rsi]

	cmp al,39h
	jbe l1
	sub al,07h

l1:	sub al,30h
	add bx,ax
	inc rsi
	loop next_digit
ret
