
	// Compile time Sum

template <unsigned...> struct Sum ;
template <unsigned size> struct Sum<size> { enum { value = size } ; } ;
template <unsigned size, unsigned... sizes>
	struct Sum<size, sizes...> { enum { value = size + Sum<sizes...>::value } ; } ;

static_assert(Sum<1, 2, 3, 4>::value == 10, "") ;

	// Store

template <unsigned bits> struct Store ;

template <> struct Store<8> { typedef uint8_t Type ; }
template <> struct Store<32> { typedef uint32_t Type ; }

	// def

template <unsigned... sizes>
class Bitfields {
		typename Store<Sum<sizes...>::value>::Type store ;

		public:
			template <unsigned pos, unsigned b4, unsigned size, unsigned... more>
				friend unsigned getImpl(Bitfields<size, more...>) ;

	} ;

	// value

template <unsigned pos, unsigned... sizes>
	unsigned get(Bitfields<sizes...> bf) { return getImpl<pos, 0>(bf) ; }

	// impl

template <unsigned pos, unsigned b4, unsigned size, unsigned... sizes>
	unsigned getImpl(Bitfields<size, sizes...> bf)
	{
		static_assert(pos <= sizeof...(sizes), "Invalid bitfield access") ;
		if ( 0 == pos ) {
			if ( 1 == size ) { return (bf.store & 1u << b4)) != 0 ; }
			return ( bf.store >> b4) & (( 1u << size) -1 ) ;
		}
		return getImpl<pos - (pos ? 1 : 0), b4 + (pos ? size : 0)>(bf) ;
	}

	// so the last line never runs with pos=0, but the compiler doesn't know that
	// the (pos ? 1 : 0) is there for the compiler not to freak out
	// and avoides having to have two cases that sepcialize for pos > 0 & 0.

	// on the border of clever

