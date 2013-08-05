#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>

	// gcc -Wno-multichar -std=c99 -o pcalc pcalc.c -lm

#ifndef M_PI
#define	M_PI	3.1415926535897932384626433832795l
#endif

	#define	STACK_SIZE	20

	static double	dstack[STACK_SIZE], * dcur, * dmax ;
	static double	dscale = M_PI / 180.0 ;

	static int		isv= 0 ;

	double dv, du ;		// globals for commandset


	//// STACK CONTROL

static void	init()
{
	dcur= dstack, dmax= dstack + STACK_SIZE ;
	* dcur= 0 ;
}

static int	pop(double * zval)
{
	if ( dstack == dcur )
		return 0 ;

	* zval = * ( -- dcur ) ;
	return 1 ;
}

static int	peek(double * zval)
{
	if ( dstack == dcur )
		return 0 ;

	* zval= dcur[ -1] ;
}

static void	push(double aval)
{
	if ( dcur == dmax ) {
		printf(">> stack limit.\n") ;
		return ;
	}

	*( dcur ++)= aval ;
}

	//// COMMANDS

	static void	cmd_printvalue(void) { peek( & dv) ;  printf("  %g\n", dv) ; }
	static void	cmd_printdecimal(void) { long lval ; peek( & dv) ;  lval= floor( dv) ;  printf("  %ld\n", lval) ; }
	static void	cmd_printfloat(void) { peek( & dv) ;  printf("  %.5f\n", dv) ; }
	static void	cmd_printhex(void) { long lval ; peek( & dv) ;  lval= floor( dv) ;  printf("  %08lx\n", lval) ; }
	static void	cmd_printrad() { peek( & dv) ;  dv /= M_PI ;  printf("  %.2g\u03C0\n", dv) ; }
	static void	cmd_printstack(void) 
		{
			if ( dstack == dcur ) { printf("\t-") ; }
			else
			{
				double * dstep ;
				for ( dstep= dstack ; ( dstep < dcur ) ; dstep ++ ) {
					printf("  %g,", * dstep) ;
				}
				printf("\n") ;
			}
		}

#define		EARG	else { fprintf(stderr, ">> insufficent args\n") ; }
#define		ERANGE	else { fprintf(stderr, ">> arg out of range\n") ; }

	static void	cmd_square(void) { if ( pop( &dv)) { push( dv * dv); } EARG }
	static void	cmd_sqrt(void) { if ( pop( &dv) && ( dv >= 0.0)) { push( sqrt( dv)) ; } ERANGE }
	static void	cmd_invert(void) { if ( pop( &dv) && ((-1e-12 > dv) || (dv > 1e-12)))
						{ push( 1. / dv) ; }  ERANGE
					}
	static void	cmd_exp(void) { if ( pop( &dv)) { push( exp(dv)) ; } EARG }
	static void	cmd_log(void) { if ( pop( &dv) && ( dv >= 1.0)) { push( log( dv)) ; } ERANGE }
	static void	cmd_log2(void) { if ( pop( &dv) && ( dv >= 1.0))
						{ push( log( dv) / log( 2.)) ; } ERANGE
					}
	static void	cmd_trig_sin() { if ( pop( &dv)) { push( sin(dv * dscale) ) ; }  EARG }
	static void	cmd_trig_cos() { if ( pop( &dv)) { push( cos(dv * dscale) ) ; }  EARG }
	static void	cmd_trig_tan() { if ( pop( &dv)) { push( tan(dv * dscale) ) ; }  EARG }
	static void	cmd_const_pi() { push (M_PI) ; }
	static void	cmd_trig_atan() { if ( pop( &dv)) { push( atan( dv) / dscale) ; } EARG }
	static void	cmd_trig_atan2() { if ( pop( &dv) && pop( &du)) { push( atan2( dv, du) / dscale) ; } EARG }

	static void	cmd_udegree() { dscale= M_PI / 180.0 ; }
	static void	cmd_uradian() { dscale= 1.0 ; }
	static void	cmd_dup() { if ( peek( & du)) push( du) ; }
	static void	cmd_pop() { if ( pop( &dv)) { printf("  ^ %g\n", dv) ; }  EARG }
	static void	cmd_swap() { if ( pop( &dv) && pop( &du)) { push( dv) ;  push( du) ; }  EARG }
	static void	cmd_verbose() { isv= 1 ; }
	static void	cmd_quiet() { isv= 0 ; }
	static void	cmd_exit() { exit( 0); }

	static void	cmd_help() ;

	static struct CommandBlock
		{ long	commandid ;
			char description[16] ;
			void (* code)() ;
		}
		commands[] =
		{
			{ 'p', "print value", & cmd_printvalue },
			{ 'pd', "print decimal", & cmd_printdecimal },
			{ 'pf', "print float", & cmd_printfloat },
			{ 'px', "print hex", & cmd_printhex },
			{ 'pr', "print radians", & cmd_printrad },
			{ 'prad', "print radians", & cmd_printrad },
			{ 'P', "print stack", & cmd_printstack },

			{ 'sqr', "square", & cmd_square },
			{ 'sqrt', "squareroot", & cmd_sqrt },
			{ 'inv', "invert", & cmd_invert },

			{ 'e', "exp", & cmd_exp },
			{ 'log', "log", & cmd_log },
			{ 'ln', "log", &cmd_log },
			{ 'log2', "log base2", &cmd_log2 },

			{ 'sin', "sin", &cmd_trig_sin },
			{ 'cos', "cos", &cmd_trig_cos },
			{ 'tan', "tan", &cmd_trig_tan },
			{ 'pi', "pi", &cmd_const_pi },
			{ 'atan', "atan", &cmd_trig_atan },
			{ 'atn2', "atan2", &cmd_trig_atan2 },

			{ 'deg', "degree units", &cmd_udegree },
			{ 'rad', "radian units", &cmd_uradian },

			{ 'dup', "stack dup", &cmd_dup },
			{ 'pop', "statck pop", &cmd_pop },
			{ 'swap', "stack swap", &cmd_swap },

			{ 'verb', "verbose", &cmd_verbose },
			{ 'v', "verbose", &cmd_verbose },
			{ 'quie', "quiet", &cmd_quiet },
			{ 'q', "quiet", &cmd_quiet },

			{ 'exit', "exit", &cmd_exit },
			{ 'x', "exit", &cmd_exit },

			{ 'help', "list commands", & cmd_help },

			{ 0, "", NULL }	// setinal
		} ;

		static void	cmd_help()
		{
			struct CommandBlock * cmdstep ;
			char s[6] = "\0\0\0\0\0\0", * p ;
			long lv ;

			fprintf(stderr, "commands: \n") ;
			for ( cmdstep= commands ; ( cmdstep && cmdstep-> commandid ) ; ++ cmdstep )
			{
				for ( lv= cmdstep-> commandid, p= s + 5 ; ( lv ) ; lv >>= 8 )
					{ * (-- p) = lv & 0x7f ; }
				fprintf(stderr, "  cmd %s : %s\n", p, cmdstep-> description) ;
			}
		}

