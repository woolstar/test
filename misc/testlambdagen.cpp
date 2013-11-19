#include <functional>

auto	add_one= [](int x){ return x + 1 ; } ;

	// sorry, maybe c++1y will have auto return type
std::function<int(int)>	gen_addone(void)
{
	static auto l_= [](int x){ return x + 1 ; } ;
	return l_ ;
}

int	main() { }

