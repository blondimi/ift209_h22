#include <stdio.h>

// Exemple d'entrées/sorties en C avec traduction en lang. d'assemblage ARMv8
int main()
{
                                // .section ".rodata"
  const char FORMAT1[] = "%lu"; // FORMAT1:  .asciz  "%lu"
  const char FORMAT2[] = "%ld"; // FORMAT2:  .asciz  "%ld"
  const char CHAINE1[] = "Entrez un entier non signé, puis un entier signé.\n";
  const char CHAINE2[] = "Premier  nombre entré: %lu.\n";
  const char CHAINE3[] = "Deuxième nombre entré: %ld.\n";
  const char CHAINE4[] = "Vos deux nombres: %lu, %ld.\n";

                         // .section ".bss"
  unsigned long a;       // a:  .skip  8
  long b;                // b:  .skip  8
                         //
                         // .section ".text"
  printf(CHAINE1);       // adr x0, CHAINE1  bl printf
  scanf(FORMAT1, &a);    // adr x0, FORMAT1  adr x1, a   bl scanf
  scanf(FORMAT2, &b);    // adr x0, FORMAT2  adr x1, b   bl scanf
  printf(CHAINE2, a);    // adr x0, CHAINE2  ldr x19, a  mov x1, x19  bl printf
  printf(CHAINE3, b);    // adr x0, CHAINE3  ldr x19, b  mov x1, x19  bl printf
  printf(CHAINE4, a, b); // adr x0, CHAINE4  ldr x19, a  mov x1, x19  ldr x19, b  mov x2, x19  bl printf
}
