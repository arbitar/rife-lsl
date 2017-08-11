#ifndef EXCLUDE_RR_CONSTANTS
#ifndef RR_CONSTANTS
    #define RR_CONSTANTS

    /*
        constants.lsl
        Contains helper functions for dealing with obtuse LSL constant errors.
        Common offenders:
            raycasting errors
            pathfinding errors
        
        These tools aren't the most performance-friendly: use them to aid in debugging, but
            strip them out for leaner versions of error handling in production, please.
    */

    /*
        llCastRay - Raycasting
    */
    #define RR_CONST_NAME_RCERR_UNKNOWN "Unknown Error"
    #define RR_CONST_DESC_RCERR_UNKNOWN \
        "The raycast failed for an unspecified reason. Please submit a bug report."

    #define RR_CONST_NAME_RCERR_SIM_PERF_LOW "Poor Sim Performance"
    #define RR_CONST_DESC_RCERR_SIM_PERF_LOW \
        "The raycast failed because simulator performance is low. Wait a while and then try again. If possible reduce the scene complexity."

    #define RR_CONST_NAME_RCERR_CAST_TIME_EXCEEDED "Cast Time Exceeded"
    #define RR_CONST_DESC_RCERR_CAST_TIME_EXCEEDED \
        "The raycast failed because the parcel or agent has exceeded the maximum time allowed for raycasting. This resource pool is continually replenished, so waiting a few frames and retrying is likely to succeed."

    string rrGetCastRayErrorName(integer v){
        RR_CONST_CHECK(RCERR_UNKNOWN,NAME)
        RR_CONST_CHECK(RCERR_SIM_PERF_LOW,NAME)
        RR_CONST_CHECK(RCERR_CAST_TIME_EXCEEDED,NAME)
        return "";
    }

    string rrGetCastRayErrorDesc(integer v){
        RR_CONST_CHECK(RCERR_UNKNOWN,DESC)
        RR_CONST_CHECK(RCERR_SIM_PERF_LOW,DESC)
        RR_CONST_CHECK(RCERR_CAST_TIME_EXCEEDED,DESC)
        return "";
    }

    /*
        llGetStaticPath - Static Pathfinding
    */
    #define RR_CONST_NAME_PU_SLOWDOWN_DISTANCE_REACHED "Slowdown Distance Reached"
    #define RR_CONST_DESC_PU_SLOWDOWN_DISTANCE_REACHED \
        "Character is near current goal."

    #define RR_CONST_NAME_PU_GOAL_REACHED "Goal Reached"
    #define RR_CONST_DESC_PU_GOAL_REACHED \
        "Character has reached the goal and will stop or choose a new goal (if wandering)."

    #define RR_CONST_NAME_PU_FAILURE_INVALID_START "Invalid Start"
    #define RR_CONST_DESC_PU_FAILURE_INVALID_START \
        "Character cannot navigate from the current location - e.g., the character is off the navmesh or too high above it."

    #define RR_CONST_NAME_PU_FAILURE_INVALID_GOAL "Invalid Goal"
    #define RR_CONST_DESC_PU_FAILURE_INVALID_GOAL \
        "Goal is not on the navmesh and cannot be reached."

    #define RR_CONST_NAME_PU_FAILURE_UNREACHABLE "Unreachable"
    #define RR_CONST_DESC_PU_FAILURE_UNREACHABLE \
        "Goal is no longer reachable for some reason - e.g., an obstacle blocks the path."

    #define RR_CONST_NAME_PU_FAILURE_TARGET_GONE "Target Gone"
    #define RR_CONST_DESC_PU_FAILURE_TARGET_GONE \
        "Target (for llPursue or llEvade) can no longer be tracked - e.g., it left the region or is an avatar that is now more than about 30m outside the region."

    #define RR_CONST_NAME_PU_FAILURE_NO_VALID_DESTINATION "No Valid Destination"
    #define RR_CONST_DESC_PU_FAILURE_NO_VALID_DESTINATION \
        "There's no good place for the character to go - e.g., it is patrolling and all the patrol points are now unreachable."

    #define RR_CONST_NAME_PU_EVADE_HIDDEN "Presumed Hidden"
    #define RR_CONST_DESC_PU_EVADE_HIDDEN \
        "Triggered when an llEvade character thinks it has hidden from its pursuer."

    #define RR_CONST_NAME_PU_EVADE_SPOTTED "Presumed Spotted"
    #define RR_CONST_DESC_PU_EVADE_SPOTTED \
        "Triggered when an llEvade character switches from hiding to running"

    #define RR_CONST_NAME_PU_FAILURE_NO_NAVMESH "No Navmesh"
    #define RR_CONST_DESC_PU_FAILURE_NO_NAVMESH \
        "This is a fatal error reported to a character when there is no navmesh for the region. This usually indicates a server failure and users should file a bug report and include the time and region in which they received this message."

    #define RR_CONST_NAME_PU_FAILURE_DYNAMIC_PATHFINDING_DISABLED "Dynamic Pathfinding Disabled"
    #define RR_CONST_DESC_PU_FAILURE_DYNAMIC_PATHFINDING_DISABLED \
        "Triggered when a character enters a region with dynamic pathfinding disabled. Dynamic pathfinding can be toggled by estate managers via the 'dynamic_pathfinding' option in the Region Debug Console."

    #define RR_CONST_NAME_PU_FAILURE_PARCEL_UNREACHABLE "Parcel Unreachable"
    #define RR_CONST_DESC_PU_FAILURE_PARCEL_UNREACHABLE \
        "Triggered when a character failed to enter a parcel because it is not allowed to enter, e.g. because the parcel is already full or because object entry was disabled after the navmesh was baked."

    #define RR_CONST_NAME_PU_FAILURE_OTHER "Unknown Failure"
    #define RR_CONST_DESC_PU_FAILURE_OTHER \
        "Other failure."

    string rrGetPathErrorName(integer v){
        RR_CONST_CHECK(PU_SLOWDOWN_DISTANCE_REACHED,NAME)
        RR_CONST_CHECK(PU_GOAL_REACHED,NAME)
        RR_CONST_CHECK(PU_FAILURE_INVALID_START,NAME)
        RR_CONST_CHECK(PU_FAILURE_INVALID_GOAL,NAME)
        RR_CONST_CHECK(PU_FAILURE_UNREACHABLE,NAME)
        RR_CONST_CHECK(PU_FAILURE_TARGET_GONE,NAME)
        RR_CONST_CHECK(PU_FAILURE_NO_VALID_DESTINATION,NAME)
        RR_CONST_CHECK(PU_EVADE_HIDDEN,NAME)
        RR_CONST_CHECK(PU_EVADE_SPOTTED,NAME)
        RR_CONST_CHECK(PU_FAILURE_NO_NAVMESH,NAME)
        RR_CONST_CHECK(PU_FAILURE_DYNAMIC_PATHFINDING_DISABLED,NAME)
        RR_CONST_CHECK(PU_FAILURE_PARCEL_UNREACHABLE,NAME)
        RR_CONST_CHECK(PU_FAILURE_OTHER,NAME)
        return "";
    }

    string rrGetPathErrorDesc(integer v){
        RR_CONST_CHECK(PU_SLOWDOWN_DISTANCE_REACHED,DESC)
        RR_CONST_CHECK(PU_GOAL_REACHED,DESC)
        RR_CONST_CHECK(PU_FAILURE_INVALID_START,DESC)
        RR_CONST_CHECK(PU_FAILURE_INVALID_GOAL,DESC)
        RR_CONST_CHECK(PU_FAILURE_UNREACHABLE,DESC)
        RR_CONST_CHECK(PU_FAILURE_TARGET_GONE,DESC)
        RR_CONST_CHECK(PU_FAILURE_NO_VALID_DESTINATION,DESC)
        RR_CONST_CHECK(PU_EVADE_HIDDEN,DESC)
        RR_CONST_CHECK(PU_EVADE_SPOTTED,DESC)
        RR_CONST_CHECK(PU_FAILURE_NO_NAVMESH,DESC)
        RR_CONST_CHECK(PU_FAILURE_DYNAMIC_PATHFINDING_DISABLED,DESC)
        RR_CONST_CHECK(PU_FAILURE_PARCEL_UNREACHABLE,DESC)
        RR_CONST_CHECK(PU_FAILURE_OTHER,DESC)
        return "";
    }

    /*
        Utility
    */
    #define RR_CONST_CHECK(A,B) if(v==A) return RR_CONST_##B##_##A;
#endif
#endif
