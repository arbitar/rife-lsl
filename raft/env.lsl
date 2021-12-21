#ifndef EXCLUDE_RR_ENV
#ifndef RR_ENV
    #define RR_ENV

	/*
		env.lsl

		Contains environmental sensing and analysis shortcuts.
		Contains raycasting shortcuts that will return the first hit immediately.
		More work planned soon, esp. in regard to pathfinding.
	*/

	// fetches a current timestamp with millsecond accuracy
	float rrGetTimestampFloat(){
		float milliseconds = (float)("0" + llGetSubString(
			llList2String(llParseString2List(llGetTimestamp(), [":"], []), 2), 2, -2
		));
		float seconds = llGetWallclock();
		return seconds+milliseconds;
	}

    /*
        Raycasting
    */

	// thse definitions are duplicated to support addition of RR_RC_DETECT_PHANTOM without
	//  potentially clobbering eventual additions to the LL definitions.
	#define RR_RC_REJECT_AGENTS 1
	#define RR_RC_REJECT_PHYSICAL 2
	#define RR_RC_REJECT_NONPHYSICAL 4
	#define RR_RC_REJECT_LAND 8
	#define RR_RC_DETECT_PHANTOM 16

  list rrCastRayFirst(vector source,vector direction,float distance,integer reject,integer data){
		if(distance==0.0) {
      distance = 4096;
    }

		integer detectPhantom = reject&RR_RC_DETECT_PHANTOM;
		if(detectPhantom) {
      reject = reject & ~RR_RC_DETECT_PHANTOM;
    }

		list cast = llCastRay(source,source+(direction*distance),[
      RC_DATA_FLAGS, data,
			RC_REJECT_TYPES,reject,
			RC_DETECT_PHANTOM,detectPhantom,
			RC_MAX_HITS,1
		]);
		if(llGetListLength(cast)==1) {
      return [];
    }
		return llList2List(cast,0,-2);
	}

    key rrCastRayFirstRootKey(vector source,vector direction,float distance,integer reject){
		list cast = rrCastRayFirst(source,direction,distance,reject,RC_GET_ROOT_KEY);
		if(llGetListLength(cast)==0) {
      return NULL_KEY;
    }
		return llList2Key(cast,0);
	}

	key rrCastRayFirstKey(vector source,vector direction,float distance,integer reject){
		list cast = rrCastRayFirst(source,direction,distance,reject,0);
		if(llGetListLength(cast)==0) {
      return NULL_KEY;
    }
		return llList2Key(cast,0);
	}

  vector rrCastRayFirstNormal(vector source,vector direction,float distance,integer reject){
    list cast = rrCastRayFirst(source,direction,distance,reject,RC_GET_NORMAL);
    if(llGetListLength(cast)==0) {
      return ZERO_VECTOR;
    }
    return llList2Vector(cast,)
  }

	vector rrCastRayFirstVector(vector source,vector direction,float distance,integer reject){
		list cast = rrCastRayFirst(source,direction,distance,reject,0);
		if(llGetListLength(cast)==0) {
      return ZERO_VECTOR;
    }
		return llList2Vector(cast,1);
	}

  /*
    Pathfinding
  */
    
#endif
#endif
