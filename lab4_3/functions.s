.data

.text

.global fcheckCoreNumber
.type fcheckCoreNumber, @function

fcheckCoreNumber:
     pushq    %rbp
     movq     %rsp, %rbp

     push %rbx
     push %rcx
     push %rdx
     
     mov $1, %eax

     cpuid

     mov %ebx, %eax

     pop %rdx
     pop %rcx
     pop %rbx

     movq     %rbp, %rsp
     popq     %rbp
     ret

