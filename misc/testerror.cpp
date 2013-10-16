#include <stdlib.h>

class	C
{
	public:
		C() { }

		C(int aval) : C('i') { }
		C(char) : C(42) { }

} ;

int main(int N, char ** S)
{
	C	test(1) ;

	return 0 ;
}

