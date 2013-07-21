#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "asc85.h"

	int step= 7 ;

	static void	check(unsigned long aval, int alen)
	{
		int iret, istep ;
		unsigned long ltmp ;
		unsigned char	ibuf[8], obuf[8], * uptr, * uchk ;
		char encbuf[8] ;

		for ( istep= alen, uptr= ibuf, ltmp= aval ; (istep -- ) ; ltmp >>= 8 ) { *(uptr ++)= 0xff & ltmp ; }
		encode_asc85( encbuf, sizeof(encbuf), ibuf, alen) ;
		if ( ! * encbuf || strchr( encbuf, '/' ))
			{ perror("encode failed") ;  exit( 1) ; }

		iret= decode_asc85(obuf, sizeof(obuf), encbuf) ;
		if ( iret != alen )
			{ perror("decode length mismatch") ;  exit( 2) ; }

		for ( istep= alen, uptr= ibuf, uchk= obuf ; ( istep && ( * uptr == * uchk ) ) ; istep --, uptr ++, uchk ++ ) { }
		if ( istep )
			{ fprintf(stderr, "contents mismatch (%ld:%d) (%s)", aval, alen, encbuf) ;  exit( 3) ; }
	}

	static void	test_strings(void)
	{
	}

	static void	test_random(void)
	{
	}


int main(int N, char ** S)
{
	unsigned long lval, lmax ;

		// USAGE: test [stepvalue]
		//   larger step values are faster, step 7 takes a few minutes

	N --, S ++ ;
	if ( N && isdigit( **S )) { step= atoi( *S) ; }

		// test fractional and full 4 bytes packets

	for (lval= 0, lmax= 0xff ; ( lval < lmax ) ; lval += step ) { check( lval, 1) ; }
	for (lval= 0xff ; (lval > step ) ; lval -= step ) { check( lval, 1) ; }
	puts("1.") ;

	for (lval= 0, lmax= 0xffff ; ( lval < lmax ) ; lval += step ) { check( lval, 2) ; }
	for (lval= 0xffff; ( lval > step ) ; lval -= step ) { check( lval, 2) ; }
	puts("2.") ;

	for (lval= 0, lmax= 0xffffff ; ( lval < lmax ) ; lval += step ) { check( lval, 3) ; }
	for (lval= 0xffffff; ( lval > step ) ; lval -= step ) { check( lval, 3) ; }
	puts("3.") ;

	if ( step > 1 )
	{
		for (lval= 0, lmax= 0xffffffff - (2 * step) ; ( lval < lmax ) ; lval += step ) { check( lval, 4) ; }
		puts("4 up.") ;
		for (lval= 0xffffffff; ( lval > step ) ; lval -= step ) { check( lval, 4) ; }
		puts("4 down.") ;
	}
	else
	{
		for (lval= 0, lmax= 0xffffffff ; ( lval < lmax ) ; lval ++ ) { check( lval, 4) ; }
		puts(".") ;
	}

	test_strings() ;
	puts("s.") ;

	test_random() ;
	puts("r.") ;
}

