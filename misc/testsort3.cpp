#include <vector>
#include <algorithm>
#include <chrono>
#include <memory>
#include <random>
#include <iostream>
#include <iomanip>
#include <chrono>
#include <cstring>
#include <cmath>
#include <cassert>
#include <utility>

		// datatype

	typedef int		datatype ;
	typedef std::vector<datatype>	containtype ;

		// sorts

		// BUBBLE SORT
		// - still the worst sort ever
		//
struct container_bubble_sort {
	void operator()(containtype::iterator afirst, containtype::iterator alast) const
	{
		int ctswaps ;

		do
		{
			auto p1= afirst ;
			auto p2= p1 +1 ;

			ctswaps= 0 ;
			while ( p2 < alast )
			{
					// compare adjacent values and swap if out of order
				if ( * p2 < * p1 ) { std::iter_swap( p2, p1) ;  ctswaps ++ ; }  
				++ p2, ++ p1 ;
			}
		}
				// keep starting over if any values have be re-arranged
			while ( ctswaps ) ;
	}

	const char * name(void) const { return "bubble sort" ; }
} ;

struct raw_bubble_sort {
	void operator()(datatype * afirst, datatype * alast) const
	{
		int ctswaps ;
		datatype * p1, * p2 ;

		do
		{
			p1= afirst, p2= p1 + 1, ctswaps= 0 ;
			while ( p2 < alast )
			{
				if ( * p2 < * p1 ) { std::iter_swap( p2, p1) ;  ctswaps ++ ; }
				++ p2, ++ p1 ;
			}
		}
			while ( ctswaps ) ;
	}

	const char * name(void) const { return "raw bubble sort" ; }
} ;

	// SELECTION SORT
	// - less moves, but ends up being worse than insertion sort
	//
struct container_selection_sort {
	void operator()(containtype::iterator afirst, containtype::iterator alast) const
	{
		while ( afirst < alast )
		{
				// look for a lower value in the rest of the list than what's at * afirst
			auto plook= afirst, pbest= afirst ;
			for ( ++ plook ; ( plook < alast ) ; ++ plook )
				{ if ( * plook < * pbest ) { pbest= plook ; } }
			if ( pbest != afirst ) { std::iter_swap( afirst, pbest) ; }
			++ afirst ;
		}
	}

	const char * name(void) const { return "selection sort" ; }
} ;

struct raw_selection_sort {
	void operator()(datatype * afirst, datatype * alast) const
	{
		datatype * plook, * pbest, dvalue ;

		while ( afirst < alast )
		{
			for ( pbest= afirst, plook= afirst +1 ; ( plook < alast ) ; ++ plook )
				{ if ( * plook < * pbest ) { pbest= plook ; } }
			if ( pbest != afirst ) { std::iter_swap( afirst, pbest) ; }
			++ afirst ;
		}
	}

	const char * name(void) const { return "raw selection sort" ; }
} ;

	// INSERTION SORT
	// - involves almost as many moves as bubble sort, but runs way better
	//
struct container_insertion_sort {
	void operator()(containtype::iterator afirst, containtype::iterator alast) const
	{
		auto pstep= afirst + 1 ;
		datatype dvalue ;

		while ( pstep < alast )
		{
			auto psear= pstep -1 ;
			dvalue= * pstep ;

			// look for the spot that * pstep should be in the already sorted list  
			while (( psear >= afirst ) && ( * psear > dvalue )) { -- psear ; }
				// give VC debug fits because psear can end up being less than first

			++ psear ;
				// rotate larger elements around behind * pstep 
			if ( psear < pstep ) { std::rotate( psear, pstep, pstep +1) ; }
			++ pstep ;
		}
	}

	const char * name(void) const { return "insertion sort" ; }
} ;

struct raw_insertion_sort {
	void operator()(datatype * afirst, datatype * alast) const
	{
		datatype * pstep, * psear, dvalue ;
		size_t recsize = sizeof( datatype) ;

		pstep= afirst +1 ;

		while ( pstep < alast )
		{
			dvalue= * pstep, psear= pstep -1 ;
			while (( psear >= afirst ) && ( * psear > dvalue )) { -- psear ; }

			++ psear ;
			if ( psear < pstep ) {
				std::memmove( psear +1, psear, recsize * ( pstep - psear )) ;
				* psear= dvalue ;
			}
			++ pstep ;
		}
	}

	const char * name(void) const { return "raw insertion sort" ; }
} ;

	// SHELL SORT
	// - supposedly the best nonrecursive sort out there
	//

