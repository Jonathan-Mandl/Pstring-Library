.extern pstrlen
.extern swapCase
.extern pstrijcpy
.extern printf
.extern scanf

.section .rodata
len_fmt:
    .string "first pstring length: %d, second pstring length: %d \n"
print_string_fmt:
    .string "length: %d, string: %s\n"
invalid_fmt:
    .string "invalid option!\n"
indexes_fmt:
    .string "%hhd %hhd"

.section .text
.globl run_func
.type run_func,  @function 

run_func:
    # function prologue
    pushq %rbp
    movq %rsp, %rbp

    subq $16, %rsp 

    # store  first string pointer in local variable
    movq %rsi,-8(%rbp)

    # store second string pointer in local variable
    movq %rdx,-16(%rbp)

    # check choice argument
    cmpq $31, %rdi
    je .call_len

    cmpq $33, %rdi
    je .call_swap

    cmpq $34, %rdi
    je .call_pstrijcpy

    jmp .invalid

.call_len:
    # make room for new local variable size 4 bytes
    subq $4, %rsp 
    
    # call pstrlen() with first pstring pointer 
    movq -8(%rbp),%rdi
    xorq %rax,%rax
    call pstrlen

    # store pstrlen() result in new int local variable
    movl %eax,-20(%rbp)

    # make room for new local variable size 4 bytes
    subq $4, %rsp 

    # call pstrlen() with second pstring pointer 
    movq -16(%rbp),%rdi
    xorq %rax,%rax
    call pstrlen

    # store pstrlen() result in new int local variable
    movl %eax,-24(%rbp)

    # make rsp multiple of 16
    subq $8,%rsp

    # set argument registers to 0
    xorq %rdx,%rdx
    xorq %rsi,%rsi

    # call printf function to print both lengths
    movq $len_fmt,%rdi
    movl -20(%rbp), %esi
    movl -24(%rbp), %edx
    xorq %rax, %rax
    call printf

    jmp .done


.call_swap:
    # call swapCase with first pstring pointer
    movq -8(%rbp),%rdi
    xorq %rax,%rax
    call swapCase

    # length stored in the first byte address in pstring returned struct is sent as second printf argument
    movzbq (%rax),%rsi 

    # increment pstring pointer (return from swapCase) to get to str section
    incq %rax 

   # store swapcase string result as third printf argument
    movq %rax,%rdx 

    # first printf argument is the str format
    movq $print_string_fmt, %rdi

    xorq %rax, %rax
    call printf

     # call swapCase with second pstring pointer
    movq -16(%rbp),%rdi
    xorq %rax,%rax
    call swapCase

    # get length field of returned psting and send as 2nd printf argument
    movzbq (%rax),%rsi

    # increment pstring pointer to get to str section
    incq %rax

    # swapcase return string is the third printf argument
    movq %rax,%rdx

    # str format is 1st printf argument
    movq $print_string_fmt, %rdi
    xorq %rax, %rax
    call printf

    jmp .done


.call_pstrijcpy:
    # the format is first scanf argument
    movq $indexes_fmt,%rdi

    # subtract 16 to ensure stack is aligned
    subq $16, %rsp

    # local variable for i,j are at (%rbp-17) & (%rbp-18).
    # send their addresses to scanf with leaq
    leaq -17(%rbp),%rsi
    leaq -18(%rbp),%rdx

    xorq %rax,%rax
    call scanf # call scanf

    # send 2 pstring adresses and i,j indexes to pstrijcpy()
    movq -8(%rbp),%rdi
    movq -16(%rbp),%rsi
    movb -17(%rbp),%dl
    movb -18(%rbp),%cl
    call pstrijcpy

    # move first byte from %rax which stores the pstring length (returned by function) as 2nd printf argument
    movzbq (%rax), %rsi

    # increment pstring pointer to get to string
    incq %rax

    # move str to 3rd printf arguments
    movq %rax,%rdx

    # str format is 1st printf argument
    movq $print_string_fmt, %rdi

    call printf

    movq $print_string_fmt, %rdi

    # move 2nd pstring pointer
    movq -16(%rbp),%rbx

    movzbq (%rbx),%rsi # send first byte of pointer (which is length) as 2nd prinf argument

    incq %rbx # get to str section

    movq %rbx,%rdx # send 2nd str as 3rd printf argument

    call printf

    jmp .done

.invalid:
    # print invalid string 
    movq $invalid_fmt,%rdi
    xorq %rax,%rax
    call printf
    jmp .done
    
.done:
    # function epilogue
    movq %rbp, %rsp
    popq %rbp
    ret











