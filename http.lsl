#ifndef EXCLUDE_RR_HTTP
#ifndef RR_HTTP
	#define RR_HTTP

	/*
		http.lsl

		Contains HTTP communication helpers.
		Implements HTTP quick yielding:

		For simple scripts that primarily need to start, make an HTTP request, and act upon it
		 (possibly doing so repeatedly), this will be a time-saver.

		Usage:

		default{
			state_entry(){
				llOwnerSay("Script started! Requesting info...");

				QUICK_HTTP_YIELD("http://example.com/script-io", [], "");

				llOwnerSay("Data: "+body);
				llOwnerSay("Repeating in 1s...");

				llSleep(1.0);
				QUICK_HTTP_AGAIN();
			}
		}
	*/

	key __RR_HTTP_QHYID;
	string __RR_HTTP_LASTURL;
	list __RR_HTTP_LASTMETADATA;
	string __RR_HTTP_LASTBODY;

	#define QUICK_HTTP_YIELD(URL,METADATA,BODY) \
	    __RR_HTTP_LASTURL = URL;\
	    __RR_HTTP_LASTMETADATA = METADATA;\
	    __RR_HTTP_LASTBODY = BODY;\
	    QUICK_HTTP_AGAIN();\
	    }http_response(key id,integer status,list metadata,string body){\
	        if(id!=__RR_HTTP_QHYID) return;

	#define QUICK_HTTP_AGAIN() \
	    __RR_HTTP_QHYID = llHTTPRequest(__RR_HTTP_LASTURL,__RR_HTTP_LASTMETADATA,__RR_HTTP_LASTBODY);

#endif
#endif
