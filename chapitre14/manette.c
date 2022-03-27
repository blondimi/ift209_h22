#include <stdio.h>     // fclose, fopen, printf, read_event, FILE
#include <asm/types.h> // __s16, __u8, __u32

// Testé en classe avec une manette de jeu F310 Logitech
// (https://www.logitechg.com/fr-ca/products/gamepads/f310-gamepad.940-000110.html)

// Voir, par ex.
// - https://www.kernel.org/doc/html/latest/input/joydev/joystick-api.html
// - https://www.kernel.org/doc/Documentation/input/event-codes.txt
// - https://www.kernel.org/doc/Documentation/input/gamepad.txt
// - https://www.kernel.org/doc/Documentation/input/input.txt
struct input_event {
  __u32 time;
  __s16 value;
  __u8  type;
  __u8  number;
};

#define EV_INIT 0x80
#define EV_KEY  0x01
#define EV_REL  0x02

// Codes (et bits) des boutons et directions
#define BTN_A   0x00
#define BTN_B   0x01
#define BTN_X   0x02
#define BTN_Y   0x03
#define BTN_L   0x04
#define BTN_R   0x05
#define PAD_LR  0x06
#define PAD_UD  0x07

// Bits des flèches
const __u8 PAD_L = 0x00;
const __u8 PAD_R = 0x01;
const __u8 PAD_U = 0x02;
const __u8 PAD_D = 0x03;

void print_controller(__u8 buttons, __u8 joypad)
{
  const char* PAD_ACTIVE[]   = {"🡄", "🡆", "🡅", "🡇"};
  const char* PAD_INACTIVE[] = {"\033[1;90m🡄\033[39m", "\033[1;90m🡆\033[39m",
                                "\033[1;90m🡅\033[39m", "\033[1;90m🡇\033[39m"};
  const char* BTN_ACTIVE[]   = {"\033[1;32m🅐\033[39m", "\033[1;31m🅑\033[39m",
                                "\033[1;34m🅧\033[39m", "\033[1;33m🅨\033[39m",
                                "🅻", "🆁"};
  const char* BTN_INACTIVE[] = {"\033[1;32mⒶ\033[39m", "\033[1;31mⒷ\033[39m",
                                "\033[1;34mⓍ\033[39m", "\033[1;33mⓎ\033[39m",
                                "\033[1;90m🅻\033[39m", "\033[1;90m🆁\033[39m"};
  const char* LAYOUT = "    %s         %s     \n" \
                       "                     \n" \
                       "    %s         %s     \n" \
                       "  %s   %s     %s   %s \n" \
                       "    %s         %s     \n\n";

  printf("\033c\n"); // Effacer terminal
  printf(LAYOUT,     // Afficher état de la manette
         (buttons & (1 << BTN_L)) ? BTN_ACTIVE[BTN_L] : BTN_INACTIVE[BTN_L],
         (buttons & (1 << BTN_R)) ? BTN_ACTIVE[BTN_R] : BTN_INACTIVE[BTN_R],
         (joypad  & (1 << PAD_U)) ? PAD_ACTIVE[PAD_U] : PAD_INACTIVE[PAD_U],
         (buttons & (1 << BTN_Y)) ? BTN_ACTIVE[BTN_Y] : BTN_INACTIVE[BTN_Y],
         (joypad  & (1 << PAD_L)) ? PAD_ACTIVE[PAD_L] : PAD_INACTIVE[PAD_L],
         (joypad  & (1 << PAD_R)) ? PAD_ACTIVE[PAD_R] : PAD_INACTIVE[PAD_R],
         (buttons & (1 << BTN_X)) ? BTN_ACTIVE[BTN_X] : BTN_INACTIVE[BTN_X],
         (buttons & (1 << BTN_B)) ? BTN_ACTIVE[BTN_B] : BTN_INACTIVE[BTN_B],
         (joypad  & (1 << PAD_D)) ? PAD_ACTIVE[PAD_D] : PAD_INACTIVE[PAD_D],
         (buttons & (1 << BTN_A)) ? BTN_ACTIVE[BTN_A] : BTN_INACTIVE[BTN_A]);
}

int read_event(FILE* stream, struct input_event* event)
{
  size_t num_read = fread(event, sizeof(struct input_event), 1, stream);

  return (num_read == 1);
}

int main()
{
  // Ouvrir flux de manette (lecture binaire)
  FILE* stream = fopen("/dev/input/js0", "rb");
  struct input_event event;

  __u8 buttons = 0x00; // État des six boutons stocké dans un octet:    00RLYXBA
  __u8 joypad  = 0x00; // État des quatre flèches stocké dans un octet: 0000UDLR

  while (read_event(stream, &event)) {
    // Mettre état des boutons à jour (si changement)
    if (event.type & EV_KEY) {
      buttons &= ~(1 << event.number);
      buttons |= (event.value << event.number);
    }

    // Mettre état de la croix directionnelle à jour (si changement)
    if ((event.type & EV_REL) &&
        ((event.number == PAD_UD) || (event.number == PAD_LR))) {
      __u8 pressed = (event.value  & 1);
      __u8 offset  = (event.number & 1) << 1;
      __u8 status  = pressed << (offset | ((event.value & 0x02) >> 1));

      joypad &= (0x0C >> offset);
      joypad |= status;

      // Explication des valeurs (lorsque flèche appuyée):
      //     event.number event.value offset  pressed << (...) (0x0C >> offset)
      // Left   0x06        0x8001      0x00          << 0x00       0xC0
      // Right  0x06        0x7FFF      0x00          << 0x01       0xC0
      // Up     0x07        0x8001      0x02          << 0x02       0x03
      // Down   0x07        0x7FFF      0x02          << 0x03       0x03
      //
      // Remarque: 0x7FFF = +32767 et 0x8001 = -32767 sont les valeurs
      //                                                max. et min. sur un axe
    }

    print_controller(buttons, joypad);

    // Pour débogage
    printf("type  number  value\n");
    printf("0x%02X   0x%02X   0x%04hX\n",
           event.type, event.number, event.value);
  }

  // Fermer flux
  fclose(stream);
}
