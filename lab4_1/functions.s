.data
# control_word: .short 0

.text
# Zadeklarowane tutaj funkcje będą możliwe do wykorzystania
# w języku C po zlinkowaniu plików wynikowych kompilacji obu kodów
.global ustaw, sprawdz
.type ustaw, @function
.type sprawdz, @function

ustaw:
    pushq    %rbp
    movq     %rsp, %rbp
    # Pierwszy i jedyny parametr funkcji umieszczony zostanie
    # w rejestrze RDI. Może on zawierać jedną z trzech wartości:
    # 1 dla single, 2 dla double i 3 dla extended

    # Pobranie zawartości rejestru kontrolnego do rejestru AX
    # przez komórkę w pamięci
    movq     $0, %rax
    fstcw   (%rsp)
    subq    $2, %rsp
    fwait
    mov     2(%rsp), %ax
    addq    $2,%rsp

    # Wyzerowanie bitów kontroli prezycji (00 - początkowo single)
    and     $0xFCFF, %ax # 1111 1100 1111 1111

    # Zamiana na double lub extended w zależności
    # od przesłnego parametru
    cmpq     $2, %rdi
    jl      koniec
    je      double

    # Zmiania na extended (11)
    extended:
    xor     $0x300, %ax # 0000 0011 0000 0000
    jmp     koniec # Aby nie zmienić na double

    # Zmiana na double (10)
    double:
    xor     $0x200, %ax # 0000 0010 0000 0000

    koniec:
    # Zapisanie słowa kontrolnego z rejestru AX do rejestru CW
    # mov     %ax, control_word
    mov     %ax, (%rsp)
    fldcw   (%rsp)
    # ldcw   control_word

    movq     %rbp, %rsp
    popq     %rbp
    ret

; sprawdz:
;     pushq    %rbp
;     movq     %rsp, %rbp

;     # Pobranie słowa kontrolnego FPU so rejestru AX
;     movq     $0, %rax
;     fstcw   control_word
;     fwait
;     mov     control_word, %ax

;     # Wyzerowanie pozostałych bitów poza bitami kontroli precyzji
;     # i przesunięcie wygenerowanych bitów w prawo na koniec
;     and     $0x300, %ax # 0000 0011 0000 0000
;     shr     $8, %ax
;     # Wartość zwracana znajduje się już w EAX. Przyjmuje wartości:
;     # 0 dla single, 2 dla double i 3 dla extended

;     movq     %rbp, %rsp
;     popq     %rbp
;     ret
