SYS_CALL = 0X80

FN_EXIT = 60
FN_READ  = 0
FN_WRITE = 1
FN_OPEN_FILE = 2
FN_CLOSE_FILE = 3


STD_IN = 0
STD_OUT = 1

# File operating mode
O_RDONLY  = 0
O_WRONLY  = 1
O_RDWR  = 2

.data
     .strPath: .string "/home/dawid/assembler/lab4_4/file\0"
     .strContent: .string "data data data\n\r\0"
     strContent_size =.-.strContent

.text
.global _start
_start:
     # Open file.
     mov $FN_OPEN_FILE, %rax
     mov $.strPath, %rdi
     mov $O_RDONLY, %rsi
     mov $0777, %rdx
     int $SYS_CALL


break1:
     pushq %rax

     mov $FN_WRITE, %rax
     mov (%rsp), %rdi
     mov $.strContent, %rsi
     mov $strContent_size, %rdx
     int $SYS_CALL


     mov FN_CLOSE_FILE, %rax
     mov (%rsp), %rdi
     int $SYS_CALL

     popq %rax

     #FUNCTION EXIT
     mov $FN_EXIT, %rax
     mov $0, %rbx
     int $SYS_CALL
