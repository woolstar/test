
#include <memory>

	// the basic type erasure pattern
	//	with adobe's recommended const worker
	//
	//	checking to see we can replace the concept while live
	//

class	test
{
	public:
		template <typename T> test( T x ) : work_( new adapter<T>( x) ) { }

		void	check( void) const { work_->check_() ; }

		template <typename T>
			void	adapt( T x ) const { work_.reset( new adapter<T>( x) ) ; }

	private:
		struct concept_t
		{
			virtual ~ concept_t () { }
			virtual void	check_( void) const = 0 ;
		} ;

		template <typename T>
			struct adapter : public concept_t
		{
			adapter( T x ) : op_( x) { }

			void	check_( void) const { op_.check() ; }

			T	op_ ;

		} ;

		mutable std::unique_ptr<const concept_t>	work_ ;
} ;

	int	_z = 0 ;


int	main(int N, char ** S)
{
	typedef struct { void check() const { _z= 1 ; } } wk1 ;
	typedef struct { void check() const { _z= 2 ; } } wk2 ;

	test	testobj( ( wk1() ) ) ;

	testobj.check() ;

	testobj.adapt( wk2()) ;
	testobj.check() ;
}


