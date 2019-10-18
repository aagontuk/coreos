print_hex:
    push bx
    push cx
    push dx
    push ax

    mov bx, HEX_STR
    mov cx, 0x000f
    mov ax, 0x0000  ; length counter

    next_digit: 
        push bx         ; save bx
        and cx, dx      ; 0xabcd & 0x000f
        cmp cx, 0x0009
        jg alpha
        add bx, 5       ; find position in the template
        sub bx, ax
        add [bx], cl 
        pop bx
        shr dx, 4       ; next digit
        mov cx, 0x000f
        inc ax          ; increment counter
        cmp ax, 4
        jl next_digit         ; loop through the digits

    end_hex:
        pop ax

        call print_string

        mov BYTE [HEX_STR], '0'
        mov BYTE [HEX_STR + 1], 'x'
        mov BYTE [HEX_STR + 2], '0'
        mov BYTE [HEX_STR + 3], '0'
        mov BYTE [HEX_STR + 4], '0'
        mov BYTE [HEX_STR + 5], '0'

        pop dx
        pop cx
        pop bx
        ret

    alpha:
        add bx, 5       ; find position in the template
        sub bx, ax
        sub cl, 10
        add cl, 49
        add [bx], cl 
        pop bx
        shr dx, 4       ; next digit
        mov cx, 0x000f
        inc ax          ; increment counter
        cmp ax, 4
        jl next_digit         ; loop through the digits
        jmp end_hex

HEX_STR:
    db '0x0000', 0
