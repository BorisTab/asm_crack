format ELF64 executable 3
entry start

segment readable executable
start:
    mov     rax, 4
    mov     rbx, 1
    mov     rcx, title
    mov     rdx, titleSz
    int     80h

    mov     rax, 4
    mov     rbx, 1
    mov     rcx, pass
    mov     rdx, passSz
    int     80h

    call    getPass
    call    checkPass

exit:
    mov     rax, 1
    xor     rbx, rbx
    int     80h

;===========================================
;return rax - ptr to pass
;===========================================
getPass:
    mov     rax, 3
    xor     rbx, rbx
    mov     rcx, readPass
    mov     rdx, 100h
    int     80h

    mov     rax, getPass
    ret

win:
    mov     rax, 4
    mov     rbx, 1
    mov     rcx, correct
    mov     rdx, correctSz
    int     80h

    ret


checkPass:
    xor     rax, rax
    xor     rbx, rbx
    xor     rdx, rdx
    mov     rcx, 5
checkLoop1:
    mov     al, [readPass + rcx - 1]
    mov     bl, [password + rdx]
    inc     rdx
    cmp     al, bl
    jne     lose
    loop    checkLoop1

    mov     rsi, readPass + 5
    mov     al, [rsi]
    mov     bl, [rsi + 2]
    xor     al, bl
    shr     rax, 4
    inc rsi

    mov     cl, [rsi]
    mov     dl, [rsi + 2]
    xor     cl, dl
    inc     rsi

    shl     rax, 4
    shr     rcx, 4
    or      rcx, rax

    mov     al, [rsi + 2]
    
    xor     al, cl
    add     rax, start
    cmp     rax, win
    jne     lose

    jmp     rax

    ret

lose:
    mov     rax, 4
    mov     rbx, 1
    mov     rcx, wrong
    mov     rdx, wrongSz
    int     80h

    ret


segment readable writeable
title       db  "Small kitten is dying of starvation.", 10, "Enter your password to feed small kitten!", 10, 0
titleSz = $ - title
pass        db  "Password: ", 0
passSz = $ - pass
correct     db  "Great, kitten is alive!", 10, "  |\_._/|", 10, "  | o o |", 10, "  (  T  )", 10, " .^`-^-'^.", 10, " `.  ;  .'", 10, " | | | | |", 10, "((_((|))_))", 10, 0
correctSz = $ - correct

readPass    db  10 dup (0)
password    db  "lifeforcat", 0

wrong       db  "Oh no, you couldn't save kitten(((", 10, 0
wrongSz = $ - wrong
