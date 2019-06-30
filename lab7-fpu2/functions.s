.data
strFirstRoot:   .ascii "The first root: %f\n\0"
strSecondRoot:  .ascii "The second root: %f\n\0" 

.text
.global fun
.type fun, @function

.global fun
fun:
     pushl %ebp
     movl  %esp, %ebp

# rdi = c
# rsi = b
# rdx = a

# 8(%ebp), = c
# 12(%ebp) = b
# 16(%ebp) = a

break1:
     # b^2
     flds 12(%ebp)
     fmuls 12(%ebp)
     fstps -4(%ebp)

break2:
     # 4*ac
     flds 8(%ebp)
     fmuls 16(%ebp)
     fmuls Number4
     
     
break3:
     fadds -4(%ebp)      # b^2 + 4ac

berak4:
     fsqrt               # Square roor.
     fstps -4(%ebp)      # Save result.

     flds 16(%ebp)       # Load a.
     fadd  %st(0), %st   # 2*a.
     fstps -8(%ebp)      # Save result.

     flds 12(%ebp)       # Load b.
     fchs                # Change sign of b.

     fsubs -4(%ebp)      # -b - Square roor of delete

     fdivs -8(%ebp)      # Devide resulst by 2a.
     fstps -12(%ebp)     # Save result.

     flds 12(%ebp)       # Load b.
     fchs                # Change sign of b.

     fadds -4(%ebp)      # -b + Square roor of delete

     fdivs -8(%ebp)      # Devide resulst by 2a.
     fstps -20(%ebp)     # Save result.

     movl 

     push -20(%ebp) 
     push $strFirstRoot
     call printf


     movl %ebp, %esp
     popl %ebp
     ret

Number4:
.long   1082130432
