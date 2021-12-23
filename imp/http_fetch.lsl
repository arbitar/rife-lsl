#ifndef EXCLUDE_RR_HTTP
#ifndef RAL_HTTP_FETCH
	#define RAL_HTTP_FETCH

  /**
   * The response returned by an API may have a special format... or not.
   * Some APIs will return the data in the response root domain as in:
   * {"field1": "value", "field1": "value2"}
   * Other APIs may return the data under a field, as in: 
   * {"data": {"field1": "value", "field1": "value2"}}
   * Inside this value, the data comes as a JSON string which we need
   * to convert to a list.
   */
  list ralHttpResponseData(string response, string from) {
    if (from == "") {
      from = "data";
    }
    list parsedData = [];
    integer responseLen = llStringLength(response);
    if (responseLen > 0) {
      list parsedResponse = llJson2List(response);
      string jsonData = rrAssocListValue(parsedResponse, from);
      parsedData = llJson2List(jsonData);
    }
    return parsedData;
  }

#endif
#endif
