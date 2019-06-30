.text
########################################################################
# long myFactorial(long a)
#######################################################################
.global myFactorial
.type myFactorial, @function
myFactorial:
  # Set stack frame.
  pushq %rbp
  movq %rsp, %abp

  cmpq $1, %rdi
  je return_value

  pushq %rdi  
  subq $1, %rdi
   
  call myFactorial

  pop %rbx
  imulq %rbx, %rax
  
break1:
  # Restore stack.
  popq %rbp
ret

  # else 
return_value:
  movq $1, %rax

  # Restroe stack.
  popq %rbp
ret

