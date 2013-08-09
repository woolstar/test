#include <stdio.h>
#include <stdlib.h>

#include <thread>		// note, requires flag -std=c++11 for gcc
					//  ex: g++ -std=c++11 threadtest.cpp -pthread -o tt
					//  os x: clang++ -std=c++11 -stdlib=libc++ threadtest.cpp -o tt
#include <random>

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


