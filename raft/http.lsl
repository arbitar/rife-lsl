#ifndef EXCLUDE_RR_HTTP
#ifndef RR_HTTP
	#define RR_HTTP

	/*
		http.lsl

		Contains HTTP communication helpers.
	*/

  #define RR_HTTP_REQUEST_BODY_MAXLEN_BYT 2048
	#define RR_HTTP_REQUEST_BODY_MAXLEN_CHR 1024

	#ifndef RR_HTTP_MULTIVALIDATE
		key __RR_HTTP_LSRID;
	#else
		list __RR_HTTP_LSRIDS;
	#endif

  string HTTP_MIMETYPE_PLAIN_UTF8 = "text/plain;charset=utf-8";
  string HTTP_MIMETYPE_FORM_URLENCODED = "application/x-www-form-urlencoded";
  string HTTP_MIMETYPE_JSON = "application/json";
  

  // If we want to send custom headers, we use the
  // setter rrHTTPSetHeader() function to inject them
  // into this array. 
  list CUSTOM_HEADERS = [];

  key rrHTTPDelete(string url) {
    list headers = [
      HTTP_METHOD, "DELETE"
    ];
    return rrHTTPSendRequest(url, headers, "");
  }

  key rrHTTPGet(string url) {
    list headers = [HTTP_METHOD, "GET"];
    return rrHTTPSendRequest(url, headers, "");
  }

  /**
  * Convert a list into a series of URL encoded (key=value) pairs.
  *
  * data must contain an even number of elements: odd elements are field
  * names while even indexed elements are the corresponding data:
  * [
  *    "name", "SecondLifer Resident",
  *    "key", "12345678-1234-1234-1234-123456789123"
  * ]
  */
  string rrHTTPList2QueryString(list data) {
    string queryString = "";
    
    integer ptr;
    integer count = (integer)llGetListLength(data);
    
    for (ptr = 0; ptr < count; ptr += 2) {
      queryString = queryString
        + llEscapeURL(llList2String(data, ptr))
        + "="
        + llEscapeURL(llList2String(data, ptr+1));
      if (ptr+2 < count) {
        queryString = queryString + "&";
      }
    }
    return queryString;
  }

  key rrHTTPPost(string url, string data) {
    list headers = [
      HTTP_METHOD, "POST"
    ];
    return rrHTTPSendRequest(url, headers, data);
  }

  key rrHTTPPut(string url, string data) {
    list headers = [
      HTTP_METHOD, "PUT"
    ];
    return rrHTTPSendRequest(url, headers, data);
  }

	key rrHTTPRequest(string url, list data, string body){
		if(rrStringContains(url, "agni.lindenlab.com:12046")
		  && llStringLength(body) > RR_HTTP_REQUEST_BODY_MAXLEN_BYT
    ){
			$ERROR("HTTP request being transmitted to in-world URL exceeds maximum recipient body "
				+"length of "+(string)RR_HTTP_REQUEST_BODY_MAXLEN_BYT+" bytes ("+
				(string)RR_HTTP_REQUEST_BODY_MAXLEN_CHR+" characters /w Mono). Request cancelled.");

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

  key rrHTTPSendRequest(string url, list params, string body) {
    // Set custom headers
    integer hlen = llGetListLength(CUSTOM_HEADERS);
    if ((hlen >= 2) && (hlen % 2 == 0)) {
      integer ptr;
      for (ptr = 0; ptr < hlen; ptr+=2) {
        string name = llList2String(CUSTOM_HEADERS, ptr);
        string value = llList2String(CUSTOM_HEADERS, ptr+1);
        params += [
          name, value
        ];
      }
    }
    CUSTOM_HEADERS = [];

    $TRACE("\n\n" + url + "\n"
      + llDumpList2String(params, " # ") + "\n"
      + body + "\n"
    );

    return rrHTTPRequest(url, params, body);
  }

  // Add a custom header to be added to the request.
  // CUSTOM_HEADERS is emptied after the request is sent.
  rrHTTPSetHeader(string name, string value) {
    CUSTOM_HEADERS += [name, value];
  }

  rrHTTPSetMimeType(string mimeType) {
    CUSTOM_HEADERS += [HTTP_MIMETYPE, mimeType];
  }

	integer rrHTTPValidateResponse(key reqid){
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
