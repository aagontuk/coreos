;GDT
gdt_start:

gdt_null:   ; the null segment
    dd 0x0  ; 8 byte
    dd 0x0

gdt_code:           ; code segment
    dw 0xffff       ; limit (bits 0-15)
    dw 0x0          ; base (bits 16-31) 
    db 0x0          ; base (bits 32-39)
    db 10011010b    ; 1st flags (bits 44-47) and type flags (bits 40-43)
    db 11001111b    ; 2nd flags (52-55) and limit (48-51)
    db 0x0          ; base (bits 56-63)

gdt_data:           ; data segment
    dw 0xffff       ; limit (bits 0-15)
    dw 0x0          ; base (bits 16-31) 
    db 0x0          ; base (bits 32-39)
    db 10010010b    ; 1st flags (bits 44-47) and type flags (bits 40-43)
    db 11001111b    ; 2nd flags (52-55) and limit (48-51)
    db 0x0          ; base (bits 56-63)

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; gdt size. Always 1 less than true size
    dd gdt_start                ; start address of GDT

; handy constants for segment registers
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
