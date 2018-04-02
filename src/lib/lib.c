#include "lib.h"

void change_state(struct State* state, struct State* nextState) {
  if (state) {
    state->nextState = nextState;
  }
}
