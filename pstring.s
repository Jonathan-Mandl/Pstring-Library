.extern printf

.section .rodata
invalid_fmt:
    .string "invalid input!\n"

.section .text

.globl pstrlen
.type	pstrlen, @function 

pstrlen:
    # function prologue
    pushq %rbp
    movq %rsp, %rbp 

    sub $4, %rsp
    # counter of letters variable initialized to 0
    movl $0,-4(%rbp)

    # increment pointer of struct to get to the string section
    incq %rdi

.loop_count:
    # Read byte from string
    movb (%rdi), %al

    # If we're at the end of the string, jump to done section
    cmpb $0x0, %al
    je .done_count
    # otherwise goes to next
    jmp .next_count

.next_count:
    # increment character counter
    incl -4(%rbp)
    incq %rdi # increment str pointer
    jmp .loop_count

.done_count:
    movl -4(%rbp),%eax # return character counter
    # function epilogue
    movq %rbp, %rsp 
    popq %rbp
    ret

.globl swapCase
.type	swapCase, @function 

swapCase:
    # prologue 
    pushq %rbp
    movq %rsp, %rbp 
    
    # create local variable to store pstring pointer
    subq $8,%rsp
    movq %rdi,-8(%rbp)

.loop_swap:
    # increment pointer
    incq %rdi

    # Read byte from string
    movb (%rdi), %al

    # in case end was reached jump to done section
    cmpb $0x0, %al
    je .done_swap

    # compare byte to ascii value to determine. if <=90 its caps
    cmpb $90, %al
    jle .to_little

    # compare byte to ascii value to determine. if >=97 its little letters
    cmpb $97, %al
    jge .to_caps

    # otherwise continue loop
    jmp .loop_swap

.to_caps:

    cmpb $122, %al
    jg .loop_swap

    # decrease ascii value by 32 to turn to capital letter
    subb $32,%al
    movb %al,(%rdi)
    jmp .loop_swap

.to_little:

    cmpb $65, %al
    jl .loop_swap

    # increase ascii value by 32 to turn to little letter
    addb $32,%al
    movb %al,(%rdi)
    jmp .loop_swap

.done_swap:
    # store pstring pointer in return register
    movq -8(%rbp),%rax
    # function epilogue
    movq %rbp, %rsp
    popq %rbp
    ret


.globl pstrijcpy
.type	pstrijcpy, @function 
pstrijcpy:
    # function prolog
    pushq %rbp
    movq %rsp, %rbp

    subq $16,%rsp

    # move 1st pstring pointer local variable
    movq %rdi,-8(%rbp)

    # check indexes are not larger than the lengths of the 2 pstrings. length is stored in 1st byte of pstring adress
    cmpb (%rdi),%cl
    jge .invalid

    cmpb (%rdi),%dl
    jge .invalid

    cmpb (%rsi),%dl
    jge .invalid

    cmpb (%rsi),%cl
    jge .invalid

    cmpb %cl,%dl
    jge .invalid

    # move to i,j to regular registers
    movzbq %dl,%r8
    movzbq %cl,%r9

    # increment indexes by 1 because the string starts from index 1 of struct and not 0 
    incq %r8
    incq %r9

.copy_loop:

    movb (%rsi,%r8),%al
    movb %al,(%rdi,%r8)

    incq %r8

    cmpq %r9,%r8

    jg .end
    jmp .copy_loop

.invalid:

    movq $invalid_fmt, %rdi
    xorq %rax,%rax
    call printf

    jmp .end

.end:
    # return 1st pstring pointer
    movq -8(%rbp), %rax

    # epilog
    movq %rbp, %rsp
    popq %rbp
    ret


































