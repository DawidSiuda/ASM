SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3

FN_READ = 0
FN_WRITE = 1
FN_EXIT = 60

.data 
  .strPath1: .string "ziemia.bmp\0" 
  .strPath2: .string "file2.bmp\0"
 
  .strContent: .string "data data data\n\0"
  strContent_size =.-.strContent 
  #file_out: .ascii "file1\0" 

  buffor: .space 1024

.text
.global _start 
_start: 
  # Open file1.
  mov $SYSOPEN, %rax  
  mov $.strPath1, %rdi 
  mov $FN_READ, %rsi   
  mov $0666, %rdx     
  syscall             
 
  push %rax
     
  # Open file2.
  mov $SYSOPEN, %rax  
  mov $.strPath2, %rdi 
  mov $FN_WRITE, %rsi   
  mov $0666, %rdx     
  syscall             

  push %rax 

break0:                  
  # Read the first file  
  mov $SYSREAD, %rax
  mov 8(%rsp), %rdi   
  mov $buffor, %rsi 
  mov $1024, %rdx        
  syscall 

  mov %rax, %rbx # Save lenght of read string.     

break1:                 
  # Write into the second file.  
  mov $SYSWRITE, %rax
  mov (%rsp), %rdi   
  mov $buffor, %rsi 
  mov %rbx, %rdx        
  syscall 
 
  # Close file2.
  mov $SYSCLOSE, %rax 
  mov (%rsp), %rdi       
  syscall            

  pop %rax

  # Close file1.
  mov $SYSCLOSE, %rax 
  mov (%rsp), %rdi       
  syscall            

  pop %rax
  
  #FUNCTION EXIT
  mov $FN_EXIT, %rax
  mov $0, %rbx
  syscall
