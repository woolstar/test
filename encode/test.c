#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/fcntl.h>

#include "asc85.h"

	int step= 7 ;

	static int	compare_buff(const unsigned char * abuf1, const unsigned char * abuf2, int alen)
	{
		while ( alen && abuf1 && abuf2 && ( * abuf1 == * abuf2 )) { alen --, abuf1 ++, abuf2 ++ ; }
		return alen ;
	}

	static void	check(unsigned long aval, int alen)
	{
		int iret, istep ;
		unsigned long ltmp ;
		unsigned char	ibuf[8], obuf[8], * uptr ;
		char encbuf[8] ;

		for ( istep= alen, uptr= ibuf, ltmp= aval ; (istep -- ) ; ltmp >>= 8 ) { *(uptr ++)= 0xff & ltmp ; }
		encode_asc85( encbuf, sizeof(encbuf), ibuf, alen) ;
		if ( ! * encbuf || strchr( encbuf, '/' ))
			{ fprintf(stderr, "encode failed") ;  exit( 1) ; }

		iret= decode_asc85(obuf, sizeof(obuf), encbuf) ;
		if ( iret != alen )
			{ fprintf(stderr, "decode length mismatch") ;  exit( 2) ; }

		if ( compare_buff( ibuf, obuf, alen ) )
			{ fprintf(stderr, "contents mismatch (%ld:%d) (%s)", aval, alen, encbuf) ;  exit( 3) ; }
	}


#define		MAXTEST	1024

static unsigned char	srcbuf[MAXTEST], decbuf[MAXTEST] ;
static char		encbuf[MAXTEST * 5 / 4 + 1], finalbuf[MAXTEST * 5 / 4 + 1 ] ;

	static void	test_strings(void)
	{
		const static const char testlist[][MAXTEST]= { 
				"helloworld",
				"HTTaaaaaaaaaaaaaaaaaaaabbccccccccdddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffffgggghhhhhhhhhhhhhiiiiiiiiiiiiillllllmmmmnnnnnnnnnnnnnnnooooooooooooppppprrrrrrrrrrsssssssssssssstttttttttttttttttttttttuuuuuuuuuuvvwwwwxyyyyy",
				"nreoe2neatYteor4ri7eeoi7s5se2h2oafnpet4ohhsactdoetro2tos22fete7UeiumvooseirihpgtansteunrtloowrecrrmolmtSnoneuvoioi7rehesdtt9eeeo3rhoLawt41bpnTi1iinrlreinrt1nwnrem4ivlslghR26hdtitbnr5RomyeawhtoeT3nevsctet2egw1apo379rih7fi3aqgvoi3vtrteiTttvwTmsInbSfmstbtoUi2lecotdeiiseso73ogrMr2sor4eeeclrtisewftiegac3lAcrcerfeeoEahtehoebnnpweS1o2hatttffNHnmt4m5sptginemAittlUc7rnc7iehernmInftdewhunuroTldihe51idrelxoaetlftrC4hepasat7gste2mtpsttr3aivlods5xasnoemfairreafdo2opbne3tclmlfolauenq2ePoonbnmoiae33Titlrnyf92tieoityeirllLEws1hLo4iaeiGoUifen2txi2t1ehttndsnvneosyE9d8us9ef14nrSuotteinfs747nw7iedeohg2o7atsocr2yxhic2qarlhwEpt2i3rsxUmefUmeaisc4hnhenonwetihfnCtfrwolt2rlK",
				"ABzY8f_3Xr0s~D?%L;-(6x|Q_55w$rk~UG-0Yk$;3BpZFv0D>3j_FnF@6&A2@;o>XNb)RIki=o6z#tV|6E!YA`^ON7($<7Ex%6&O@E-~U;ftguQ|(G!v>j5=)6Lxo#UMZCX{^>OpJ#T!E69Zaxisug(PeTa{=a2HEZ4}dw(QMRz;)4aGiwY&o}A-DAm&wDDaUd2?$+Kb^h#@_P#RkV87j|VAiwET-h9bnAHWJz4BG$z00",
				"",	// sentinal -- end of tests
			} ;

		const char (* test)[MAXTEST] ;
		int ilen ;

		for ( test= &testlist[0] ; ( ** test ) ; ++ test )
		{
			ilen= decode_asc85(decbuf, MAXTEST, * test) ;
				if ( ilen < 1 ) { fprintf(stderr, "string decode failed (%s)\n", * test) ;  exit(7) ; }
			encode_asc85( finalbuf, sizeof(finalbuf), decbuf, ilen) ;
			if ( compare_buff( * test, finalbuf, strlen( * test)) )
				{ fprintf( stderr, "string recoding failure ::\nIN: %s\nOUT: %s\n", * test, finalbuf) ;  exit( 7) ; }
		}
	}

	static void	test_random(void)
	{
		int itotal, istep, rdata, ilen ;
		unsigned char rndval; 

		
		
		rdata = open( "/dev/random", O_RDONLY);
		read( rdata, &rndval, sizeof(rndval));

		itotal = MAXTEST - rndval;
		for ( istep = itotal; (istep --) ;) {
			read( rdata, srcbuf, sizeof(itotal));

			encode_asc85( encbuf, itotal, srcbuf, itotal);
			ilen = decode_asc85( finalbuf, itotal, encbuf);
				if ( ilen < 1 ) { fprintf(stderr, "random decode failed.\n") ; exit( 7) ; }

			if ( compare_buff( finalbuf, srcbuf, itotal) )
				{ fprintf(stderr, "random encode/decode failed.\n") ; exit( 7) ; }
		}
	}


int main(int N, char ** S)
{
	unsigned long lval, lmax ;

		// USAGE: test [stepvalue]
		//   larger step values are faster, step 7 takes a few minutes

	N --, S ++ ;
	if ( N && isdigit( **S )) { step= atoi( *S) ; }

		// test fractional and full 4 bytes packets

	if ( step )
	{
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
	}

	test_strings() ;
	puts("s.") ;

	test_random() ;
	puts("r.") ;
}