static long	acode(const char * p)
{
	int istep ;
	long lv ;

	if ( ! p )
		return 0;

	istep= 4, lv= 0 ;
	while ( istep -- && * p ) { lv= ( lv << 8 ) | * ( p ++ ) ;  }
	return lv ;
}

static void	arg(const char * p)
{
	int ia, ib ;
	long lc ;
	char c= * p, * q ;

	struct CommandBlock * cmdstep ;

	if ( ! c ) return ;
	if ( isv ) printf("@ arg : [%c] %s\n", c, p) ;

		// bad uniary operator hack
	if ((('-' == c ) && isdigit( p[1])) || isdigit( c)) {
		if ( strchr( p, '.')) { dv= atof( p) ; }
			else if ( q= strchr( p, '\'')) { ia= strtol( q +1, NULL, 2) ;  dv= ia ; }
			else { ia= strtol( p, NULL, 0) ;  dv= ia ; }
		push( dv) ;
		return ;
	}

	if ( isalpha( c) && ( lc= acode( p)))
	{
		if ( isv ) printf("alpha : %08x\n", (unsigned) lc) ;
		for ( cmdstep= commands; ( cmdstep && cmdstep-> commandid && cmdstep-> commandid != lc ) ; cmdstep ++ ) { }

		if ( cmdstep-> commandid ) { ( cmdstep-> code)() ; } 


		return ;
	}

	if ( isv ) printf("symbol : %c\n", c) ;
	switch ( c)
	{
		case '+' :  if ( pop( &du) && pop( &dv)) { push (dv + du) ; }  EARG  break ;
		case '-' :  if ( pop( &du) && pop( &dv)) { push (dv - du) ; }  EARG  break ;
		case '*' :  if ( pop( &du) && pop( &dv)) { push (dv * du) ; }  EARG  break ;
		case '/' :
			if ( pop( &du) && pop( &dv)) {
				if ((-1e-20 < du ) && ( du < 1e-20 )) { printf(">> INF.\n") ; }
					else push ( dv / du ) ;
			} EARG
			break ;
		case '%' :
			if ( pop( &dv) && pop( &du)) {
				ia= du, ib= dv ;  ia %= ib ;
				push( ia) ;
			}
			break ;
		case '^' :
			if ( pop( &dv) && pop( &du)) {
				ia= du, ib= dv ;  ia ^= ib ;
				push( ia) ;
			}
			break ;
		case '_' :
				// worse uniary operator hack
			if ( isdigit( p[1])) { 
				du= atof( p+1) ;
				push( sqrt( du)) ;
			}
			else {
				if ( pop( &du) && (du >= 0.0 )) { push( sqrt( du)) ; } ERANGE
			}
			break ;
		case '?' :  cmd_help() ;  break ;
	}

}


static int	iswhite(char c)
{ return ((' ' == c) || ('\t' == c) || ('\n' == c) || ('\r' == c)) ; }


#define	M_word(ppp)  while ((c= * ppp) && ! iswhite(c))  ppp ++
#define	M_white(ppp)  while ((c= * ppp) && iswhite(c))  ppp ++

void	parse( char * q)
{
	char * p, c ;

	while ( * q ) {
		p= q ;
		M_word( p) ;
		if ( * p ) { *(p ++)= '\0' ;  M_white( p) ; }
		arg( q) ;
		q= p ;
	}
}

void	cli(void)
{
	char s[1024] ;
	char * q, c ;

	while ( fgets(s, sizeof( s), stdin)) {
		q= s ;  M_white( q) ;  if ( * q) parse( q) ;
	}
}

int	main(int N, char ** S)
{
	double dval, dsum ;

	init() ;

	N --, S ++ ;
	if ( N ) {
		while ( N -- ) {
			if ( strchr( * S, ' ')) { parse( *(S ++)) ; } else { arg( *(S ++)) ; }
		}
		exit( 0) ;
	}

	cli() ;
	return 0;
}