template <class C>
struct container_shell_sort
{
	void operator()(typename C::iterator afirst, typename C::iterator alast) const
	{
		unsigned long hgap= alast - afirst ;
		unsigned long tco ;
		typename C::value_type dvalue ;

			// Sedgewick gap cooef
		for ( tco= 1 ; ( ( 4 * tco * tco ) <= hgap ) ; tco += tco ) { } ;
		for ( hgap /= 4 ; ( tco > 0 ) ; tco /= 2, hgap= ( tco * tco ) - ( 3 * tco )/2 + 1 )
		{
			auto pstep= afirst + hgap ;
			for ( ; ( pstep < alast ) ; ++ pstep )
			{
				auto psear= pstep - hgap ;
				auto pfollow= pstep ;
				dvalue= *( pstep) ;
				while (( psear >= afirst ) && ( dvalue < * psear ))
					{ * pfollow= * psear, pfollow= psear ;  psear -= hgap ; }
				* pfollow= dvalue ;
			}
		}
	}

	const char * name(void) const { return "shell sort" ; }
} ;

template <typename D>
struct raw_shell_sort
{
	void operator()(D * afirst, D * alast) const
	{
		unsigned long hgap= alast - afirst ;
		unsigned long tco ;
		D * pstep, * psear, * pfollow, dvalue ;

			// Sedgewick gap cooef
		for ( tco= 1 ; ( ( 4 * tco * tco ) <= hgap ) ; tco += tco ) { } ;
		for ( hgap /= 4 ; ( tco > 0 ) ; tco /= 2, hgap= ( tco * tco ) - ( 3 * tco )/2 + 1 )
		{
			for (pstep= afirst + hgap  ; ( pstep < alast ) ; ++ pstep )
			{
				for (psear= pstep - hgap, pfollow= pstep, dvalue= *( pstep) ;
						(( psear >= afirst ) && ( dvalue < * psear )) ;
						pfollow= psear, psear -= hgap )
					{ * pfollow= * psear ; }

				* pfollow= dvalue ;
			}
		}
	}

	const char * name(void) const { return "raw shell sort" ; }
} ;

	// MERGE SORT
	// - divide and conqure, does great on cache coherency
	//

template <class C>
struct container_merge_sort {
	void operator()(typename C::iterator afirst, typename C::iterator alast) const
	{
		size_t delta= alast - afirst ;
		if ( delta > 1 )
		{
			auto pmiddle= afirst + ( delta / 2 ) ;

				// divide and sort each half
			container_merge_sort()( afirst, pmiddle ) ;
			container_merge_sort()( pmiddle, alast) ;

			// could also do: (* this)( afirst, pmiddle) ;

				// merge
			std::inplace_merge( afirst, pmiddle, alast) ;
		}
	}

	const char * name(void) const { return "merge sort" ; }
} ;

template <typename D>
struct raw_merge_sort {
	void operator()(D * afirst, D * alast) const
	{
		size_t delta= alast - afirst ;
		if ( delta > 1 )
		{
			D * pmiddle = afirst + ( delta / 2 ) ;

			raw_merge_sort()( afirst, pmiddle ) ;
			raw_merge_sort()( pmiddle, alast ) ;

			D dvalue ;
			size_t recsize = sizeof( D) ;

				// in-place merge 
			while (( afirst < pmiddle ) && ( pmiddle < alast ))
			{
				if ( * afirst < * pmiddle ) { ++ afirst ;  continue ; }

					// shuffle remainder of left around and insert one from the right
				dvalue= * pmiddle ;
				std::memmove( afirst +1, afirst, recsize * ( pmiddle - afirst )) ;
				*( afirst ++)= dvalue ;  ++ pmiddle ;
			}
		}
	}

	const char * name(void) const { return "raw merge sort" ; }
} ;

template <typename D>
struct buffered_merge_sort {
	class	worker_
	{
		public:
			worker_( size_t aspace ) : buffer_( new D[ aspace] ), bufsize_{ aspace } { }
			void operator()( D * afirst, D * alast)
			{
				size_t delta= alast - afirst ;
				if ( delta < 2 ) return ;
				delta /= 2 ;

				D * pmiddle = afirst + delta ;

				(* this)( afirst, pmiddle) ;
				(* this)( pmiddle, alast) ;

					// copy first half to the buffer space 
				D * pbufstep, * pbuflimit ;
				std::memcpy( buffer_.get(), afirst, delta * sizeof( D)) ;
				pbufstep= buffer_.get(), pbuflimit= pbufstep + delta ;

					// merge the second half and the buffered half together
				while ( ( pmiddle < alast ) && ( pbufstep < pbuflimit ))
				{
					if ( * pbufstep < * pmiddle ) { *( afirst ++)= *( pbufstep ++) ; }
						else { *( afirst ++)= *( pmiddle ++) ; }
				}
				
					// copy any remainders of the buffered list over
				while ( pbufstep < pbuflimit ) { *( afirst ++)= *( pbufstep ++) ; }
			}

		private:
			std::unique_ptr< D[] >	buffer_ ;
			size_t	bufsize_ = 0 ;
	} ;

	void operator()( D * afirst, D * alast) const
	{
		size_t span= ( alast - afirst ) ;
		worker_	sort( ( span / 2 ) + 1 ) ;

		if ( span > 1 ) { sort( afirst, alast) ; }
	}

