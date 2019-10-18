[bits 16]

switch_to_pm:

    cli                     ; clear interrupt
    lgdt [gdt_descriptor]   ; load GDT

    mov eax, cr0            ; switch to protected mode
    or eax, 0x1             ; by setting cr0
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; jump to 32 bit code also
                            ; force CPU to flush pipeline

[bits 32]

init_pm:
    mov ax, DATA_SEG        ; point segment registers to
    mov ds, ax              ; data selector of defined GDT
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM
