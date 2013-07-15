#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <openssl/rand.h>

	// magic numbers
#define	SEED_RAND	64
#define	SEED_PID	2
#define	SEED_UID	2
#define	SEED_NANO	4

#define	SEED_TOTAL	(SEED_RAND + SEED_PID + SEED_UID + SEED_NANO)

#define	TEST_BLOCK	8

	int	read_devrand(unsigned char * abuf, int asize)
	{
		FILE * fsrc= fopen("/dev/urandom", "rb") ;
		if ( fsrc )
		{
			int iret= fread(abuf, sizeof(unsigned char), asize, fsrc) ;
			fclose (fsrc) ;

			return ( iret != asize ) ;
		}

		return 1; 
	}

#define	PACK2(xx, val)	*(xx ++)= (0xff & val) ;  *(xx ++)= (0xff & ( val >> 8 )) 
#define PACK4(xx, val)  PACK2(xx, val) ;  val >>= 16 ;  PACK2(xx, val) 

int main(int N, char ** S)
{
	unsigned char	gseed[SEED_TOTAL], * ptr ;
	unsigned char	gdata[TEST_BLOCK] ;
	int istep, iret, ival ;

	if ( read_devrand(gseed, SEED_RAND)) { exit( 1) ; }

	ptr= gseed + SEED_RAND ;
	ival= getpid() ;  if ( ival ) { PACK2(ptr, ival) ; }
	ival= getuid() ;  if ( ival ) { PACK2(ptr, ival) ; }

#ifdef	_POSIX_TIMERS
	{
		struct timespec tspec ;
		if ( ! clock_gettime(CLOCK_REALTIME, &tspec )) { ival= tspec.tv_nsec ;  PACK4(ptr, ival) ; }
	}
#endif

	RAND_seed(gseed, ( ptr - gseed )) ;
	if (! RAND_status()) { fprintf(stderr, "RAND not initialized\n") ;  exit( 1) ; }

	iret= RAND_bytes(gdata, TEST_BLOCK) ;
	if ( ! iret ) { fprintf(stderr, "RAND bytes failed\n") ;  exit( 1) ; }

	for ( istep= TEST_BLOCK, ptr= gdata ; ( istep -- ) ; ptr ++ )
		{ printf("%02x", * ptr ) ; }
	printf("\n\n") ;

	return 0 ;
}


