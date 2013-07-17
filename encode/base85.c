
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "asc85.h"

	int wrap= 75 ;
	int strict= 1 ;
	int term= 0 ;

#define	WINDOWSZ	16777216
#define	BUFSIZE		1048576


int	dmain(char * asrc)
{
	return 0 ;
}

int main(int N, char ** S)
{
	N --, S ++ ;
	int decode= 0 ;

	while ( N && ( '-' == ** S) )
	{
		switch ((* S)[1])
		{
			case 'd':
				decode= 1 ;
				break ;
			case 'w':
				if ( N > 1 ) { N --, S ++ ;  if ( isdigit(** S)) { wrap= atoi( * S) ; } }
				break ;
			case 'i':
				strict= 0 ;
				break ;
			case 't':
				term= 1 ;
				break ;
			default:
				fprintf(stderr, "unknown argument %s\n", * S) ;
			case '?':
				fprintf(stderr, "USAGE: base85r [-d] [-w N] [-i] [-t] [FILE]\n") ;
				exit( 1) ;
		}
		N --, S ++ ;
	}

	if ( decode ) { return dmain( N ? *S : NULL ) ; }
	return 0 ;
}

