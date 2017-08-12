#ifndef EXCLUDE_RR_LISTS
#ifndef RR_LISTS
	#define RR_LISTS

  /*
    lists.lsl

    List helpers (not related to listarg functionality: see listarg.lsl)
  */

  // In strided key-value pair lists, fetch the value given the key
  string rrAssocListValue(list assoc, string keyS){
    integer index = llListFindList(assoc, [keyS]);
    if(index==-1)
      return "";
    
    return llList2String(assoc, index+1);
  }

  // In strided key-value pair lists, determine if a key (and associated value) even exists
  integer rrAssocListHasKey(list assoc, string keyS){
    integer index = llListFindList(assoc, [keyS]);
    return (index!=-1);
  }

#endif
#endif
