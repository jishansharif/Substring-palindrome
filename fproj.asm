%include "simple_io.inc"
   
global  asm_main

SECTION .data

bordar: dq 0,0,0,0,0,0,0,0,0,0,0,0           ;; qword array of size 10
err1: db "input string too long",10,0
err2: db "incorrect number of command line arguments",10,0
string_message: db "input string:",0
debug: db "This line gets called", 10,0
max: dq 0
isborder: dq 1
length: dq 0
inputBoardar: db "border array: ",0
spaces: db "     ",0
pluses:  db "+++  ",0
dots:   db "...  ",0

SECTION .text

maxbord:
   enter	0,0               ; setup routine
   saveregs                ; save all registers

   mov	r15, [rbp+24]     ; 1st parameter which is a string
   mov r14, [rbp+32]      ; 2nd parameter which is the length
   mov qword [max], 0
   mov qword [length], r14
   mov r12, qword 1             ; Counter for the first loop
   FOR_LOOP:
       cmp r12, r14
       jae END_LOOP
       mov qword [isborder], qword 1
       ;; r is now in r12 and i is rcx
       mov rcx, qword 0              ; Counter for second loop
       NESTED_LOOP:
           cmp  rcx, r12
           jae END_NESTED_LOOP
           ;; i is rcx
           mov rbx, [r15+rcx]   ; string i
           mov r13, [length]    ;r13 is a copy of the length 
           sub r13, r12         ; L-r here
           add r13, rcx         ; (L-r) + i here
           mov r13, [r15+r13]
           cmp bl, r13b
           ;;Insert lines of code where we do string comparison
           ;;If comparison is true go to another branch
           je CONTINUE_NESTED_LOOP
           mov qword [isborder], qword 0
           jmp END_NESTED_LOOP

       CONTINUE_NESTED_LOOP:
           inc rcx
           jmp NESTED_LOOP 

       END_NESTED_LOOP:
           cmp qword [isborder], qword 1
           je RETURN_MAX
           inc r12
           jmp FOR_LOOP
           
       RETURN_MAX:
           cmp qword [max], r12
           jge RETURN_TO_LOOP
           mov qword [max], r12
           jmp RETURN_TO_LOOP

       RETURN_TO_LOOP:
           inc r12
           jmp FOR_LOOP

    END_LOOP:
        mov rax, qword [max]

    EXIT_MAXBORD:
        restoregs
        leave
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
simple_display:
   enter	0,0               ; setup routine
   saveregs                   ; save all registers
   mov	r15, [rbp+24]         ; 1st parameter which is an arraylist bordar
   mov r14, [rbp+32]          ; 2nd parameter which is the length

   mov rax, inputBoardar      ; This is the input message
   call print_string
   mov rax, qword [r15]
   call print_int
   mov rbx, r15               ;rbx has the array bordar
   add rbx, qword 8

   display_values:
       mov r13, qword 1     ; Counter for loop
   INNER_LOOP_SIMPLE_DISPLAY:
       cmp r13, r14
       jae END_LOOP_SIMPLE_DISPLAY
       mov al, ','
       call print_char
       mov al, ' '
       call print_char
       mov rax, qword [rbx]
       call print_int
       inc r13
       add rbx, qword 8
       jmp INNER_LOOP_SIMPLE_DISPLAY

   END_LOOP_SIMPLE_DISPLAY:
       call print_nl

   END_SIMPLE_DISPLAY:
       restoregs
       leave
       ret  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fancy_display:
   enter	0,0               ; setup routine
   saveregs                   ; save all registers
   mov	r15, [rbp+24]         ; 1st parameter which is an arraylist bordar
   mov r14, [rbp+32]          ; 2nd parameter which is the length

   mov rbx, r14

   START_FANCY_DISPLAY_LOOP:
       cmp rbx, qword 0
       jbe END_FANCY_DISPLAY

       push r14
       push rbx
       push r15
       call display_line
       add rsp, 24
       dec rbx
       jmp START_FANCY_DISPLAY_LOOP

   END_FANCY_DISPLAY:
       restoregs
       leave
       ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

display_line:
   enter	0,0               ; setup routine
   saveregs                   ; save all registers
   mov	r13, [rbp+16]         ; 1st parameter which is an arraylist bordar
   mov  r14, [rbp+24]         ; 2nd parameter which is the level
   mov  r15, [rbp+32]         ; 3rd parameter which is the length

   mov r9, qword 0; count variable

   START_DISPLAY_LINE_LOOP:
       inc r9
       cmp r9, r15
       jg BREAK_LOOP
       cmp r14, qword 1
       je NESTED_CONDITIONS
       cmp qword [r13], r14
       jge PRINT_PLUS_ELSE
       mov rax, spaces
       call print_string
       add r13, qword 8
       jmp START_DISPLAY_LINE_LOOP

    NESTED_CONDITIONS:
        cmp qword [r13], qword 0
        jle PRINT_DOTS
        mov rax, pluses
        call print_string
        add r13, qword 8
        jmp START_DISPLAY_LINE_LOOP

    PRINT_DOTS:
        mov rax, dots
        call print_string
        add r13, qword 8
        jmp START_DISPLAY_LINE_LOOP

    PRINT_PLUS_ELSE:
        mov rax, pluses
        call print_string
        add r13, qword 8
        jmp START_DISPLAY_LINE_LOOP

    BREAK_LOOP:
        call print_nl

   END_DISPLAY_LINE:
       restoregs
       leave
       ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_main:
   enter	0,0             ; setup routine
   saveregs              ; save all registers
	
   cmp rdi, qword 2         ; argc should be 2
   jne ERR2

	mov	rbx, qword [rsi+8]
	mov	r12, qword 0
   try1:
        mov al , byte [rbx] 
        cmp al, 0
        je END_COUNT
        inc r12
        inc rbx
        jmp try1
    
    END_COUNT:
        cmp r12, 12
        ja ERR1
        mov rax, string_message
        call print_string
        mov rax, qword [rsi+8]
        call print_string
        call print_nl
        
    mov r13, r12 ;; L1 is basically r13 (Length)
    dec r12 ;; Decrease the length of the string by 1 because we iterate through L-1 in python
    mov r14, 0
    mov r15, qword [rsi+8] ;; input string here
    mov rcx, bordar
    CALL_SUBROUTINE:
        push r13
        push r15
        sub rsp, 8
        call maxbord
        add rsp, 24
        mov [rcx], rax
        add rcx, qword 8
        inc r15
        inc r14
        dec r13
        cmp r14, r12
        jb CALL_SUBROUTINE

    END_CALL_SUBROUTINE:
        mov rcx, bordar
        inc r12
        push r12, ;;r12 is the length
        push rcx,
        sub rsp, 8
        call simple_display
        add rsp, 24

        push r12
        push rcx,
        sub rsp,8
        call fancy_display
        add rsp, 24
        jmp asm_main_end

 ERR1:
   mov rax, err1
   call print_string
   jmp asm_main_end

 ERR2:
   mov rax, err2
   call print_string
   jmp asm_main_end

 asm_main_end:
   restoregs                  ; restore all registers
   leave                     
   ret
