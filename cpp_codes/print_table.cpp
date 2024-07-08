#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string>

#define PI acos(-1.0)

float di_func(float x){
  return (x >= 0.0) ? 1.0 : -1.0;
}

char di_func_str(float x){
  return (x >= 0.0) ? '+' : '-';
}

int main(int argc, char** argv){

  int val;
  for (int i = 0; i < 9; i++) {
    val = int( pow(2.0, i) );
    printf("| $%d$ | $\\arctan(1/%d)$ | $%7.4f$ | $%7.4f$ | $1/%d$ | \n", i, val, atan(1.0/val)*(180.0/PI),atan(1.0/val), val);
  }

  printf("\n");

  float zn = 20.0;
  float zi;
  float angle;
  for (int i = 0; i < 20; i++) {
    val = int( pow(2.0, i) );
    angle = atan(1.0/val)*(180.0/PI);
    zi = zn - di_func(zn)*angle;
    printf("| $%d$ | $%7.4f$ | $1/%d$ | $%7.4f %c %7.4f = %7.4f$ | $%c$ |\n", i, angle, val, zn, di_func_str(-zn), angle, zi, di_func_str(zn) );
    zn = zi;
  }

	return 0;
}
