#include "game.h"

struct Game* globalGamePointer = 0;

int start_game() {
  if (!globalGamePointer) {
    fprintf(stderr, "unable to start game. globalGamePointer was not set before calling start_game()!\n");
    return -1;
  }

  printf("starting game...\n");

  return 0;
}
