print_string:
    mov ah, 0x0e
    push bx

    string_loop:
        cmp BYTE [bx], 0
        je string_end
        mov al, [bx]
        int 0x10
        inc bx
        jmp string_loop

    string_end:
        pop bx
        ret

