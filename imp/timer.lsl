#ifndef EXCLUDE_RAL_TIMER
#ifndef RAL_TIMER
	#define RAL_TIMER

  // https://community.secondlife.com/forums/topic/36589-quoton_mouselookquot/#comment-555649
  float RAL_TIMER_MIN_TIMEOUT = 0.1; // seconds
  float RAL_TIMER_TIMEOUT = 0.1;

  ralTimerSetTimeout(float sec) {
    RAL_TIMER_TIMEOUT = sec;
  }

  ralTimerStart() {
    llSetTimerEvent(RAL_TIMER_TIMEOUT);
  }

  ralTimerStop() {
    llSetTimerEvent(0.0);
  }
#endif
#endif
