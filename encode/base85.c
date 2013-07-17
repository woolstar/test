
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "asc85.h"

	int wrap= 75 ;
	int strict= 1 ;
	int term= 0 ;

#define	WINDOWSZ	262144
#define	BUFSIZE		1048576
#define	STRINGSZ	491520

	FILE	* fsrc ;

	unsigned char	datbuf[WINDOWSZ] ;
	char			holdbuf[BUFSIZE], strbuf[STRINGSZ] ;

	struct StringPTR { char * base, * cur, * limit ; } holdrec ;

	////

	static void		init(struct StringPTR * rec, char * abuf, int asz )
	{
		rec-> base= rec-> cur= abuf ;
		rec-> limit= abuf + asz ;
	}

	static int		add(struct StringPTR * rec, const char * abuf, int asz )
	{
		if ( rec-> cur + asz > rec-> limit ) { return -1 ; }
		memcpy( rec-> cur, abuf, asz ) ;
		rec-> cur += asz ;
		return asz ;
	}

#define	SPsize(rec) ( rec.cur - rec.base )
#define	SPptr(rec) ( rec.cur )

	static void		pop(struct StringPTR * rec, int asz)
	{
		int imove ;

		if ( asz < 1 ) { return ; }
		if ( asz >= ( rec-> cur - rec-> base ) ) { rec-> cur= rec-> base ; }
		else
		{
			imove= ( rec-> cur - rec-> base ) - asz ;
			memmove( rec-> base, rec-> base + asz, imove) ;
			rec-> cur= rec-> base + asz ;
		}
	}

	////

void	doencode(FILE * fin)
{
}

void	dodecode(FILE * fin)
{
}

	////

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

	if ( N )
	{
		fsrc= fopen(* S, "rb") ;
		if ( NULL == fsrc ) { perror("unable top open input") ;  exit( 1) ; }
	}
		else { fsrc= stdin ; }

	init( & holdrec, holdbuf, BUFSIZE) ;

	if ( decode ) { dodecode( fsrc) ; }
		else { doencode(fsrc) ; }

	if ( N ) { fclose( fsrc) ; }

	return 0 ;
}

