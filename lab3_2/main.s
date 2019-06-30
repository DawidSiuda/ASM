
SYS_CALL = 0X80

FN_EXIT = 1
FN_READ  = 3 
FN_WRITE = 4

STD_IN = 0
STD_OUT = 1

BAZE_SYSTEM = 10

INPUT_SIZE = 80

.extern _add_i

.section .bss
  inputString: .space INPUT_SIZE

.section .rodata
  .Str1: .string "Run function: smyAddStack(int a, int b).\n\r"
  str1_size =.-.Str1
  .Str2: .string "Run function: string_to_number(*char, type).\n\r"
  str2_size =.-.Str2

.text

########################################################################
# int string_to_number(*char text, int base)
########################################################################
.global stringToNumber
stringToNumber:
  # set stack frame
  pushl %ebp
  movl %esp, %ebp

  # function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $.Str2, %ecx
  movl $str2_size, %edx
  int $SYS_CALL 

  # Work on decimal number.   

  #main loop
  # %eax :current prcessing char
  # %ebx :poniter on last using char in text
  # %ecx :calculated number 
  # %esx :base eg 2, 8, 16

  movl 12(%ebp), %esi   
  movl 8(%ebp), %ebx
  movl $0, %ecx
  #movl $0, %esi # count started loop for debuging
  #movl $0, %esi # count started loop for debuging

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
    jle continue_calculate
    
    # Check if letter is legal.
    andb $0b00011111, %al         # Set first 3 bites to 0.
    # andb %al, 0b00011111       # Set first 3 bites to 0.


    cmpb $0b00011010, %al        # Check if letter < 'z'
    jg error_stringToNumber
    
    cmpb $0b00000001, %al        # Check  letter > 'a'
    jl error_stringToNumber
 
    addb $9, %al 		# adding 9 because A/a = 1. 

    jmp continue_calculate_for_letters
	
continue_calculate:
  
    #Change char'0' to int 0
    subl $48, %eax

continue_calculate_for_letters:
    # ecx = 10 * ecx + al
break123: 
    xchgl %eax, %ecx
    mull %esi
    xchgl %eax, %ecx
    
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

#
# Read 2 numbers and push it on stack.
#

#FUNCTION_READ
movl $FN_READ, %eax
movl $STD_IN, %ebx
movl $inputString, %ecx
movl $INPUT_SIZE, %edx
int $SYS_CALL

pushl $BAZE_SYSTEM
pushl $inputString 
call stringToNumber
add $8,%esp

push %eax

break1:

#FUNCTION_READ
movl $FN_READ, %eax
movl $STD_IN, %ebx
movl $inputString, %ecx
movl $INPUT_SIZE, %edx
int $SYS_CALL

pushl $BAZE_SYSTEM
pushl $inputString 
call stringToNumber
add $8,%esp

push %eax

break2:

#
# Call function add_i(int a, int b) from c-file.
#

#call myAddStack         # call function
#addl $8, %esp           # pop argument(s) from stack
#break3:
call _add_i

addl $8, %esp           # pop argument(s) from stack

#
# End program.
#

  movl %eax, %ebx
  movl $FN_EXIT, %eax
int $SYS_CALL

