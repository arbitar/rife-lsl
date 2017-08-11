#ifndef EXCLUDE_RR_STRINGS
#ifndef RR_STRINGS
	#define RR_STRINGS

	/*
		strings.lsl

		Contains string utility functions.
	*/

	// Seems silly but I wanted consistency.
	#define rrSubStringIndex(HAYSTACK,NEEDLE) \
		llSubStringIndex(HAYSTACK,NEEDLE)

	// Fetch the position of the final instance of the needle from within the haystack.
	#define rrFinalSubStringIndex(HAYSTACK,NEEDLE) \
		__RR_STRING_FINALSUBSTRINGINDEX(HAYSTACK,NEEDLE)

	// Fetch the position of the final character of the first needle from within the haystack.
	#define rrSubStringIndexEnd(HAYSTACK,NEEDLE) \
		(integer)(llSubStringIndex(HAYSTACK,NEEDLE)+llStringLength(NEEDLE))

	// Fetch the position of the final character of the final needle from within the haystack.
	#define rrFinalSubStringIndexEnd(HAYSTACK,NEEDLE) \
		(integer)(abFinalSubStringIndex(HAYSTACK,NEEDLE)+llStringLength(NEEDLE))

	// Most efficiently determine if a haystack contains a needle.
	#define rrStringContains(HAYSTACK,NEEDLE) \
		~llSubStringIndex(HAYSTACK,NEEDLE)

	// Most efficiently determine if the haystack begins with the needle.
	#define rrStringStartsWith(HAYSTACK,NEEDLE) \
		(llDeleteSubString(HAYSTACK,llStringLength(NEEDLE),0x7FFFFFF0)==NEEDLE)

	// Most efficiently determine if the haystack ends with the needle.
	#define rrStringEndsWith(HAYSTACK,NEEDLE) \
		(llDeleteSubString(HAYSTACK,0x8000000F,~llStringLength(NEEDLE))==NEEDLE)

	// Fetch the string from the haystack that lies after BEFORE, but prior to AFTER.
	// Eg:
	//  string test = "<tag>Value</tag>";
	//  string inner = rrGetSubStringWithin(test, "<tag>", "</tag>");
	//  llOwnerSay(inner); // "Value"
	#define rrGetSubStringWithin(HAYSTACK,BEFORE,AFTER) \
		__RR_STRING_SUBSTRINGWITHIN(HAYSTACK,BEFORE,AFTER,FALSE)

  // Same as rrGetSubStringWithin, but on the last instance of the BEFORE/AFTER pair in the
	//  haystack.
	#define rrGetFinalSubStringWithin(HAYSTACK,BEFORE,AFTER) \
		__RR_STRING_SUBSTRINGWITHIN(HAYSTACK,BEFORE,AFTER,TRUE)

	/*
		Internal functions
	*/

  // functional implementation of rrFinalSubStringIndex
	integer __RR_STRING_FINALSUBSTRINGINDEX(string HAYSTACK,string NEEDLE){
		integer i =
			llStringLength(HAYSTACK)-
			llStringLength(NEEDLE)-
			llStringLength(
				llList2String(
					llParseStringKeepNulls(HAYSTACK,(list)NEEDLE,[]),
					0xFFFFFFFF
				)
			);
		return (i | ( i >> 31 ));
	}

	// functional implementation of rrGetSubStringWithin
	string __RR_STRING_SUBSTRINGWITHIN(string HAYSTACK,string BEFORE,string AFTER,integer FINAL){
		integer start = -1;
		if(FINAL) start = rrFinalSubStringIndex(HAYSTACK,BEFORE);
		else start = llSubStringIndex(HAYSTACK,BEFORE);
		return llGetSubString(HAYSTACK,
			start+llStringLength(BEFORE),
			llSubStringIndex(llGetSubString(HAYSTACK,start,-1),AFTER)+(start-1)
		);
	}

#endif
#endif
