ENTRY(_start)

MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 8K
    ram : ORIGIN = 0x00002000, LENGTH = 8K
}

SECTIONS
{
    .text : 
    {
        *(.text)
        *(.rodata)
        _etext = .;  /* End of text section */
    } > rom

    .data : 
    {
        _sdata = .;  /* Start of data section */
        *(.data)
        _edata = .;  /* End of data section */
    } > ram AT > rom

    .bss :
    {
        _sbss = .;   /* Start of bss section */
        *(.bss)
        *(COMMON)
        _ebss = .;   /* End of bss section */
    } > ram

    /DISCARD/ : { *(.note.GNU-stack) }
}