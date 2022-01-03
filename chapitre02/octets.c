#include <stdint.h>
#include <stdio.h>

union Mot
{
  uint32_t valeur;
  uint8_t  octets[4];
};

int main()
{
  union Mot mot;
  
  scanf("%X",   &mot.valeur);    // Sur entrée A1B2C3D4,
  printf("%02X", mot.octets[0]); // affiche:
  printf("%02X", mot.octets[1]); // A1B2C3D4 si big-endian
  printf("%02X", mot.octets[2]); // D4C3B2A1 si little-endian
  printf("%02X", mot.octets[3]);
}
