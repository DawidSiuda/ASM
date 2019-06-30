SYS_CALL = 0X80

FN_EXIT = 1
FN_READ  = 3 
FN_WRITE = 4

STD_IN = 0
STD_OUT = 1

INPUT_SIZE = 80

.section .bss
  inputString: .space INPUT_SIZE

.section .rodata
  .Str1: .string "Run function: int stringToNumber(*char).\n\r"
  str1_size =.-.Str1

.text

########################################################################
# int string_to_number(*char)
########################################################################
.global stringToNumber
stringToNumber:
  # set stack frame
  pushl %ebp
  movl %esp, %ebp

  # function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $.Str1, %ecx
  movl $str1_size, %edx
  int $SYS_CALL 

  #main loop
  # %eax :current prcessing char
  # %ebx :poniter on last using char in text
  # %ecx :calculated number 
  
  movl 8(%ebp), %ebx
  movl $0, %ecx
  movl $0, %esi # count started loop for debuging

  loop_stringToNumber:
    movl $0, %eax   # clear eax
    movb (%ebx), %al
    
    #check if end of string
    cmpb $'\n', %al
    je endLoop_stringToNumber

    # check if number 
    cmpb $'0', %al
    jl error_stringToNumber
    cmpb $'9', %al
    jg error_stringToNumber
  
    #Change char'0' to int 0
    subl $48, %eax

    # ecx = 10 * ecx + al
    imull $10, %ecx
    addl %eax, %ecx
  
    inc %ebx
  jmp loop_stringToNumber
endLoop_stringToNumber:

# End function and return the number
  movl %ecx, %eax # set return value
  popl %ebp
ret

# End function and return error(-1)
error_stringToNumber:
  movl $-1, %eax # set return value
  popl %ebp
ret

########################################################################
# int main()
########################################################################
.global _start
_start:

# function read
  movl $FN_READ, %eax
  movl $STD_IN, %ebx
  movl $inputString, %ecx
  movl $INPUT_SIZE, %edx
int $SYS_CALL

push $inputString     # put argument(s) on stack
call stringToNumber   # call function
addl $4, %esp         # pop argument(s) from stack
break1:

# function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $inputString, %ecx
  movl $INPUT_SIZE, %edx
int $SYS_CALL 

#FUNCTION EXIT
  movl $FN_EXIT, %eax
  movl $0, %ebx
int $SYS_CALL

