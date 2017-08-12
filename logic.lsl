#ifndef EXCLUDE_RR_LOGIC
#ifndef RR_LOGIC
	#define RR_LOGIC

	/*
		logic.lsl

		Contains tools to help with general logic.
		Implements foreach, in a manner.
	*/

	/*
		Implement foreach-style functionality as syntactic sugar.
		
		Usage:
			list avatars = [...];
			foreach(avatars, i, avatar){
				llOwnerSay("Av #"+(string)(i+1)+": "+(string)avatar);
			}
	*/
	#define foreach(LIST,INDEX,STORE) \
		integer __##LIST##INDEX##__ = llGetListLength(LIST);\
		integer INDEX;\
		string STORE;\
		for(INDEX=0,STORE=llList2String(LIST,INDEX);\
		INDEX< __##LIST##INDEX##__;\
		INDEX++,STORE=llList2String(LIST,INDEX))

	/*
		In detected* events, make sure the owner is one of the interfacers,
		 and load its number into the var name given.
		
		Usage:
			touch_start(integer num){
				rrOwnerGuard(owner, num);
				// if the owner was not a toucher, this does not run
				llOwnerSay("The owner is toucher number: #"+(string)owner);
			}
	*/
	#define rrOwnerGuard(A,B) integer A;\
		for(A=0; A<B; ++A) \
		if(llDetectedKey(A)==llGetOwner()) \
			jump RR_OWN_GUARD_CONTINUE; \
		return; \
		@RR_OWN_GUARD_CONTINUE;

	/*
		Quick global (all-state) events

		Usage:
			global_touch_start(integer num){
				llOwnerSay("touched in any state!");
			}

			default{
				state_entry(){
					llOwnerSay("Entered default");
				}
				register_global_touch_start
			}

			state alternate{
				state_entry(){
					llOwnerSay("Entered alternate");
				}
				register_global_touch_start
			}
	*/
	#define register_global_generic(A) A(){ global_A(); }
	#define register_global_counted(A) A(integer c){ global_A(c); }

	#define register_global_listen \
		listen(integer ch,string n,key k,string m){ global_listen(ch,n,k,m); }

	#define register_global_link_message \
		link_message(integer s,integer n,string m,key k){ global_link_message(s,n,m,k); }

	#define register_global_http_request \
		http_request(key k,string m,string b){ global_http_request(k,m,b); }

	#define register_global_http_response \
		http_response(key k,integer s,list m,string b){ global_http_response(k,s,m,b); }

	#define register_global_touch_start		register_global_counted(touch_start)
	#define register_global_touch 			register_global_counted(touch)
	#define register_global_touch_end 		register_global_counted(touch_end)

	#define register_global_collision_start register_global_counted(collision_start)
	#define register_global_collision 		register_global_counted(collision)
	#define register_global_collision_end 	register_global_counted(collision_end)

	#define register_global_state_entry 	register_global_generic(state_entry)
	#define register_global_state_exit 	register_global_generic(state_exit)

	#define register_global(A) register_global_##A
#endif
#endif
