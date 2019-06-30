SYSCALL32 = 0x80
FN_EXIT = 1
FN_READ = 3
FN_WRITE = 4

STDIN = 0 # NR OF STANDART INPUT 0 = KEYBOARD

.data
hello: .string "Hllo world!\n"
buffer: .space 80

.text
.globl _start
_start:
    
    # get chars 

    movl $FN_READ, %eax
    movl $STDIN, %ebx
    movl $buffer, %ecx
    movl $80, %edx
    int $SYSCALL32
    
    # write chars

    movl $4, %eax # write(1, hello, strlen(hello))
    movl $1, %ebx
    movl $buffer, %ecx
    movl $80, %edx
    int  $0x80

    movl $1, %eax # exit(0)
    movl $0, %ebx
int $SYSCALL32
