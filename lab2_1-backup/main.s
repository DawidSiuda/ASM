SYS_CALL = 0X80

FN_EXIT = 1
FN_READ  = 3 
FN_WRITE = 4

STD_IN = 0
STD_OUT = 1

SHIFT = 3

.data
  buffor: .space 80
  encrypted_buffor: .space 80
  .Str1: .string "String before encrypted:\n\r"
  str1_size =.-.Str1
  .Str2: .string "String after encrypted:\n\r"
  str2_size =.-.Str2

.text
.global _start
_start:

# function read
  movl $FN_READ, %eax
  movl $STD_IN, %ebx
  movl $buffor, %ecx
  movl $80, %edx
int $SYS_CALL

jmp exit_loop # skip changing letters on large/small

# upper letters 
  movl $buffor, %edx  # move address of letters to edx

 my_loop:             # place when loop is started 
    movb (%edx), %al  # copy char to eax 
    
    cmpb $0, %al      # check if end 
    je exit_loop      # jump to exit_loop if its end 

    cmpb $10, %al     # check if "/n" 
    je exit_loop      # jump to exit_loop if its "/n"  
    
    xorb $32, %al
    #orb $32, %al     # make lower 
    #andb $223, %al    # make upper 
  
    movb %al, (%edx)  # mov char back to the buffer 
    inc %edx          # increment poniter to char in buffer 
    jmp my_loop       # jump to my_loop
exit_loop:

# function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $.Str1, %ecx
  movl $str1_size, %edx
int $SYS_CALL 
# function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $buffor, %ecx
  movl $80, %edx
int $SYS_CALL 

# CEZAR  : a...z -> A...Z -> a...
  # %edx :pointer on last downloaded char from buffer
  # %al  :current processing char
  # %ecx :pointer on end of output string
  
  movl $buffor, %edx        # grab addres of the first char
  movl $encrypted_buffor, %ecx # set pointer on place of output text
  cezar_loop:
    movb (%edx), %al        # mov char to eax

    # check if end of text
    cmpb $'\n', %al         # check if "/n" 
    je cezar_exit           # jump to exit_loop if its "/n"  

    # check if its space 
    cmpb $' ', %al          # check if " " 
    je cezar_skip_letter    # skip char if its space  
    
    # check if letter is small or large
    cmpb $'Z', %al           # check if char is large letter
    jle large_char          # if char is large, jump to large_char
    
    # for small letter
    addb $SHIFT, %al         # shift letter
    cmpb $'z', %al           # check if new char is legal
    jle cezar_end_iteration # skip to end if letter is legar, change to large in other case 
    subb $58, %al             
    jmp cezar_end_iteration 
    
    # for large letter
    large_char:
      addb $SHIFT, %al       # shift letter
      cmpb $'Z', %al         # check if new char is legal
      jle cezar_end_iteration # skip to end if letter is legar, change to small in other case
      addb $6, %al
      jmp cezar_end_iteration # jump to end
      
    # other operations
    cezar_end_iteration:
      movb %al, (%ecx)  # mov char back to the buffer 
      inc %ecx
    cezar_skip_letter:
      inc %edx          # increment poniter to char in buffer 
      jmp cezar_loop
  cezar_exit:
    # add end of line and end of string to output string 
    movb $'\n', 1(%ecx)
    movb $0, 2(%ecx)


# function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $.Str2, %ecx
  movl $str2_size, %edx
int $SYS_CALL 
# function write
  movl $FN_WRITE, %eax
  movl $STD_OUT, %ebx
  movl $encrypted_buffor, %ecx
  movl $80, %edx
int $SYS_CALL 

#FUNCTION EXIT
  movl $FN_EXIT, %eax
  movl $0, %ebx
int $SYS_CALL

