mov ah, 0x0e ; tty mode

mov bp, 0x8000 ; this is an address far away from 0x7c00 so that we don't get overwritten
mov sp, bp ; if the stack is empty then sp points to bp

push 'A'
push 'B'
push 'C'

; tug test,bp address is 0x8000 ,I mov 'T' into this address,otherwise it is null ,it wont work
;mov al,'T'
;mov [0x8000],al

; adress 0x8000 data is 'T'
;mov al, [0x8000]
;int 0x10

; after push ,stack data storage like this
;	...
;	0x8002.......
;	0x8000-->bp
;	0x7FFE-->'A'
;	0x7FFC-->'B'
;	0x7FFA-->'C' -->sp
;	0x7FF8.......
;	...

; to show how the stack grows downwards
mov al, [0x7ffe] ; 0x8000 - 2
int 0x10

; however, don't try to access [0x8000] now, because it won't work
; you can only access the stack top so, at this point, only 0x7ffe (look above)
mov al, [0x8000]
int 0x10


; recover our characters using the standard procedure: 'pop'
; We can only pop full words so we need an auxiliary register to manipulate
; the lower byte
pop bx
mov al, bl
int 0x10 ; prints C

pop bx
mov al, bl
int 0x10 ; prints B

pop bx
mov al, bl
int 0x10 ; prints A

; data that has been pop'd from the stack is garbage now
mov al, [0x8000]
int 0x10

;stack pop end


jmp $
times 510-($-$$) db 0
dw 0xaa55
