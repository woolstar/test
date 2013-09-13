
template <unsigned...> struct Sum ;
template <unsigned size> struct Sum<size> { enum { value = size } ; } ;
template <unsigned size, unsigned... sizes>
	struct Sum<size, sizes...> { enum { value = size + Sum<sizes...>::value } ; } ;

static_assert(Sum<1, 2, 3, 4>::value == 10, "") ;

