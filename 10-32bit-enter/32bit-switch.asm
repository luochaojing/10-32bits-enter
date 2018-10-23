[bits 16]
switch_to_pm:
    cli ; 1. disable interrupts; Clear Interupt

    lgdt [gdt_descriptor] ; 2. load the GDT descriptor

    mov eax, cr0 ;状态和控制寄存器组除了EFLAGS、EIP ，还有四个32位的控制寄存器，它们是CR0，CR1，CR2和CR3。
    or eax, 0x1  ; 3. set 32-bit mode bit in cr0
    mov cr0, eax
    // 这是一个交替     

    jmp CODE_SEG:init_pm ; 4. far jump by using a different segment

[bits 32]
init_pm: ; we are now using 32-bit instructions
    mov ax, DATA_SEG ; 5. update the segment registers?
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; 6. update the stack right at the top of the free space
    mov esp, ebp ;esp栈顶部指针，ebp存取堆栈指针

    call BEGIN_PM ; 7. Call a well-known label with useful code
