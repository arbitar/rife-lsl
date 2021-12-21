#ifndef EXCLUDE_RR_HTTP
#ifndef RR_HTTP
	#define RR_HTTP

	/*
		http.lsl

		Contains HTTP communication helpers.
	*/

	#define RR_HTTP_REQUEST_LSL_BODY_MAXLEN_BYT 2048
	#define RR_HTTP_REQUEST_LSL_BODY_MAXLEN_CHR 1024

	#ifndef RR_HTTP_MULTIVALIDATE
		key __RR_HTTP_LSRID;
	#else
		list __RR_HTTP_LSRIDS;
	#endif

	key rrHTTPRequest(string url, list data, string body){
		if(rrContains("agni.lindenlab.com:12046")
		&& llStringLength(body) > RR_HTTP_REQUEST_BODY_MAXLEN){
			$ERROR("HTTP request being transmitted to in-world URL exceeds maximum recipient body "
				+"length of "+(string)RR_HTTP_REQUEST_BODY_MAXLEN_BYT+" bytes ("+
				(string)RR_HTTP_REQUEST_BOXY_MAXLEN_CHR+" characters /w Mono). Request cancelled.");

			return NULL_KEY;
		}

		#ifndef RR_HTTP_MULTIVALIDATE
			__RR_HTTP_LSRID = llHTTPRequest(url, data, body);
			return __RR_HTTP_LSRID;
		#else
			key srid = llHTTPRequest(url, data, body);
			__RR_HTTP_LSRIDS += srid;
			return srid;
		#endif
	}

	integer rrValidateHTTPResponse(key reqid){
		#ifndef RR_HTTP_MULTIVALIDATE
			return (reqid == __RR_HTTP_LSRID);
		#else
			integer index = llListFindList(__RR_HTTP_LSRIDS, [reqid]);
			if(index==-1)
				return false;
			
			__RR_HTTP_LSRIDS = llDeleteSubList(__RR_HTTP_LSRIDS, index, index);
			return TRUE;
		#endif
	}

	/*
		Feature: Simple SL message 'packet' format.
		Packets are formed into JSON objects, in the form of an associative array.
		A packet will have a _TYPE key which specifies a string packet type name.

		Bundling functions are available to pack multiple packets into a single communication.
	*/

	// create a packet string of designated type, with data
	string rrCreatePacket(string type, list data){
		list prepared = ["_TYPE", type]+data;
		string packet = llList2Json(JSON_OBJECT, prepared);

		if(llStringLength(packet) > 2048) {
      packet = "ERROR";
    }
    return packet;
	}

	// decode a packet if valid
	list rrDecodePacket(string packed){
		list unpacked = llJson2List(packed);
		string type = rrGetPacketType(unpacked);
		if(type == "") {
      return [];
    }
		
		return unpacked;
	}

	// decode a packet if valid and matching type
	list rrDecodePacketOfType(string packed, string type){
		list decoded = rrDecodePacket(packed);
		if(rrGetPacketType(decoded) != type) {
      return [];
    }

		return decoded;
	}

	// get the type of a packet
	string rrGetPacketType(list packet){
		return rrAssocListValue(packet, "_TYPE");
	}

	// create bundle of packets
	string rrCreatePacketBundle(list packets){
		string packed = llList2Json(JSON_ARRAY, packets);
		return rrCreatePacket("_RR_BUNDLE", [
			"bundled_at", rrGetTimestampFloat(),
			"packet_count", llGetListLength(packets),
			"packets", packed
		]);
	}

	// decode a bundle of packets
	list rrDecodePacketBundle(string packed){
		list bundle = rrDecodePacket(packed);
		string packets = rrAssocListValue(packet, "packets");
		if(packets == "") {
      return [];
    }
		
		return llJson2List(packets);
	}

	/*
		Feature: HTTP quick yielding:

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
