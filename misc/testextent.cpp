#include <cstddef>
#include <iostream>
#include <type_traits>

	class	testcontainer
	{
		public:
			testcontainer(char * abuf, int nsize) : buffer_(abuf), size_( nsize) { }

			// constructor signature that does not work (due to decay)
			//     template<typename _uArray> testcontainer( _uArray abuf )
			// thankfully making it a REF prevents type decay

			template<typename _uArray> testcontainer( _uArray & abuf ) : testcontainer( abuf, std::extent< _uArray >::value ) { }

			size_t	getsize(void) const { return size_ ; }

		private:
			char	* buffer_ ;
			size_t	size_ ;
	} ;

	using std::cout ;

int	main(int N, char ** S)
{
	char	buffer[1024], smallbuf[64] ;
	testcontainer
		c1( buffer, sizeof(buffer) ),
		c2( buffer ),
		csmall( smallbuf ) ;

	cout << "Size of buffer : " << std::extent< decltype( buffer) >::value << ".\n" ;

	cout << "Size of c1 : " << c1.getsize() << ".\n" ;
	cout << "Size of c2 : " << c2.getsize() << ".\n" ;
	cout << "Size of csmall : " << csmall.getsize() << ".\n" ;

	return 0 ;
}


	// explaination at:
		// http://theotherbranch.wordpress.com/2011/08/24/template-parameter-deduction-from-array-dimensions/

