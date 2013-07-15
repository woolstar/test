#include <stdio.h>

void	scan(const char * afi)
{
	unsigned char	ablock[16384], * ustep ;
	int istep, ird, nct ;
	long len, lcur, lpart, ltag ;
	FILE * fsrc= fopen(afi, "rb") ;

	if ( NULL == fsrc )
		return ;

	fseek(fsrc, 0, SEEK_END) ;
	len= ftell(fsrc) ;

	if ( ! len )
	{
		perror("empty file") ;
		fclose(fsrc) ;
		return ;
	}

	rewind(fsrc) ;
	lpart= len >> 4 ;
	nct= 0 ;

	for (lcur= 0, ltag= 0; ( ! ( ird= fread(ablock, 1, sizeof(ablock), fsrc))) ; lcur += ird, ltag += ird )
	{
		for ( ustep= ablock, istep= ird ; ( istep && * ustep ) ; istep --, ustep ++ ) { } ;
		if ( ird ) {
			fprintf(stderr, " null @ %ld:%d\n", lcur, (ird - istep)) ;
			nct ++ ;
		}

		if ( ltag > lpart ) { putchar('.') ;  fflush(stdout) ;  ltag -= lpart ;  }
	}

	if ( nct) fprintf(stderr, ":: %d nulls\n", nct) ;
	fclose( fsrc) ;
}

int	main(int N, char **S )
{
	N --, S ++ ;

	while ( N) { scan(* S) ;  N --, S ++ ; }
	return 0;
}

