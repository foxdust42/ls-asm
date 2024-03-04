; rax, rdi ,rsi, rdx, r10, r9, r8 
; 0Ah -> linefeed
;

section .bss
buffer:     RESB    100     ; 100 bytes

section .data
msg1    db  'ls for:    '       ;


section .text
global _start

_start:
    mov     rax, msg1
    call    print

    mov     rax, 79
    mov     rdi, buffer
    mov     rsi, 100
    syscall

    mov     rax, buffer
    call    printLF

    ; exit /w code 0
    call    exit

; prints w/ newline
printLF:
    call    print
    push    rax
    mov     rax, 0Ah
    push    rax
    mov     rax, rsp
    call    print
    pop     rax
    pop     rax
    ret

;; message on rax
;; sys_write (rax = 1) -> rdi = fd; rsi -> buf; rdx -> count 
print:
    push    rsi
    push    rdi
    push    rdx
    mov     rsi, rax    ; write msg to rsi
    call    strlen
    mov     rdx, rax    ; write len to rdx
    mov     rdi, 1      ; writing to stdout
    mov     rax, 1      ; syscall num
    syscall
    pop     rdx
    pop     rdi
    pop     rsi
    ret


;; message on rax
strlen:
    push    rdi
    mov     rdi ,rax
nextchar:
    cmp     byte[rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
finished:
    sub     rax, rdi
    pop     rdi
    ret


exit:
    mov     rax, 60
    mov     rdi, 0
    syscall
    ret