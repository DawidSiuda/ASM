.bss

.text
.global fun
.type fun, @function

.global fun
fun:
     pushq %rbp
     movq  %rsp, %rbp
# rdi = c
# rsi = b
# rdx = a
     pop %rsi

     fldl  qword (%rsi)
#     flds -8(%ebp) 
#    fld    qword [a]   ;load a into st0
#    fmul   st0, st0    ;st0 = a * a = a^2


    # fstpl (%rsp)

     pop %rax
     # mov %rax, %rax
     movq %rbp, %rsp
     popq %rbp
     ret
