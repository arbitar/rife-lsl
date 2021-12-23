#ifndef EXCLUDE_RR_HTTP
#ifndef RR_HTTP_PACKETS
	#define RR_HTTP_PACKETS

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
