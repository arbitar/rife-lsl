#ifndef EXCLUDE_RR_NOTECARD
#ifndef RR_NOTECARD
	#define RR_NOTECARD

  /**
   * General .ini file format description:
   * ; comment line
   * # comment line
   * [GroupName]
   * paramName = paramValue
   *
   * @param string line A line from the notecard
   * @param list config A list where configuration parameters are kept
   * @return list A new list with the new parameter added
   */
  list rrParseIniLine(string line, list config) {
    line = llStringTrim(line, STRING_TRIM);
    if (llStringLength(line) == 0
      || llGetSubString(line, 0, 0) == ";"
      || llGetSubString(line, 0, 0) == "#"
      || llGetSubString(line, 0, 0) == "["
    ) {
      return config;
    }
    list lineParts = llParseString2List(line, ["="], []);
    string name = llStringTrim(llList2String(lineParts, 0), STRING_TRIM);
    string value = llStringTrim(llList2String(lineParts, 1), STRING_TRIM);
    list newList = config + [name, value];
    return newList;
  }
#endif
#endif

