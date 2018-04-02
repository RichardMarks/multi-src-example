#ifndef GAME_H
#define GAME_H

#include "lib.h"

struct Game {
  struct State state;
};

extern struct Game* globalGamePointer;

extern int start_game();

#endif
