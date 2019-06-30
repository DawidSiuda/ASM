.data	
.align 32
format_string:  
	.ascii "Hello! %s is a %s who loves the number %d\n\0"

text1: 
	.ascii "Tekst1\0"   # pierwszy parameter %s (łańcuch znaków zakończony \0) 
text2:
	.ascii "Tekst2\0"   # drugi parameter %s (łańcuch znaków zakończony \0) 
number: 
	.long 3            # trzeci parameter %d (liczba dziesiętna)

.extern printf	
.text 

.global main
main:

movl number, %ecx
movl $text2, %edx
movl $text1, %esi
movl $format_string, %edi
movl $0, %eax

call printf

call exit                  # funkcja zakończenia programu


 
