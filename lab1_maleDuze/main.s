SYSCALL32 = 0X80

FN_EXIT = 1
FN_READ = 3
FN_WRITE = 4

STD_IN = 0 #standard input = 0 => keyboard
STD_OUT = 1 #standard output = 1 => screen

.data 
  my_buffer: .space 80

.text
.global _start
_start:

#read from keyboard 
  movl  $FN_READ, %eax
  movl  $STD_IN, %ebx
  movl  $my_buffer, %ecx
  movl  $80, %edx
  int $SYSCALL32

#write to screen
  movl $FN_WRITE, %eax
  movl $STD_IN, 

  movl $FN_EXIT, %eax
  movl $0, %ebx
int $SYSCALL32

