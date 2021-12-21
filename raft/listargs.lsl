#ifndef EXCLUDE_RR_LISTARGS
#ifndef RR_LISTARGS
  #define RR_LISTARGS

	/*
		listargs.lsl

		Contains utility functions for processing llSetPrimitiveParam-style key-value
		 strided configuration data.
		
		Usage:
			integer DS_POS_ROT = 1;
			integer DS_SCALE = 2;
			integer DS_LOUD = 3;

			doStuff(list options){
				options = rrProcessFlagList([
					DS_POS_ROT, 2, ZERO_VECTOR, ZERO_ROTATION,
					DS_SCALE, 1, <0.5, 0.5, 0.5>,
					DS_LOUD, 1, FALSE
				], options);

				llSetLinkPrimitiveParamsFast(LINK_THIS, [
					PRIM_POS_LOCAL, rrGetFlagV(options, DS_POS_ROT, 0),
					PRIM_ROT_LOCAL, rrGetFlagR(options, DS_POS_ROT, 1),
					PRIM_SIZE, rrGetFlagV(options, DS_SCALE, 0)
				]);

				if(rrGetFlagI(options, DS_LOUD, 0)==TRUE)
					llShout(0, "HELLO I DID STUFF");
			}

			default{
				state_entry(){
					doStuff([
						DS_POS_ROT, llGetPos(), llGetRot(),
						DS_LOUD, TRUE
					]);
				}
			}
	*/

  /*
    Accepts a flag list argument schema, and a collection of user information.
    Returns a list ready for use with the rrGetFlag* functions.
    Schema format, per-flag:
        [int:Flag, int:ArgCount, mixed:DefaultArgs...]
	*/
	list rrProcessFlagList(list schema,list user){
    integer i;
    integer userCount = llGetListLength(user);
    integer schemaCount = llGetListLength(schema);

    list packedHeader;
    list packedArgs; // contains packed schema arguments

    // extract information about the schema
    list schemaFlags;
    list schemaIndices;
    list schemaArgumentCounts;
    for(i=0;i<schemaCount;i += 2){
      integer flag = llList2Integer(schema,i);
      integer argCount = llList2Integer(schema,i+1);

      schemaFlags += flag;
      schemaIndices += i;
      schemaArgumentCounts += argCount;
    }

    // create packed header

    list userFlags;
    list userIndices;
    for(i=0;i<userCount;i++){
      integer flag = llList2Integer(user,i);
      userFlags += flag;
      uiserIndices += i;

      integer schemaMetaIndex = llListFindList(schemaFlags,[flag]);
      integer schemaIndex = llList2Integer(schemaIndices,schemaMetaIndex);
      integer flagArgumentCount = llList2Integer(schemaArgumentCounts,schemaMetaIndex);
    }

    return user;
	}

  list rrGetFlag(list pfl,integer flag){
    integer flagCount = llList2Integer(pfl,0);
    list flags = llList2List(pfl,1,flagCount);

    integer flagIndex = llListFindList(flags,[flag]);
    integer flagArgCount = llList2Integer(pfl,flagCount+1+flagIndex);
    integer flagArgIndex = llList2Integer(pfl,(flagCount*2)+1+flagIndex);
    return llList2List(pfl,flagArgIndex,flagargIndex+(flagArgCount-1));
  }

  #define rrGetFlagF(A,B,C) (llList2Float(rrGetFlag(A,B),C))
  #define rrGetFlagI(A,B,C) (llList2Integer(rrGetFlag(A,B),C))
  #define rrGetFlagK(A,B,C) (llList2Key(rrGetFlag(A,B),C))
  #define rrGetFlagR(A,B,C) (llList2Rot(rrGetFlag(A,B),C))
  #define rrGetFlagS(A,B,C) (llList2String(rrGetFlag(A,B),C))
  #define rrGetFlagV(A,B,C) (llList2Vector(rrGetFlag(A,B),C))
#endif
#endif
