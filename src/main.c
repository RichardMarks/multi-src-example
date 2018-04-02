#include "main.h"
#include "game.h"

int main (void) {
  struct Game game;
  globalGamePointer = &game;
  return start_game();
}
