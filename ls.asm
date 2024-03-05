; rax, rdi ,rsi, rdx, rax, r9, r8 
; 0Ah -> linefeed
;

section .bss
buffer:     RESD    100     ; 100 bytes
stat_struct RESB    88      ; 88  bytes
print_buff  RESB    64       ; 4 bytes

section .data
msg1        db  'ls for:    '       ;
nullchar    db  00h                 ;


section .text
global _start

_start:
    mov     rax, msg1
    call    print

    mov     rax, buffer

    call    getwd
    call    printLF
    ;cwd on rax

    ; stat cwd 
    mov     rdi, rax
    mov     rsi, stat_struct
    mov     rax, 4
    syscall

    xor rax, rax

    mov rax, [stat_struct]
    add rax, 48
    mov [print_buff], rax
    mov eax, 0Ah 
    mov [print_buff + 1], eax 
    mov eax, 00h
    mov [print_buff + 2], eax
    
    mov rax, print_buff
    call print


    mov     rax, 1001_0110b
    call    print_bits

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

; takes buffer on rax; returns buffer on rax
getwd:
    push    rdi
    push    rsi

    mov     rdi, rax
    mov     rax, 79
    mov     rsi, 100
    syscall

    mov     rax, rdi

    pop     rsi
    pop     rdi
    ret

; val on rax
print_bits:
    push    rdi
    push    rsi
    push    rax
    mov     rdi , rax
    mov     rsi, 1000_0000b
    mov     rdx, 00b
    mov     dword [print_buff + 8], 0h
.pr_loop:
    mov     rax, rdi
    and     rax, rsi
    cmp     rax, 0000b
    jz      .zero
    mov     rax, 0001b
    jmp     .fin    
    .zero:
    mov     rax, 0000b
    .fin:
    add     rax, 48d
    mov     [print_buff + rdx], rax
    inc     rdx
    shr     rsi, 0001b
    cmp     rdx, 1000b
    jnz     .pr_loop
    mov     rax, print_buff
    call    printLF

    pop     rax
    pop     rsi
    pop     rdi
    ret


;statbuf in rax
;statbuf:
;   ull st_dev -> device id
;   uchar   padding[4]
stat:
    
