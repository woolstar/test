// simulate <algorithm>

#include <cstdio>

namespace exp
{

  template <class T>
  void
  swap(T& x, T& y)
  {
	printf("generic exp::swap\n");
	T tmp = x;
	x = y;
	y = tmp;
  }

  template <class T>
  void algorithm(T* begin, T* end)
  {
	if (end-begin >= 2)
	  swap(begin[0], begin[1]);
  }

}

// simulate user code which includes <algorithm>

namespace U
{
  template <class T>
	struct A { T val_ ; } ;

  template <class T>
	void swap(A<T>&, A<T>&)
	{
	  printf("U swap(A<T>, A<T>)\n") ;	// this one should get picked
	}
}

template <class T>
  void swap(U::A<T>&, U::A<T>&)
  {
	printf("swap(A, A)\n");
  }

// exercise simulation

int main()
{
  U::A<int> a[2] = { 10, 20 } ;
  exp::algorithm(a, a+2);
}

