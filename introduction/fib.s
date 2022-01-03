# Programme RISC-V qui calcule le n-ème nombre de la suite de Fibonacci:
#      n  = 0 1 2 3 4 5 6 7  ...
#  fib(n) = 0 1 1 2 3 5 8 11 ...
# Peut être exécuté sur le simulateur https://www.kvakil.me/venus/        
fib:    
	li	a5, 0
        li	a6, 1

        beqz   	a0, fin

debut:
	add	a7, a5, a6
        mv	a5, a6
        mv	a6, a7
        addi	a0, a0, -1
        bnez	a0, debut
fin:
        mv	a0, a5
        ret
