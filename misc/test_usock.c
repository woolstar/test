#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

	int	isock_serv ;

void	setup(void)
{
	struct sockaddr_un lo ;
	int iret ;

	isock_serv= socket(AF_UNIX, SOCK_STREAM, 0) ;
	if ( isock_serv < 0 ) {
		perror("creating socket.") ;
		exit( 1) ;
	}

	lo.sun_family= AF_UNIX ;
	strcpy( lo.sun_path, "/tmp/wfoo") ;
	unlink( "/tmp/wfoo") ;

	iret= bind(isock_serv, (struct sockaddr *) & lo, SUN_LEN( & lo)) ;
	if ( iret < 0 ) {
		perror("bind fail.") ;
		exit( 1) ;
	}

	iret= listen(isock_serv, 8) ;
	if ( iret < 0 ) {
		perror("listen fail.") ;
		exit( 1) ;
	}
}

int	get( void)
{
	int ival= accept( isock_serv, NULL, NULL) ;

	if ( ival < 0) {
		perror("accept eek.") ;
		exit( 2) ;
	}

	return ival ;
}

void	use(int iport)
{
	int iret ;
	char buff[1024] ;

	while ( iret= recv( iport, buff, sizeof(buff) -1, 0)) {
		if ( iret < 0 ) { perror("fff.") ;  break ; }

		buff[iret]= '\0' ;
		printf(" >> %s\n", buff) ;
	}

	close( iport) ;
}

int main(int N, char ** S)
{
	int iport ;

	setup() ;
	while ( iport= get()) {
		use( iport) ;
	}

	return 0 ;
}


