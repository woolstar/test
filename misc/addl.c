#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

main()
{
	char s[128], * p, c ;
	double dval, dsum ;
	int i= 0 ;

	dsum= 0 ;
	while ( fgets(s, sizeof(s), stdin)) {
		p = s ;
		while ((c= *p) && ((' ' == c) || ('\t' == c))) p ++ ;

		if ( isdigit( *p ) || ('-' == * p)) {
			dval= atof( p) ;
			dsum += dval ;
			i ++ ;
		}
			else { printf("\t = %.2f\n", dsum) ; }
	}

	if ( i )
		{ printf("  ==== [%d]\t%.2f\n", i, dsum) ; }
}

