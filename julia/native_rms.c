#include <stddef.h>
#include <math.h>

/** compile (linux)
  clang -fPIC -xc -shared -O3 -Ofast -march=native -o native_rms_clang.so native_rms.c
  gcc -fPIC -xc -shared -O3 -Ofast -march=native -o native_rms_gcc.so native_rms.c
*/

double
c_rms( size_t n, double * X )
{
    double sum= 0. ;
    for ( size_t i= n ; (i --) ; X ++ ) { sum += ( *X * *X ) ; }
    return ( n ) ? sqrt( sum / n ) : 0. ;
}

double
c_rmsv( size_t n, double * X )
{
    double sum= 0. ;
    for ( size_t i = 0 ; ( i < n ) ; i ++ ) { sum += X[i] * X[i] ; }
    return ( n ) ? sqrt( sum / n ) : 0. ;
}

