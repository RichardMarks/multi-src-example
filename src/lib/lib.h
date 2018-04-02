#ifndef LIB_H
#define LIB_H

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

struct State {
  int value;
  struct State* nextState;
};

extern void change_state(struct State* state, struct State* nextState);

#endif
