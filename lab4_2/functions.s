.data

.text

.global fcheck, fset, fcheckFPSR
.type fcheck, @function
fcheck:
     pushq    %rbp
     movq     %rsp, %rbp
     
     # Get register
     subq    $2, %rsp
     movw    $0, (%rsp)
     fstcw   (%rsp)
     fwait
  
     movq    $0, %rax
     movw    (%rsp), %ax
     addq    $2, %rsp

     # Set to 0 other bits and shift bits to left.
     and     $0x300, %ax # 0000 0011 0000 0000
     shr     $8, %ax

     movq     %rbp, %rsp
     popq     %rbp
     ret

.type fset, @function
fset:
     pushq    %rbp
     movq     %rsp, %rbp
    
     # Get register to %rax
     subq    $2, %rsp
     fstcw   (%rsp)
     fwait
     movq    $0, %rax
     movw    (%rsp), %ax
     addq    $2, %rsp

     # switch
     cmp     $0, %rdi
     je      jSet00
 
     cmp     $1, %rdi
     je      jSet01
     
     cmp     $2, %rdi
     je      jSet10

     cmp     $3, %rdi
     je      jSet11

     jSet00:
          andw $0xfcff, %ax
          jmp  jLoadBackToReg
     jSet01:
          andw $0xfcff, %ax
          orw  $0x0100, %ax
          jmp  jLoadBackToReg
     jSet10:
          andw $0xfeff, %ax
          orw  $0x0200, %ax
          jmp  jLoadBackToReg
     jSet11:
          orw  $0x0300, %ax
          jmp jLoadBackToReg
     
     # Load new value back to register.
     jLoadBackToReg:
          subq    $2, %rsp
          movw    %ax, (%rsp)
          fldcw   (%rsp)
          addq    $2, %rsp

          movq     %rbp, %rsp
          popq     %rbp
     ret

# 35

.type fcheckFPSR, @function
fcheckFPSR:
     pushq    %rbp
     movq     %rsp, %rbp

     # Load register to eax.
     # subq    $2, %rsp
     # fstws  (%rsp)
     movq $0, %rax
     fstsw   %ax
     # fwait   
     # movq    $0, %rax
     # movw    (%rsp), %ax
     # addq    $2, %rsp

     movq     %rbp, %rsp
     popq     %rbp
     ret
