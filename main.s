.extern printf
.extern scanf
.extern rand
.extern srand

.section .data
user_seed:
    .space 4  
user_guess:
    .space 4
random_num:
    .space 4
num_tries:
    .space 4

.section .rodata
enter_configuration_fmt:
    .string "Enter configuration seed: "
scanf_fmt:
    .string "%d"
guess_promp_fmt:
    .string "What is your guess? "
incorrect_fmt:
    .string "Incorrect.\n"
congrats_fmt:
    .string "Congratz! You won!\n"
game_over_fmt:
    .string "Game over, you lost :(. The correct answer was %d\n"

.section .text
.globl main
.type main, @function

main:
    pushq %rbp
    movq %rsp, %rbp

    movq $enter_configuration_fmt, %rdi
    xorq %rax, %rax
    call printf

    movq $scanf_fmt, %rdi 
    movq $user_seed, %rsi
    xorq %rax, %rax
    call scanf

    movl user_seed, %edi
    xorq %rax,%rax
    call srand

    # make sure %rax is 0 before calling function
    xorq %rax, %rax 
    call rand
    # eax which is the return value from rand and is stored in lower bytes of number to be divided

    # edx is the higher bytes of the number to be divided. make it zero
    xorl %edx, %edx 

    movq $10, %rbx
    div %rbx # divide by 10

    # remainder is a number between 1-10 and is stored edx and then moved to random_num variable
    movl %edx, random_num 

    # initialize num tries with 0
    movq $0, num_tries

.Game:
    incl num_tries

    movq $guess_promp_fmt, %rdi
    xorq %rax, %rax
    call printf

    movq $scanf_fmt, %rdi 
    movq $user_guess, %rsi
    xorq %rax, %rax
    call scanf
 
    movl random_num, %ecx
    # check if random number is equal to user guess
    cmpl user_guess, %ecx

    jne .Next
    je .Congrats

.Next:

    movq $incorrect_fmt, %rdi
    xorq %rax, %rax
    call printf

    # check if num tries equals 5
    cmpl $5, num_tries

    je .Game_over
    jne .Game

.Game_over:

    movq $game_over_fmt, %rdi
    movl random_num, %esi
    xorq %rax, %rax
    call printf
    jmp .done

.Congrats:

    movq $congrats_fmt, %rdi
    xorq %rax, %rax
    call printf
    jmp .done

.done:
    xorq %rax,%rax
    movq %rbp, %rsp
    popq %rbp
    ret
