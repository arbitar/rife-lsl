#ifndef EXCLUDE_RR_MATH
#ifndef RR_MATH
	#define RR_MATH

	/*
		math.lsl

		Math helpers!
	*/

	// very tiny (effectively zero) value, used in float comparisons
	#define EPSILON 0.000001

	/*
		General Math
	*/

	// clamp float value v between min and max
	float rrClampF(float min,float max,float v){
		if(v<min) {
      return min;
    }
		if(v>max) {
      return max;
    }
		return v;
	}

	// clamp integer value i between min and max
	integer rrClampI(integer min,integer max,integer v){
		if(v<min) {
      return min;
    }
		if(v>max) {
      return max;
    }
		return v;
	}

	// LSL only permits modulo on integers:
	//  provide a helper to duplicate functionality for floats too
	float rrModFloat(float a,float b){
		return a - (llFloor(a / b) * b);
	}

	/*
		Intersection tests
	*/

	// If a 2d box contains a 2d point
	// z coordinate ignored
	integer rrBox2dContains(vector min, vector max, vector point){
		return (point.x >= min.x && point.x <= max.x && point.y >= min.y && point.y <= max.y);
	}

	/*
		Vector operations
	*/

	// given a ray (vector describing a direction), and a surface
	//  normal (vector describing face orientation), return a natural reflection ray
	vector rrReflectRay(vector ray,vector surfaceNormal){
		ray = llVecNorm(ray);
		surfaceNormal = llVecNorm(surfaceNormal);

		return llVecNorm(ray-2*(ray*surfaceNormal)*surfaceNormal);
	}

	/*
		P-Spline Implementation

		pSpline & pIndex functions released into public domain by Nexii Malthus.
		Thank you, Nexii! Works great :)
	*/
	vector rrPSpline(list v,float t,integer loop){
			integer l = llGetListLength(v); t *= l-1;
			integer f = llFloor(t); t -= f;
			float t2 = t*t; float t3 = t2*t;
			return (
					((-t3+(3.0*t2)-(3.0*t)+1.0)*llList2Vector(v,abPSplineIndex(f-1,l,loop)))
					+(((3.0*t3)-(6.0*t2)+4.0)*llList2Vector(v,abPSplineIndex(f,l,loop)))
					+(((-3.0*t3)+(3.0*t2)+(3.0*t)+1.0)*llList2Vector(v,abPSplineIndex(f+1,l,loop)))
					+(t3*llList2Vector(v,abPSplineIndex(f+2,l,loop)))
			)/6.0;
	}

	integer rrPIndex(integer index,integer length,integer loop){
		if(loop) {
      return index%length;
    }
		if(index<0) {
      return 0;
    }
		if(index>--length) {
      return length;
    }
		return index;
	}

	/*
		Misc. Interpolation
	*/
	// Spherical linear interpolation, for quaternion rotations
	rotation rrSlerp(rotation a,rotation b,float t){
			return llAxisAngle2Rot(llRot2Axis(b /= a),
			t * llRot2Angle(b)) * a;
	}

	// Linear interpolation between two floats
	float rrLerpF(float a,float b,float c){
		return ((b-a)*c)+a;
	}

	// Linear interpolation between two vectors
	vector rrLerp(vector a,vector b,float c){
		return ((b-a)*c)+a;
	}

	/*
		Number formatting & prettification
	*/

	// display number as commented integer value (eg, "1,234,567")
	string rrFormatInteger(integer num){
		string original = (string)num;
		integer length = llStringLength(original);
		
		string output;
		integer i;
		for(i=0; i<length; i++){
			output += llGetSubString(original,i,i);
			if((i%3)==(length+2)%3 && i!=(length-1)) {
        output += ",";
      }
		}
		
		return output;
	}

	// display number as a rounded integer percentage (eg, "25%")
	// accepts float [0.0 - 1.0] as 0% to 100%
	string rrFormatPercentage(float num){
		return (string)llRound(100.0*(float)((string)num))+"%";
	}
#endif
#endif
