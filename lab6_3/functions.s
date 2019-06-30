SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3

FN_READ = 0
FN_WRITE = 1
FN_EXIT = 60

.data 

.text
.global _start 
_start: 

#  # push $0xff00ff00ff00ff00ff00ff00ff00ff00
  movq $0xee00ee00ee00ee00, %rax
  movq $0x00ff00ff00ff00ff, %rbx
#  push $0xff00ff00ff00ff00ff00ff00ff00ff00
  push %rax
  push %rbx
  mov %rsp, %rcx
  sub $16, %rcx
  movq (%rcx), %mm0
  add $8, %rcx
  movq (%rcx), %mm1
  paddusb %mm0, %mm1
  mov %mm0, %rax
  mov %mm1, %rbx

  #FUNCTION EXIT
  mov $FN_EXIT, %rax
  mov $0, %rbx
  syscall

#   B Byte (8 bits)
#   W Word (16 bits)
#   D Double word (32 bits)
#   Q Quad word (64 bits)


# The signedness of the operation is also signified by the suffix: US for unsigned and S for signed.

# For example, PSUBUSB subtracts unsigned bytes, while PSUBSD subtracts signed double words.

# MMX defined over 40 new instructions, listed below.

# EMMS, MOVD, MOVQ, PACKSSDW, PACKSSWB, PACKUSWB, PADDB, PADDD, PADDSB, PADDSW, PADDUSB, PADDUSW, PADDW, PAND, PANDN, PCMPEQB, PCMPEQD, PCMPEQW, PCMPGTB, PCMPGTD, PCMPGTW, PMADDWD, PMULHW, PMULLW, POR, PSLLD, PSLLQ, PSLLW, PSRAD, PSRAW, PSRLD, PSRLQ, PSRLW, PSUBB, PSUBD, PSUBSB, PSUBSW, PSUBUSB, PSUBUSW, PSUBW, PUNPCKHBW, PUNPCKHDQ, PUNPCKHWD, PUNPCKLBW, PUNPCKLDQ, PUNPCKLWD, PXOR 
