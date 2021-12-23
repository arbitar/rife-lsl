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
#endif
#endif
