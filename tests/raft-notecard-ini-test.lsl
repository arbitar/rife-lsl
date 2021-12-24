#include "lib/raft.lsl"

/** Put a notecard called config.ini with this text in your test object:

; This is a demo notecard
; with comment lines,

; some empty lines and two values
# ...and another kind of comments

[Group]
one = I say one
two = You say two

*/
string NOTECARD_NAME = "config.ini";
list glConfig;
integer giCfgLineNum;
key gkCfgQryKey = NULL_KEY;

showConfig(list cfg) {
  llSay(0, "one=" + rrAssocListValue(cfg, "one"));
  llSay(0, "two=" + rrAssocListValue(cfg, "two"));
}

default {
  state_entry() {
    llSay(0, "Ready, touch to parse notecard " + NOTECARD_NAME + "...");
  }
  
  touch_start(integer i) {
    if (gkCfgQryKey != NULL_KEY) {
      llSay(0, "This query is already used.");
    } else {
      glConfig = [];
      giCfgLineNum = 0;
      gkCfgQryKey = llGetNotecardLine(NOTECARD_NAME, giCfgLineNum);
    }
  }

  dataserver(key queryId, string line) {
    if (queryId == gkCfgQryKey) {
      if (line == EOF) {
        llSay(0, "EOF");
        gkCfgQryKey = NULL_KEY;
        showConfig(glConfig);
      } else {
        glConfig = rrParseIniLine(line, glConfig);
        gkCfgQryKey = llGetNotecardLine(NOTECARD_NAME, giCfgLineNum++);
      }
    }
  }
}
