.bss
.comm buffor 14

.text
.global _start
_start:

     mov $0, %rax

     cpuid

     mov $buffor, %rsi
     
     movl %ebx, (%rsi)
     movl %ecx, 4(%rsi)
     movl %edx, 8(%rsi) 
     movb $10, 9(%rsi)
     movb $0, 10(%rsi)

     mov $1, %rax
     mov $1, %rdi
     mov $buffor, %rsi
     mov $13,%rdx
     syscall

     mov $60, %rax
     syscall
