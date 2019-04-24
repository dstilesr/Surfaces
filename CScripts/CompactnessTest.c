#include <stdio.h>
#include "testfunc.h"

#define CUBESIZE 100
#define GRIDPOINTS 150

typedef double (*obj_func)(double x, double y, double z);


/**
* Auxiliary to search faces with x fixed
*/
int search_x_faces(obj_func f)
{
	double stepsize, temp, i, j;
	int retval;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	
	temp = f(-CUBESIZE, -CUBESIZE, -CUBESIZE);
	if(temp > 0){
		retval = 1;
	}else if(temp < 0){
		retval = -1;
	}else if(temp == 0){
		return 0;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = f(-CUBESIZE, i, j);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
			
			temp = f(CUBESIZE, i, j);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
		}
	}
	
	return retval;
}


/**
* Auxiliary to search faces with y fixed
*/
int search_y_faces(obj_func f)
{
	double stepsize, temp, i, j;
	int retval;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	
	temp = f(-CUBESIZE, -CUBESIZE, -CUBESIZE);
	if(temp > 0){
		retval = 1;
	}else if(temp < 0){
		retval = -1;
	}else if(temp == 0){
		return 0;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = f(i, -CUBESIZE, j);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
			
			temp = f(i, CUBESIZE, j);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
		}
	}
	
	return retval;
}


/**
* Auxiliary to search faces with z fixed
*/
int search_z_faces(obj_func f)
{
	double stepsize, temp, i, j;
	int retval;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	
	temp = f(-CUBESIZE, -CUBESIZE, -CUBESIZE);
	if(temp > 0){
		retval = 1;
	}else if(temp < 0){
		retval = -1;
	}else if(temp == 0){
		return 0;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = f(i, j, -CUBESIZE);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
			
			temp = f(i, j, CUBESIZE);
			if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0))
				return 0;
		}
	}
	
	return retval;
}



/**
* Tests whether the zero set of a given function R^3 -> R
* intersects a cube around (0,0,0). Returns 1 if all values of 
* f on the cube are positive, -1 if they are all negative,
* and 0 if there are both positive and negative values.
*/
int search_cube(obj_func f)
{
	int retval, temp;
	
	retval = search_x_faces(f);
	if(retval == 0) return 0;
	
	temp = search_y_faces(f);
	if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0)) return 0;
	
	temp = search_z_faces(f);
	if((temp >= 0 && retval < 0) || (temp <= 0 && retval > 0)) return 0;
	
	return retval;
}

/**
* MAIN
*/
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
