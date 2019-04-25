#include <stdio.h>
#include <stdlib.h>
#include "testfunc.h"

#define NDEBUG //Deactivate debugging macro
#include "dbg.h"


/**
* Macro to test whether two numbers have equal sign and
* return 0 if they do not.
*/
#define signtest(M,N) if(M * N <= 0){return 0;}

typedef double (*obj_func)(double x, double y, double z);


/**
* Auxiliary to test points on the cube corresponding to i, j
*/
int check_points(obj_func f, double i, double j, double cubesize)
{
	int retval;
	double temp = f(-cubesize, i, j);
	if(temp == 0){
		return 0;
	}else if(temp > 0){
		retval = 1;
	}else{
		retval = -1;
	}
	
	temp = f(cubesize, i, j);
	signtest(temp,retval);
	
	temp = f(i, -cubesize, j);
	signtest(temp,retval);
	
	temp = f(i, cubesize, j);
	signtest(temp,retval);
	
	temp = f(i, j, -cubesize);
	signtest(temp,retval);
	
	temp = f(i, j, cubesize);
	signtest(temp,retval);
	
	return retval;
}


/**
* Tests whether the zero set of a given function R^3 -> R
* intersects a cube around (0,0,0). Returns 1 if all values of 
* f on the cube are positive, -1 if they are all negative,
* and 0 if there are both positive and negative values.
*/
int search_cube(obj_func f, double cubesize, int gridpoints)
{
	double i, j, stepsize, initval;
	int retval, temp;
	
	stepsize = 2 * cubesize / gridpoints;
	debug("Stepsize is %f", stepsize);
	
	initval = f(-cubesize, -cubesize, -cubesize);
	if(initval == 0){
		return 0;
	}else if(initval < 0){
		retval = -1;
	}else{
		retval = 1;
	}
	
	for(i = -cubesize; i <= cubesize; i += stepsize){
		for(j = -cubesize; j <= cubesize; j += stepsize){
			temp = check_points(f, i, j, cubesize);
			signtest(temp, retval);
		}
	}
	
	return retval;
}

/**
* MAIN
*/
int main(int argc, char *argv[])
{
	int result, gridpoints;
	double cubesize;
	if(argc < 3){
		printf("ERROR: Insufficient arguments!\nUSAGE: ./CompactnessTest cubesize gridpoints\n");
		return -1;
	}
	
	cubesize = atof(argv[1]);
	gridpoints = atoi(argv[2]);
	if(cubesize <= 0 || gridpoints <= 0){
		printf("ERROR: Invalid arguments!\nCubesize and gridpoints must be positive.\n\tGridpoints must be an integer.\n");
		return -1;
	}
	
	result = search_cube(testfunc, cubesize, gridpoints);
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
