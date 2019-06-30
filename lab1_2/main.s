SYS_CALL = 0X80

FN_EXIT = 1
FN_READ  = 3 
FN_WRITE = 4

STD_IN = 0
STD_OUT = 1

.data
  buffor: .space 80
  binary_buffer: .space 640
.text
.global _start
_start:

# function read
  movl $FN_READ, %eax
  movl $STD_IN, %ebx
  movl $buffor ,%ecx
  movl $80 ,%edx
int $SYS_CALL

# upper letters 
  movl $buffor, %edx  # move address of letters to edx

 my_loop:             # place when loop is started 
    movb (%edx), %al  # copy char to eax 
    
    cmpb $0, %al      # check if end 
    je exit_loop      # jump to exit_loop if its end 

    cmpb $10, %al     # check if "/n" 
    je exit_loop      # jump to exit_loop if its "/n"  
    
    #orb $32, %al     # make lower 
    andb $223, %al    # make upper 
  
    movb %al, (%edx)  # mov char back to the buffer 
    inc %edx          # increment poniter to char in buffer 
    jmp my_loop       # jump to my_loop
exit_loop:

# CERAR

   #subl 4, %esp
   #movl 0, -4(ebp)
  movl $buffor, %edx
  cezar_loop:
   
    # check if end of text
    cmpb $0, %al      # check if end 
    je cezar_exit     # jump to exit_loop if its end 

    cmpb $10, %al     # check if "/n" 
    je cezar_exit     # jump to exit_loop if its "/n"  

    # check if letter is small or large
    movb (%edx), %al  # mov char to eax
    cmpb $91,%al      # check if char is large letter
    jl large_char     # if char is large, jump to large_char
    
    # for small letter
    addb $3,%al
    cmpb $122,%al     # check if new char is legal
    jge cezar_subtrac # large or equal
    jmp cezar_end_iteration
    
    # for large letter
    large_char:
      addb $3,%al
      cmpb $91,%al     # check if new char is legal
      jge cezar_subtrac # laarge or equal
      jmp cezar_end_iteration # jump to end
      
    # other operations
    cezar_subtrac:
      subb $16,%al
    cezar_end_iteration:
      movb %al, (%edx)  # mov char back to the buffer 
      inc %edx          # increment poniter to char in buffer 
      jmp cezar_loop
  cezar_exit: 
   


# function write
  movl $FN_WRITE ,%eax
  movl $STD_OUT ,%ebx
  movl $buffor ,%ecx
  movl $80 ,%edx
int $SYS_CALL 

#FUNCTION EXIT
  movl $FN_EXIT, %eax
  movl $0, %ebx
int $SYS_CALL

