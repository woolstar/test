#include <stdio.h>
#include <stdlib.h>

#include <thread>		// note, requires flag -std=c++0x for gcc
						//  ex: g++ -std=c++0x threadhandoff.cpp -pthread
#include <atomic>
#include <condition_variable>
#include <functional>
#include <chrono>
#include <random>
#include "elist.h"

#ifdef WIN32
#	include <windows.h>
#endif

class	simplework : public edata_slist<simplework>::listable
		{ public: simplework(char atok) : m_work(atok) { }  const char m_work ; } ;

class	econduit
{
	public:
		econduit() : istate( 1), iwork( 0) { }

		static econduit&	getconduit(void) ;

		void	add(simplework * aptr) ;
		void	done() ;

		simplework * get(void) ;

	private:
		std::condition_variable	cv ;
		std::mutex	mu ;
		std::atomic<int>	istate, iwork ;

		class	queue : public edata_slist<simplework>
		{
			public:
				simplework *	getfirst(void)
								{
									simplework * ptr= m_first ;
									if ( m_first ) { m_first= m_first-> next() ;  if ( ! m_first ) { m_last= NULL ; } }
									return ptr ;
								}
		}
			m_list ;
} ;

	// this is a pattern for avoiding initialization race conditions
	// not required here, but its good practice to avoid exposing globals directly
econduit &	econduit::getconduit(void)
{
	static econduit	g_core ;
	return g_core ;
}

void	econduit::add(simplework * aptr)
{
	std::lock_guard<std::mutex>	lock(mu) ;

	m_list.add( aptr) ;
	++ iwork ;
	cv.notify_one() ;
}

void	econduit::done(void)
{
	std::lock_guard<std::mutex>	lock(mu) ;

	istate= 0 ;
	cv.notify_all() ;
}

simplework *	econduit::get(void)
{
	int iret ;
	std::unique_lock<std::mutex>	lk(mu) ;
	auto lamdaready = [this](){ return ( this-> iwork || ! this-> istate) ; } ;

	while ( istate ) {
		iret= cv.wait_for(lk, std::chrono::milliseconds( 1 ), lamdaready ) ;
		if ( iret && iwork ) {
			iwork -- ;
			return m_list.getfirst() ;
		}
	}

	return NULL ;
}

	//

	#define	PSAFE(ptr, xxx) { if ( ptr ) { ptr-> xxx() ; } }

class	ethread 
{
	public:
		ethread() : m_thread(NULL) { }

		virtual ~ ethread() { }

		std::thread *	launch(void) ;

		void	join(void) { PSAFE( m_thread, join ) ; }
		void	detach(void) { PSAFE( m_thread, detach ) ; }

	protected:
		std::thread	* m_thread ;

		virtual void	work() = 0 ;

	private:
		static void		launcher(ethread * aptr) { aptr-> work() ; }
} ;

std::thread *	ethread::launch(void)
{
	m_thread= new std::thread( launcher, this) ;
	return m_thread ;
}

	//
	// hack for platform sepecific waiting
class waiter
{
	public:
		void wait_us(int atime)
#ifndef WIN32
		{
			struct timespec delay = { 0, 0 } ;
			delay.tv_nsec= 1000 * atime ;
			nanosleep( & delay, NULL) ;
		}

#else
		{
			m_bits += atime ;
			if ( m_bits > 1000) { Sleep( 1) ;  m_bits -= 1000 ; }
				else { Sleep( 0) ; }
		}

		waiter() : m_bits( 0) { }

	protected:
		int	m_bits ;
#endif

} ;
	
	//
	
	typedef std::mt19937 rnd_type ;
	std::uniform_int_distribution<rnd_type::result_type> urand(0, 200) ;

class	worker : public ethread
{
	public:
		worker(econduit &, unsigned int	aseed, char cid) ;

		void	work(void) ;

		static void	setcount(int) ;

	protected:
		static std::atomic<int>	s_count ;

	private:
		char m_id ;

		rnd_type	m_rseed ;
		waiter		xer ;	// a helper object for waiting

		econduit & 	m_dest ;
		
} ;

	std::atomic<int>	worker::s_count( 0) ;

	void	worker::setcount(int acount) { s_count= acount ; }

class	storer : public ethread
{
	public:
		storer(econduit &asrc) : m_src(asrc) { }

		void	work(void) ;

	private:
		static const int	kWorksize = 1024 ;

		econduit &	m_src ;
		char	workstring[kWorksize] ;
} ;

	worker::worker(econduit & adest, unsigned int aseed, char cid) : m_dest( adest), m_id( cid)
	{
		m_rseed.seed( aseed) ;
	}

	void	worker::work(void)
	{
		int iwk ;

		int ival= urand( m_rseed) ;
		while (( iwk= s_count --) > 0 )
		{
			xer.wait_us( urand( m_rseed)) ;
			m_dest.add( new simplework( m_id)) ;
		}

		s_count= 0 ;
	}

	void	storer::work(void)
	{
		simplework * wkptr ;
		char *sfill= workstring ;
		char * slimit= workstring + kWorksize - 1;

		while ((sfill < slimit) && ( wkptr= m_src.get()))
		{
			*( sfill ++)= wkptr-> m_work ;
			delete wkptr ;
		}
		* sfill= '\0' ;

		printf("ASSEM: %s\n", workstring) ;
	}

	//

int	main(int N, char ** S)
{
	econduit	egate ;

	worker * x1, * x2 ;
	storer * y1 ;

	srand( time( NULL)) ;

	x1= new worker(egate, rand(), 'a') ;
	x2= new worker(egate, rand(), 'b') ;
	y1= new storer( egate) ;

	worker::setcount( 400) ;

	x1-> launch() ;
	x2-> launch() ;
	y1-> launch() ;

	x1-> join() ;
	x2-> join() ;
	egate.done() ;

	y1-> join() ;

	delete x1 ;
	delete x2 ;
	delete y1 ;

	return 0 ;
}

