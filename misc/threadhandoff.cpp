#include <stdio.h>
#include <stdlib.h>

#include <thread>		// note, requires flag -std=c++11 for gcc
						//  ex: g++ -std=c++11 threadtest.cpp -pthread -o tt
#include <atomic>
#include <condition_variable>
#include <functional>
#include <chrono>
#include <random>
#include "elist.h"

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
	auto lamdaready = [this](){ return ( this-> iwork && ! this-> istate) ; } ;

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
	
	typedef std::mt19937 rnd_type ;
	std::uniform_int_distribution<rnd_type::result_type> urand(0, 200) ;

class	worker : public ethread
{
	public:
		worker(unsigned int	aseed, char cid) ;

		void	work(void) ;

	private:
		char m_id ;

		rnd_type	m_rseed ;
		
} ;

class	storer : public ethread
{
	public:
		storer(econduit &asrc) : m_src(asrc) { }

		void	work(void) ;

	private:
		econduit &	m_src ;
		char	workstring[1024] ;
} ;

	worker::worker(unsigned int aseed, char cid) : m_id( cid)
	{
		m_rseed.seed( aseed) ;
		// auto rand= std::bind(urand, m_rseed)
	}

	void	worker::work(void)
	{
		int ival= urand( m_rseed) ;

		printf("worker %c : %d\n", m_id, ival ) ;
	}

	void	storer::work(void)
	{
	}

	//

int	main(int N, char ** S)
{
	worker * x1, * x2 ;

	srand( time( NULL)) ;

	x1= new worker(rand(), 'a') ;
	x2= new worker(rand(), 'b') ;

	x1-> launch() ;
	x2-> launch() ;

	x1-> join() ;
	x2-> join() ;

	delete x1 ;
	delete x2 ;

	return 0 ;
}

