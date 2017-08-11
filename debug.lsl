#ifndef EXCLUDE_RR_DEBUG
#ifndef RR_DEBUG
	#define RR_DEBUG

	/*
		debug.lsl
		
		Contains a tiered debugging system. Use the following commands liberally throughout
			your script, as you deem appropriate, to log on their logging level:

			$TRACE( ... )
			$INFO( ... )
			$DEBUG( ... )
			$WARN( ... )
			$ERROR( ... )
			$FATAL( ... )

		These are sequenced in order of apparent severity, with least severe at the top, and
			most severe at the bottom. By default, Rife will always output ERROR and FATAL messages
			to the user unless overridden, since these may contain valuable information for bug reports
			and should rarely occur.
		
		Variables or values of any type can be provided to these functions and they will be output.
		Multiple arguments can be provided, and will be outputted as a comma-delimited list.

		Configure the debugging levels by defining DEBUGLEVEL.
		The debug level constants are a bitfield, and can be binary OR'd
			together (eg, RR_DBG_DEBUG|RR_DBG_ERROR).
		Some presets have been provided for convenience:

			RR_DBG_PRESET_DEFAULT - Default unconfigured behavior.
			RR_DBG_PRESET_QUIET - No output at all
			RR_DBG_PRESET_DEV - Outputs default, plus DEBUG and WARN messages, but not INFO or TRACE 
			RR_DBG_PRESET_TRACE - Outputs dev, plus TRACE and INFO messages.

		These presets are also bitfields (of the standard constants), so they can be easily mutated.

		To override the debug output mechanism, redefine RR_DEBUG_FN like this:

			#define RR_DEBUG_FN(...) local_debug_function( __VA_ARGS__ )
		
		This will route all debug output to a function you provide, called local_debug_function.
		You can name it whatever you'd like.

		If you define DEBUGLOUD, errors will be llSay'd instead of llOwnerSay'd.

		$DUMP and rrDump will provide PHP "var_dump" style functionality, outputting the var name
			and its current value.
	*/

	/*
		Debug level constants: bitfield
	*/
	#define RR_DBG_NONE 0
	#define RR_DBG_DEBUG 1
	#define RR_DBG_ERROR 2
	#define RR_DBG_FATAL 4
	#define RR_DBG_INFO 8
	#define RR_DBG_TRACE 16
	#define RR_DBG_WARN 32

	/*
		Debug level presets
	*/
	#define RR_DBG_PRESET_DEFAULT \
		RR_DBG_ERROR | RR_DBG_FATAL

	#define RR_DBG_PRESET_QUIET \
		RR_DBG_NONE

	#define RR_DBG_PRESET_DEV \
		RR_DBG_PRESET_DEFAULT | RR_DBG_DEBUG | RR_DBG_WARN

	#define RR_DBG_PRESET_TRACE \
		RR_DBG_PRESET_DEV | RR_DBG_INFO | RR_DBG_TRACE

	/*
		Default debug level: show errors and fatal info
	*/
	#ifndef DEBUGLEVEL
		#define DEBUGLEVEL RR_DBG_PRESET_DEFAULT
	#endif

	#ifdef RR_DBG_RIFE_INTERNAL
		#define $RR_DBG_I(...) __VA_ARGS__
	#else
		#define $RR_DBG_I(...)
	#endif

	/*
		Customizable debug output functions.
		llOwnerSay is the default.
		If user overloads RR_DEBUG_FN, they can do whatever they want.
		Otherwise, if user defines DEBUGLOUD, it'll say it on channel 0.
	*/
	#ifndef RR_DEBUG_FN
		#ifndef DEBUGLOUD
			#define RR_DEBUG_FN(...) llOwnerSay( __VA_ARGS__ )
		#else
			#define RR_DEBUG_FN(...) llSay(0, __VA_ARGS__ )
		#endif
	#endif

	/*
		Named debug function implementations
	*/

	#if ((DEBUGLEVEL) & RR_DBG_DEBUG) == RR_DBG_DEBUG
		#define $DEBUG(...) RR_DEBUG_FN("[DEBUG] "+llList2CSV([ (string)__VA_ARGS__ ]))
	#else
		#define $DEBUG(...)
	#endif

	#if ((DEBUGLEVEL) & RR_DBG_ERROR) == RR_DBG_ERROR
		#define $ERROR(...) RR_DEBUG_FN("[ERROR] "+llList2CSV([ (string)__VA_ARGS__ ]))
	#else
		#define $ERROR(...)
	#endif

	#if ((DEBUGLEVEL) & RR_DBG_FATAL) == RR_DBG_FATAL
		#define $FATAL(...) RR_DEBUG_FN("[FATAL] "+llList2CSV([ (string)__VA_ARGS__ ]))
	#else
		#define $FATAL(...)
	#endif

	#if ((DEBUGLEVEL) & RR_DBG_INFO) == RR_DBG_INFO
		#define $INFO(...) RR_DEBUG_FN("[INFO] "+llList2CSV([ (string)__VA_ARGS__ ]))
	#else
		#define $INFO(...)
	#endif

	#if ((DEBUGLEVEL) & RR_DBG_TRACE) == RR_DBG_TRACE
		#define $TRACE(...) RR_DEBUG_FN("[TRACE] "+llList2CSV([ (string)__VA_ARGS__ ]))
	#else
		#define $TRACE(...)
	#endif

	#if ((DEBUGLEVEL) & RR_DBG_WARN) == RR_DBG_WARN
		#define $WARN(...) RR_DEBUG_FN("[WARN] "+llList2CSV([ (string)__VA_ARGS__ ]))
	#else
		#define $WARN(...)
	#endif

	/*
		'var_dump'-style function: shows the var name and its string value
	*/
	#define $DUMP(...) ( TOSTRING( __VA_ARGS__ ) + "=" + llList2CSV([ (string)__VA_ARGS__ ]) )
	#define rrDump(...) $DUMP( __VA_ARGS__ )
#endif
#endif
