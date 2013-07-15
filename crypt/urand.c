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

	static	int isinit = 0 ;

				// hack in the style of C++ race of the constructors
	static	getinit(void) { return isinit ; }

	static int	read_devrand(unsigned char * abuf, int asize)
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

	static int	load_seed(void)
	{
		unsigned char	gseed[SEED_TOTAL], * ptr ;
		int ival ;

		if ( read_devrand(gseed, SEED_RAND)) { return 1 ; }

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
		return ! RAND_status() ;
	}

	int	gen_rand(unsigned char * zptr, int alen)
	{
		if ( ! getinit() && load_seed()) return 1 ;
		isinit= 1 ;

		return ! RAND_bytes( zptr, alen) ;
	}

