; --- PRINTING A STRING ---
; rsi is the string pointer
printString:
    mov rbx, rsi
    mov rcx, 0

countLoop:
    ; search for null terminated repeatedly - print string once found
    cmp byte [rbx], NULL
    je countDone

    ; increment length counter by 1
    inc rcx

    ; increment pointer by 1 byte
    inc rbx
    jmp countLoop

countDone:
    ; if length zero (exluding null term), don't attempt to print
    cmp rcx, 0
    je prtDone

    ; use sys_write syscall to output string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rdx, rcx
    syscall

prtDone:
    ret