	const char * name(void) const { return "buffered merge sort" ; }
} ;

	////

	// SYSTEM QSORT

	template <typename D>
	static int  compare_func( const D * pa, const D * pb )
				{ D delt= * pa - * pb ;  return ( delt > 0 ) ? 1 : (( delt < 0 ) ? -1 : 0 ) ; }

		// default pointer types to qsort void *, not datatype *
	typedef int ( * compare_func_t ) ( const void *, const void * ) ;

template <typename D>
struct raw_qsort {
	void operator()(D * afirst, D * alast) const
		{ qsort( afirst, ( alast - afirst ), sizeof( D), ( compare_func_t ) compare_func<D>) ; }

	const char * name(void) const { return "raw qsort" ; }
} ;

	// STL SORT

template <class C>
struct stl_sort {
	void operator()(typename C::iterator afirst, typename C::iterator alast) const { std::sort( afirst, alast) ; }
	const char * name(void) const { return "stl qsort" ; }
} ;


	////

	// Framework: initializer, run & timer

class	Runner
{
	public:
		enum ConstructArg { Raw } ;

		template <typename T>
			Runner( T x) : worker_( new adapter_container<T>( std::move( x)) ) {} 
		template <typename T>
			Runner( T x, ConstructArg) : worker_( new adapter_raw<T>( std::move( x)) )  {} 

		void	sort( containtype & ac ) const { worker_ -> sort_( ac) ; }
		const char * name(void) const { return worker_ -> name_() ; }

	private:
		struct concept_t {
			virtual ~concept_t() = default ;
			virtual void sort_( containtype & ) const = 0 ;
			virtual const char * name_(void) const = 0 ;
		} ;

		template <typename T>
			struct adapter_container : public concept_t
			{
				adapter_container( T && x ) : op_(x) {}
				void sort_( containtype & ac ) const { op_(ac.begin(), ac.end()) ; }
				const char * name_(void) const { return op_.name() ; }
				T op_ ;
			} ;

		template <typename T>
			struct adapter_raw : public concept_t
			{
				adapter_raw( T && x ) : op_( x) {}
				void sort_( containtype & ac ) const { op_(ac.data(), ac.data() + ac.size()) ; }
				const char * name_(void) const { return op_.name() ; }
				T op_ ;
			} ;

		std::unique_ptr<const concept_t> worker_ ;
} ;

	template <typename TCon> void print_range( TCon const & acon )
	{
		std::cerr << '[' ;
		for ( const auto & i : acon ) { std::cerr << ' ' << i << ',' ; }
		std::cerr << "]\n" ;
	}

	typedef std::chrono::duration<double, std::milli>	timespan ;

	using std::cout ;
	using std::chrono::high_resolution_clock ; ;

#ifndef SLOW_TESTS
#	define	SLOW_TESTS	0
#endif

void	simple_test( const containtype & alist )
{
	for ( auto & sorter : {

#if SLOW_TESTS
			Runner( container_bubble_sort() ), 
			Runner( raw_bubble_sort(), Runner::Raw ),
			Runner( container_selection_sort() ),
			Runner( raw_selection_sort(), Runner::Raw ),
			Runner( container_insertion_sort() ),
			Runner( raw_insertion_sort(), Runner::Raw ),
#endif

			Runner( container_shell_sort<containtype>() ),
			Runner( raw_shell_sort<datatype>(), Runner::Raw ),
			Runner( container_merge_sort<containtype>() ),
#if SLOW_TESTS
			Runner( raw_merge_sort<datatype>(), Runner::Raw ),
#endif
			Runner( buffered_merge_sort<datatype>(), Runner::Raw ),
			Runner( raw_qsort<datatype>(), Runner::Raw ),
			Runner( stl_sort<containtype>() ),

		} )
	{
		containtype tmp = alist ;
		std::cout << sorter.name() << ": " ;

		auto tstart= high_resolution_clock::now() ;
		sorter.sort( tmp) ;

		timespan dt = high_resolution_clock::now() - tstart ;
		cout << std::setprecision( 9) << 0.01 * std::floor( 100. * dt.count() ) << " ms\n" ;

		if ( ! std::is_sorted( tmp.begin(), tmp.end() ))
		{
			cout << "-- invalid result\n" ;
			if ( tmp.size() < 200 ) print_range( tmp ) ;
		}
	}
}

	static void	generate( int n, containtype & zdest)
	{
		std::random_device	rd ;
		std::mt19937 gen( rd()) ;
		std::uniform_real_distribution<> spread( 0., 10. * n) ;

		zdest.reserve( n) ;
		while ( n -- ) { zdest.push_back( spread( gen)) ; }
	}

int main(int N, char ** S)
{
	containtype	data ;
	int ival= 0 ;

	N --, S ++ ;
	if ( N && ('-' == ** S)) { std::cerr << "Usage:  testsort <n>  -- specify number of items to sort\n" ;  exit( 1) ; }

	if ( N ) { ival= atoi( * S) ;  N --, S ++ ; }
	if ( ! ival ) ival= 10000 ;

	generate( ival, data) ;
	simple_test( data) ;
}

