#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <thread>		// note, requires flag -std=c++11 for gcc 4.7, or -std=c++0x for gcc 4.6
						//  ex: g++ -std=c++11 threadatomic.cpp -pthread -o ta
#include <atomic>
#include <random>
// #include <chrono>	until gcc 4.8, libstdc++ has to manually be built with --enable-libstdcxx-time
						// in order to support sleep_for()
						// SEE: http://stackoverflow.com/questions/12523122/

#ifdef WIN32
#	include <windows.h>
#endif

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

	typedef std::mt19937 rnd_type ;
	std::uniform_int_distribution<rnd_type::result_type> urand(0, 400) ;

class	worker : public ethread
{
	public:
		worker(unsigned int	aseed, char cid) ;

		void	work(void) ;

		static void		setcount(int) ;

	protected:
		static std::atomic<int>	s_count ;

	private:
		char m_id ;

		int	 m_ct ;

		rnd_type	m_rseed ;
		
} ;

	std::atomic<int>	worker::s_count( 0) ;

	void	worker::setcount(int aval)
	{
		s_count= aval ;
	}

	worker::worker(unsigned int aseed, char cid) : m_id( cid), m_ct( 0)
	{
		m_rseed.seed( aseed) ;
		// auto rand= std::bind(urand, m_rseed)
	}

	void	worker::work(void)
	{
		int iwk ;
		// std::chrono::microseconds	us( 1) ;
#ifndef WIN32
		struct timespec delay = { 0, 0 } ;
#else
		int iadd= 0 ;
#endif

		while (( iwk= s_count -- ) > 0)
		{
			m_ct ++ ;

			// m_thread-> sleep_for( urand( m_rseed) * us) ;
#ifndef WIN32
			delay.tv_nsec= 1000 * urand( m_rseed) ;
			nanosleep( & delay, NULL) ;
#else
			iadd += urand( m_rseed) ;
			if ( iadd > 1000 ) { Sleep( 1) ;  iadd -= 1000 ; }
				else { Sleep( 0) ; }
#endif
		}

		s_count= 0 ;	// overwrite incase count went negative

		printf("worker %c : %d\n", m_id, m_ct ) ;
	}

int	main(int N, char ** S)
{
	worker * x1, * x2 ;

	srand( time( NULL)) ;

	x1= new worker(rand(), 'a') ;
	x2= new worker(rand(), 'b') ;
	worker::setcount(500) ;

	x1-> launch() ;
	x2-> launch() ;

	x1-> join() ;
	x2-> join() ;

	delete x1 ;
	delete x2 ;

	return 0 ;
}

