#include "lib/imp/timer.lsl"

integer giCounter = 10;
integer giRound = 1;

restart() {
  giCounter = 10;
  ralTimerStart();
}

default {
  state_entry() {
    llSay(0, "Ready, touch to start timer test...");
    llSetText("imp-timer-test.lsl", <1.0, 0.0, 0.0>, 1.0);
  }

  touch_start(integer i) {
    restart();
    giRound = 1;
  }

  timer() {
    ralTimerStop();
    giCounter--;
    llSay(0, "Update game state: " + (string)giCounter);
    if (giCounter <= 0) {
      if (giRound == 1) {
        giRound = 2;
        llSay(0, "Done with minimum timeout!");
        llSay(0, "Now lets go again with 2 second timeout...");
        ralTimerSetTimeout(2);
        restart();
      } else if (giRound == 2) {
        llSay(0, "Done, timer is stopped!");
      }
    } else {
      ralTimerStart();
    }
  }
}
