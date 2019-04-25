#include <stdio.h>
#include "testfunc.h"

#define CUBESIZE 200
#define GRIDPOINTS 400

/**
* Macro to test whether two numbers have equal sign and
* return 0 if they do not.
*/
#define signtest(M,N) if(M * N <= 0){return 0;}

typedef double (*obj_func)(double x, double y, double z);


/**
* Auxiliary to test points on the cube corresponding to i, j
*/
int check_points(obj_func f, double i, double j)
{
	int retval;
	double temp = f(-CUBESIZE, i, j);
	if(temp == 0){
		return 0;
	}else if(temp > 0){
		retval = 1;
	}else{
		retval = -1;
	}
	
	temp = f(CUBESIZE, i, j);
	signtest(temp,retval);
	
	temp = f(i, -CUBESIZE, j);
	signtest(temp,retval);
	
	temp = f(i, CUBESIZE, j);
	signtest(temp,retval);
	
	temp = f(i, j, -CUBESIZE);
	signtest(temp,retval);
	
	temp = f(i, j, CUBESIZE);
	signtest(temp,retval);
	
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
	double i, j, stepsize, initval;
	int retval, temp;
	
	stepsize = 2 * CUBESIZE / GRIDPOINTS;
	
	initval = f(-CUBESIZE, -CUBESIZE, -CUBESIZE);
	if(initval == 0){
		return 0;
	}else if(initval < 0){
		retval = -1;
	}else{
		retval = 1;
	}
	
	for(i = -CUBESIZE; i <= CUBESIZE; i += stepsize){
		for(j = -CUBESIZE; j <= CUBESIZE; j += stepsize){
			temp = check_points(f,i,j);
			signtest(temp, retval);
		}
	}
	
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
