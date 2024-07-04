
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

//#define PI 3.14159265358979323846
#define PI acos(-1.0)

// Global variables
short _a;						// parte entera
short _b;						// parte fraccionaria
short _power;

/*
	Para un Ryzen 5 3600 en MxLinux
	
	Data type <int> tiene 4 bytes, es decir 32 bits.
	printf("int is %lu bytes.\n",sizeof(int));
	
	Data type <short> tiene 2 bytes, es decir 16 bits.
	printf("short is %lu bytes.\n",sizeof(short));
	
	Para compilar ejecutar:
		gcc -o cordic cordic.c - lm
*/
void inicializa( short a, short b ){		
	_a = a;								// A(a,b) representacion en punto fijo, cargamos variables globables 
	_b = b;
	_power = 1L << _b;					// Calculamos el factor para la conversion
}

// Convert from double to fixed point 
short setNumber( double v ){
	return ( (short)(v*_power) );
}

// Convert from fixed point to double
double getNumber( short r ){
	return ( (double)r/_power);
}

short multTrunc( short x, short y ){
	int r;
	int a=0;
	int b=0;
	a = x;
	b = y;
	r = a*b;
	r = r >> _b;
	return( r );
}

short d_func(short zi){
	double temp;
	temp = (getNumber(zi) >= 0)? 1.0 : -1.0;
	return setNumber(temp);
}

int main(int argc, char *argv[]){
	double x0, y0, z0;
	double factor = 180.0 / PI;
	double invtan, gamma;
	short xn, yn, zn, xi, yi, zi, di;
	int entera;
	int frac;
	int i;


	// Parametros de punto fijo
	entera = 7;
	frac = 8; 
	inicializa( entera, frac );
	printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);

	// Valores iniciales
	x0 = 0.607252935008881;
	y0 = 0;
	z0 = 20;
	printf(" # x0: %f\n", x0 );
	printf(" # y0: %f\n", y0 );
	printf(" # z0: %f\n", z0 );
	
	// Conversion a punto fijo
	xi = setNumber( x0 );
	yi = setNumber( y0 );
	zi = setNumber( z0 );
	printf(" # x0 real: %2.10f\n",getNumber(xi) );
	printf(" # y0 real: %2.10f\n",getNumber(yi) );
	printf(" # z0 real: %2.10f\n",getNumber(zi) );
	
	for(i = 0; i<12; i++){
		gamma = pow( 2.0, -(double)i );
		invtan = factor*atan( gamma );
		di = d_func(zi);
		xn = xi - multTrunc( di, multTrunc( yi, setNumber(gamma) ) );
		yn = yi + multTrunc( di, multTrunc( xi, setNumber(gamma) ) );
		zn = zi - multTrunc( di , setNumber( invtan ) );
		printf("%d\t%2.10f\t%2.10f\t%2.10f\n",i+1,getNumber( xn ), getNumber( yn ), getNumber( zn ) );
		xi = xn;
		yi = yn;
		zi = zn;
	}
	return 0;
}
//xxd -b salida	para ver el archivo generado en la terminal
