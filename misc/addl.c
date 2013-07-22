#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int	main()
{
	char s[64], * p ;
	double dval, dsum ;

	dsum= 0 ;
	while ( fgets(s, sizeof(s), stdin)) {
		if ( isdigit( *s )) {
			dval= atof( s) ;
			dsum += dval ;
		}
		else {
			printf("\t%.2f\n", dsum) ;
		}
	}

	printf("\t%.2f\n", dsum) ;

	return 0;
}

