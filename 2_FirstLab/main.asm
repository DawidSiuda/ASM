SYSCALL32 = 0x80        # wywołanie funkcji standardowej
EXIT = 1                # nr funkcji restartu (=1) – zwrot sterowania do s.o.
STDIN = 0               # nr wejścia standardowego (klawiatura) do %ebx
READ = 3                # nr funkcji odczytu wejścia (=3)
STDOUT = 1              # nr wyjścia standardowego (ekran tekstowy) do %ebx
WRITE = 4               # nr funkcji wyjścia (=4)
BUF_SIZE = 80           # rozmiar bufora (1 linia tekstu)

.data BUF: .space B_SIZE      # deklaracja bufora wejścia

.text
.globl _start
_start:
movl $READ, %eax        # czytanie łańcucha z wejścia standardowego
movl $STDIN, %ebx       # 
movl $BUF, %ecx         # 
movl $B_SIZE, %edx      # 
int $SYSCALL32          # w %eax zwraca liczbę wczytanych znaków

movb BUF, %dl           # kod ASCII klucza (duża litera)
subb $’A’, %dl          # klucz – nr znaku (‘Z’-
movb $’ ‘, BUF          # kod spacji do bufora (ukrycie klucza)

xorl %esi, %esi         # zerowanie indeksu
cipher: incl %esi
movb BUF(%esi), %al     # kolejny znak do przetworzenia
cmpb $’\n’, %al
je out                  # ostatni znak w buforze
orb 0x20, %al           # zamiana każdej litery na wielką (0x20=0b00100000=040)
cmpb $`A`, %al          # sprawdzenie, czy znak jest literą
jlt hop
cmpb $’Z’, %al jgt hop
addb %dl, %al           # szyfrowanie
cmpb $’Z’, %al
jle hop
subb $’Z’, %al          # korekta kodu
hop: movb %al, BUF(%esi)     # zaszyfrowany znak do bufora
jmp cipher

out: movl $WRITE, %eax       # wyprowadzenie zawartości bufora na wyjście
movl $STDOUT, %ebx 
movl $BUF, %ecx 
movl $B_SIZE, %edx 
int $SYSCALL32

movl $EXIT, %eax        # restart – zakończenie programu
int $SYSCALL32 

