[org 0x7c00]

KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl    ; save current loaded disk number

    mov bp, 0x9000          ; setup stack
    mov sp, bp

    mov bx, REAL_MODE_MSG
    call print_string

    call load_kernel        ; load kernel from disk to memory

    call switch_to_pm       ; switch to 32 bit protected mode

    jmp $

%include "print/print_string.asm"
%include "disk/disk_load.asm"
%include "pm/gdt.asm"
%include "pm/print_string_pm.asm"
%include "pm/switch_to_pm.asm"

[bits 16]

load_kernel:
    
    mov bx, KERNEL_LOAD_MSG
    call print_string

    mov bx, KERNEL_OFFSET   ; load kernel from disk to memory
    mov dh, 15              ; load 15 disk from 2nd sector
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]

; land here after switching to 32 bit protecte mode
BEGIN_PM:

    mov bx, PROT_MODE_MSG
    call print_string_pm

    call KERNEL_OFFSET      ; execute kernel

    jmp $

; Global variable
BOOT_DRIVE db 0
REAL_MODE_MSG db "16 bit real mode", 0
KERNEL_LOAD_MSG db "Loading kernel...", 0
PROT_MODE_MSG db "Switched to 32 bit protected mode", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
