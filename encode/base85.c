
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
	static int		step(struct StringPTR * rec, int asz )
	{
		if ( rec-> cur + asz > rec-> limit ) { return -1 ; }
		rec-> cur += asz ;
		return asz ;
	}

#define	SPsize(rec) ( rec.cur - rec.base )
#define	SPfree(rec)	( rec.limit - rec.cur )
#define	SPptr(rec) ( rec.cur )
#define SPbase(rec) ( rec.base )

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

	static void	compile( const unsigned char * abuf, int alen)
	{
		char * ptr, * pfill ;
		int itarg, isz, iuse, idlim, iduse ;

		if ( alen )
		{
			ptr= SPptr( holdrec) ;
			encode_asc85( ptr, SPfree( holdrec), abuf, alen) ;
			if ( ! wrap ) { fputs( ptr, stdout) ; }
				else { if ( -1 == step( &holdrec, strlen( ptr)) ) { fprintf(stderr, "buffer overflow\n") ;  exit( 8) ; } }
		}

		if ( ! wrap ) { return ; }
		if ( wrap % 5 ) { itarg= 5 * wrap ; } else { itarg= wrap ; }
		if ( itarg > ( STRINGSZ / 2 )) { fprintf(stderr, "wrap too large\n") ;  exit( 8) ; }

		idlim= STRINGSZ, iduse= 0, pfill= strbuf ;
		for ( ptr= SPbase( holdrec), isz= SPsize( holdrec) ; ( isz > itarg ) ; )
		{
			if (( 1 + wrap + iduse ) > idlim ) { fwrite( strbuf, sizeof(char), iduse, stdout) ;  pfill= strbuf, iduse= 0 ; }
			memcpy( pfill, ptr, wrap) ;  ptr += wrap ;  isz -= wrap ;
			pfill += wrap ;  *(pfill ++)= '\n' ;  iduse += ( wrap + 1 ) ;
		}

		if ( iduse ) { fwrite( strbuf, sizeof(char), iduse, stdout) ; }
		pop( &holdrec, ( ptr - SPbase( holdrec) ) ) ;

		if ( ! alen && SPsize( holdrec) )
		{
			fwrite( SPbase( holdrec), sizeof(char), SPsize( holdrec), stdout) ;
			fprintf(stdout, "\n") ;
		}
	}

void	doencode(FILE * fin)
{
	int iret ;

	while ( iret= fread( datbuf, sizeof(unsigned char), WINDOWSZ, fin))
		{ compile( datbuf, iret) ; }

	compile( NULL, 0) ;
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

