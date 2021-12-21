#ifndef EXCLUDE_RR_KFM
#ifndef RR_KFM
  #define RR_KFM

  /*
    kfm.lsl

    Contains convenience functions for keyframed motion (KFM) functionality.
  */

  // converts a list of global (region) values to relative ones required by the LL KFM funcs
  list rrGlobalToRelativeKeyframes(list keyframes,integer data){
    vector lastPos = llGetPos();
    rotation lastRot = llGetRot();

    integer i;
    integer elems = 1+((data&KFM_TRANSLATION)>>1)+(data&KFM_ROTATION);
    integer count = llGetListLength(keyframes);
    for(i=0; i<count; i += elems){
      integer dataIndex = i;

      vector relPos;
      rotation relRot;

      if(data & KFM_TRANSLATION){
        relPos = llList2Vector(keyframes,dataIndex)-lastPos;
        keyframes = llListReplaceList(keyframes,[relPos],dataIndex,dataIndex);
        dataIndex++;
      }

      if(data&KFM_ROTATION){
        relRot = llList2Rot(keyframes,dataIndex)/lastRot;
        keyframes = llListReplaceList(keyframes,[relRot],dataIndex,dataIndex);
      }

      lastPos += relPos;
      lastRot *= relRot;
    }

    return keyframes;
  }

  // acts as a full replacement for the LL KVM functions, but operating entirely off of
  //  global (region) coordinates instead of last-frame relative coordinates like default.
  rrSetGlobalKeyframedMotion(list keyframes,list options){
    integer optData = KFM_TRANSLATION|KFM_ROTATION;
    integer i;
    for(i=0; i<llGetListLength(options); i+=2) {
      if(llList2Integer(options,i)==KFM_DATA) {
        optData = llList2Integer(options,i+1);
      }
    }

    keyframes = rrGlobalToRelativeKeyframes(keyframes,optData);
    llSetKeyframedMotion(keyframes,options);
  }
#endif
#endif
