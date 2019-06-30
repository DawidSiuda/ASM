## My const data

SYSCALL32 = 0x80
FN_EXIT = 1
FN_READ = 3
FN_WRITE = 4

STDIN = 0 # NR OF STANDART INPUT 0 = KEYBOARD

MY_VAR_1 = 0x04
MY_VAR_2 = 0x05

## Program 


#data section 
.data
  buffer: .space 80 #buffer: is a kind of pointer to this pleace in memory

#read only data section
.section .rodata  
  hello: .string "Hllo world!\n"

#Program section
.text

#function add
.globl _add_int_int   #.global mean that this function is viseable in global scope
_add_int_int:
  pushl %ebp          #throw ebp on stack 
  movl  %esp, %ebp    #set stack pointer like base pointer

  #we add edx to eax
  movl 8(%ebp), %edx   #set the first component 
  movl 12(%ebp), %eax  #set the second component
  
  addl %edx, %eax     #add the first component to the second component, we return value in eax

  popl %ebp           #revert stack base pointer 
  ret

# function main
.globl _start         # .global mean that this function is viseable in global scope
_start:               # function main
  
    #set local var
    pushl $MY_VAR_1
    pushl $MY_VAR_2
    #subl  $8, %esp    #move stack pointer 8 bytes down, it's place for our 2 of int var
    #movl  $MY_VAR_1, %ebp      #set MY_VAR_1 on the top of stack
    #movl  $MY_VAR_2, -4(%ebp)  #set MY_VAR_2 on the top -4B of stack

    # call function _add
    sub   $8, %esp    #create pleate (2x4B) for function arguments
    pushl -0(%ebp)    #set the first argument 
    pushl -4(%ebp)    #set the secontd argument
    call  _add_int_int
   
    addl 16, %esp
   
   #int 3

    # get chars 
    #movl  $FN_READ, %eax
    #movl  $STDIN, %ebx
    #movl  $buffer, %ecx
    #movl  $80, %edx
    #int   $SYSCALL32
   # 
    ## write chars
    #movl $4, %eax     # write(1, hello, strlen(hello))
    #movl $1, %ebx
    #movl $buffer, %ecx
    #movl $80, %edx
    #int  $0x80

    movl $1, %eax     # exit(0)
    movl $0, %ebx
int $SYSCALL32
