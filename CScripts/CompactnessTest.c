#include <stdio.h>
#include "testfunc.h"

#define CUBESIZE 50
#define GRIDPOINTS 100

typedef double (*obj_func)(double x, double y, double z);


/**
* Auxiliary to search faces with x fixed
*/
int search_x_face(obj_func f, int axis)
{
	double stepsize, temp, xval, i, j;
	int retval;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	xval = -CUBESIZE;
	if(axis > 0) xval = CUBESIZE;
	
	temp = f(xval, -CUBESIZE, -CUBESIZE);
	
	if(temp > 0){
		retval = 1;
	}else if(temp < 0){
		retval = -1;
	}else if(temp == 0){
		return 0;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = f(xval, i, j);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
		}
	}
	
	return retval;
}


/**
* Auxiliary to search faces with y fixed
*/
int search_y_face(obj_func f, int axis)
{
	double stepsize, temp, yval, i, j;
	int retval;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	yval = -CUBESIZE;
	if(axis > 0) yval = CUBESIZE;
	
	temp = f(-CUBESIZE, yval, -CUBESIZE);
	
	if(temp > 0){
		retval = 1;
	}else if(temp < 0){
		retval = -1;
	}else if(temp == 0){
		return 0;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = f(i, yval, j);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
		}
	}
	
	return retval;
}


/**
* Auxiliary to search faces with z fixed
*/
int search_z_face(obj_func f, int axis)
{
	double stepsize, temp, zval, i, j;
	int retval;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	zval = -CUBESIZE;
	if(axis > 0) zval = CUBESIZE;
	
	temp = f(-CUBESIZE, -CUBESIZE, zval);
	
	if(temp > 0){
		retval = 1;
	}else if(temp < 0){
		retval = -1;
	}else if(temp == 0){
		return 0;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = f(i, j, zval);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
		}
	}
	
	return retval;
}


/**
* Tests whether the zero set of a given function R^3 -> R
*  intersects the given face of a cube (1,-1 for x axis,
* 2,-2 for y, 3,-3 for z). Returns 1 if all values of f on the
* cube face are positive, -1 if they are all negative,
* and 0 if there are both positive and negative values.
*/
int search_face(obj_func f, int axis)
{
	int value;
	if(axis == 1 || axis == -1){
		value = search_x_face(f,axis);
	}else if(axis == 2 || axis == -2){
		value = search_y_face(f,axis);
	}else if(axis == 3 || axis == -3){
		value = search_z_face(f, axis);
	}else{
		goto error;
	}
	return value;
	
	error:
		printf("Axis value must be one of 1,-1,2,-2,3,-3 but given value was %d\n", axis);
		return 10;
}

/**
* Tests whether the zero set of a given function R^3 -> R
* intersects a cube around (0,0,0). Returns 1 if all values of 
* f on the cube are positive, -1 if they are all negative,
* and 0 if there are both positive and negative values.
*/
int search_cube(obj_func f)
{
	int axes[] = {1,-1,2,-2,3,-3};
	int retval, temp;
	
	retval = search_face(f, axes[0]);
	if(retval == 0) return 0;
	
	for(int i = 1; i < 6; i++){
		temp = search_face(f, axes[i]);
		
		if(temp == 0){
			return 0;
		}else if((temp < 0 && retval > 0) || (temp > 0 && retval < 0)){
			return 0;
		}
		
	}
	
	return retval;
}


int main()
{
	int result = search_cube(testfunc);
	if(result == -1){
		printf("All values of f on the cube are negative.\n");
	}else if(result == 1){
		printf("All values of f on the cube are positive.\n");
	}else if(result == 0){
		printf("The zero set of f intersects the cube.\n");
	}else{
		printf("ERROR\n");
	}
	
	return 0;
}
