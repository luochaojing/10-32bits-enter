

[org 0x7c00] ; bootloader offset 。0x7c00 = 31744 = 512 * 62
    mov bp, 0x9000 ; set the stack
    mov sp, bp  ;SP:堆栈寄存器SP(stack pointer)存放栈的偏移地址;

    mov bx, MSG_REAL_MODE
    call print ; This will be written after the BIOS messages

    call switch_to_pm
    jmp $ ; this will actually never be executed。因为16可以到32，但是32无法转到16，为了保护系统，所以才叫pm

%include "../05-bootsector-functions-strings/boot_sect_print.asm"
%include "../09-32bit-gdt/32bit-gdt.asm"
%include "../08-32bit-print/32bit-print.asm"
%include "32bit-switch.asm"

[bits 32]
BEGIN_PM: ; after the switch we will get here  //PM:protect mode
    mov ebx, MSG_PROT_MODE ;//ebx 也是一个32位的寄存器
    call print_string_pm ; Note that this will be written at the top left corner
    jmp $

MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0

; bootsector
times 510-($-$$) db 0    // $为当前地址，$$为程序的起始地址，。jmp$
dw 0xaa55 // 定义Word。510-($-$$)的效果就是，填充了这些0之后，从程序开始到最后一个0，一共是510个字节。再加上最后的dw两个字节(0xaa55是结束标志)，整段程序的大小就是512个字节，刚好占满一个扇区。
