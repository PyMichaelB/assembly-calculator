%include "definitions.inc"
%include "../print.inc"
 
section .bss
    ; space to use when reading in characters from stdin
    chr resb 1 

    valA resq 1
    valB resq 1
    operation resb 1

section .data
    welcome db "Welcome to the calculator!", LF, NULL
    enterA db LF, "Enter first number: ", LF, NULL
    enterB db LF, "Enter second number: ", LF, NULL
    optionMessage db LF, "Please choose from the options below", LF, \
                    "1. add", LF, \
                    "2. subtract", LF, \
                    "3. multiply", LF, NULL
                   
section .text
    global _start

_start:
    ; startup
    mov rsi, welcome
    call printString

    ; fetch number a and store in dword starting at valA
    mov rsi, enterA
    call printString
    mov rax, 0
    call readInteger64
    mov qword [valA], rax

    ; fetch number b and store in dword starting at valB
    mov rsi, enterB
    call printString
    mov rax, 0
    call readInteger64
    mov qword [valB], rax

    ; fetch operation number and store in dword starting at operation
    mov rsi, optionMessage
    call printString
    mov rax, 0
    call readInteger64
    mov byte [operation], al

    ; prepare registers with values for a and b
    mov rax, qword [valA]
    mov rbx, qword [valB]

    mov cl, byte [operation]
    cmp cl, 1
    je addition
    
    cmp cl, 2
    je subtraction

    cmp cl, 3
    je multiplication

    jmp exit

addition:
    add rax, rbx
    jmp exit

subtraction:
    sub rax, rbx
    jmp exit

multiplication:
    mul rbx
    jmp exit

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

readInteger64:
    mov rax, 0
    mov r10, 10

read:
    push rax

    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [chr]
    mov rdx, 1
    syscall

    pop rax

    mov rcx, 0
    mov cl, [chr]

    ; check if we should stop reading input characters
    cmp cl, LF
    je readDone

    ; conversion to integer
    sub cl, 48

    ; multiply current value by 10, and add current digit
    mul r10
    add rax, rcx

    jmp read

readDone:
    ret
