#ifndef EXCLUDE_RR_MACROS
#ifndef RR_MACROS
	#define RR_MACROS

  /*
    macros.lsl

    Contains pure preprocessor macros that provide either internal utility or ugly shortcuts
     that I don't want to really include in the base stuff.
  */

  // internal utility macros. ignore.
  #define STRINGIFY(x) #x
  #define TOSTRING(x) STRINGIFY(x)

  // because i'm immeasurably lazy and want to save keystrokes
  #define rrSetLPP llSetLinkPrimitiveParamsFast
  #define rrGetLPP llGetLinkPrimitiveParams

#endif
#endif
