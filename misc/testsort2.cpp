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

		// datatype

	typedef int		datatype ;
	typedef std::vector<datatype>	containtype ;

		// sorts

		// BUBBLE SORT
		// - still the worst sort ever
		//
struct container_bubble_sort {
	void operator()(containtype::iterator afirst, containtype::iterator alast)
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
	void operator()(datatype * afirst, datatype * alast)
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
	void operator()(containtype::iterator afirst, containtype::iterator alast)
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
	void operator()(datatype * afirst, datatype * alast)
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
	void operator()(containtype::iterator afirst, containtype::iterator alast)
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
	void operator()(datatype * afirst, datatype * alast)
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

struct container_shell_sort
{
	void operator()(containtype::iterator afirst, containtype::iterator alast)
	{
		unsigned long hgap= alast - afirst ;
		unsigned long tco ;
		datatype dvalue ;

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

struct raw_shell_sort
{
	void operator()(datatype * afirst, datatype * alast)
	{
	}

	const char * name(void) const { return "raw shell sort" ; }
} ;

	// MERGE SORT
	// - divide and conqure, does great on cache coherency
	//

struct container_merge_sort {
	void operator()(containtype::iterator afirst, containtype::iterator alast)
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

struct raw_merge_sort {
	void operator()(datatype * afirst, datatype * alast)
	{
		size_t delta= alast - afirst ;
		if ( delta > 1 )
		{
			datatype * pmiddle = afirst + ( delta / 2 ) ;

			raw_merge_sort()( afirst, pmiddle ) ;
			raw_merge_sort()( pmiddle, alast ) ;

			datatype dvalue ;
			size_t recsize = sizeof( datatype) ;

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

class buffered_merge_sort {
	protected:
		void subsort( datatype * afirst, datatype * alast)
		{
			size_t delta= alast - afirst ;
			if ( delta < 2 ) return ;
			delta /= 2 ;

			datatype * pmiddle = afirst + delta ;

			subsort( afirst, pmiddle) ;
			subsort( pmiddle, alast) ;

				// copy first half to the buffer space 
			datatype * pbufstep, * pbuflimit ;
			std::memcpy( buffer_.get(), afirst, delta * sizeof( datatype)) ;
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

	public:

		void operator()(datatype * afirst, datatype * alast)
		{
			size_t delta= ( alast - afirst ) / 2 ;
			if ( delta )
			{
				++ delta ;
				if ( delta > bufsize_ ) { buffer_.reset( new datatype[ delta] ) ;  bufsize_ = delta ; }
			}

			subsort( afirst, alast) ;
		}

		const char * name(void) const { return "buffered merge sort" ; }

	private:
		std::unique_ptr< datatype[] >	buffer_ ;
		size_t	bufsize_ = 0 ;
} ;

	////

	// SYSTEM QSORT

	static int  compare_func( const datatype * pa, const datatype * pb )
				{ datatype delt= * pa - * pb ;  return ( delt > 0 ) ? 1 : (( delt < 0 ) ? -1 : 0 ) ; }

		// default pointer types to qsort void *, not datatype *
	typedef int ( * compare_func_t ) ( const void *, const void * ) ;

struct raw_qsort {
	void operator()(datatype * afirst, datatype * alast)
		{ qsort( afirst, ( alast - afirst ), sizeof( datatype), ( compare_func_t ) compare_func) ; }

	const char * name(void) const { return "raw qsort" ; }
} ;

	// STL SORT

struct stl_sort {
	void operator()(containtype::iterator afirst, containtype::iterator alast)
		{ std::sort( afirst, alast) ; }

	const char * name(void) const { return "stl qsort" ; }
} ;


	////

	// Framework: initializer, run & timer

struct	Runner
{
	Runner(const containtype & asrc) : sort_( asrc) {}
	virtual ~ Runner() {}

	virtual	void dosort(void) = 0 ;
	virtual const char * name(void) const = 0 ;

	containtype sort_ ;
} ;

template <typename _uFunct> class TCRunner : public Runner
{
	public:
		static std::unique_ptr<Runner>	generate( const containtype & alist )
						{ return std::unique_ptr<Runner>( new TCRunner( alist)) ; }

		void dosort(void) { op_(sort_.begin(), sort_.end()) ; }
		const char * name(void) const { return op_.name() ; }

	protected:
		TCRunner(const containtype & asrc) : Runner( asrc) { }

		_uFunct	op_ ;
} ;

template <typename _uFunct> class TRRunner : public Runner
{
	public:
		static std::unique_ptr<Runner>	generate( const containtype & alist )
						{ return std::unique_ptr<Runner>( new TRRunner( alist)) ; }

		void dosort(void) { op_(sort_.data(), sort_.data() + sort_.size()) ; }
		const char * name(void) const { return op_.name() ; }

	protected:
		TRRunner(const containtype & asrc) : Runner( asrc) { }

		_uFunct	op_ ;
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

void	simple_test( const containtype & alist )
{
	for ( auto & sorter : {
			TCRunner<container_bubble_sort>::generate( alist),
			TRRunner<raw_bubble_sort>::generate( alist ),
			TCRunner<container_selection_sort>::generate( alist),
			TRRunner<raw_selection_sort>::generate( alist ),
			TCRunner<container_insertion_sort>::generate( alist),
			TRRunner<raw_insertion_sort>::generate( alist ),
			TCRunner<container_shell_sort>::generate( alist),
			TCRunner<container_merge_sort>::generate( alist),
			TRRunner<raw_merge_sort>::generate( alist),
			TRRunner<buffered_merge_sort>::generate( alist),
			TRRunner<raw_qsort>::generate( alist),
			TCRunner<stl_sort>::generate( alist)
		} )
	{
		std::cout << "Sort " << sorter-> name() << ": " ;

		auto tstart= high_resolution_clock::now() ;
		sorter-> dosort() ;

		timespan dt = high_resolution_clock::now() - tstart ;
		cout << std::setprecision( 9) << 0.1 * std::floor( 10. * dt.count() ) << " ms\n" ;

		if ( ! std::is_sorted( sorter-> sort_.begin(), sorter-> sort_.end() ))
		{
			cout << "-- invalid result\n" ;
			if ( sorter-> sort_.size() < 200 )
				print_range( sorter-> sort_ ) ;
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
	if ( N ) { ival= atoi( * S) ;  N --, S ++ ; }
	if ( ! ival ) ival= 10000 ;

	generate( ival, data) ;
	simple_test( data) ;
}


