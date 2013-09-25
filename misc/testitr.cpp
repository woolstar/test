#include <stdio.h>

#include <ecore.h>
#include <etree.h>

class	testv : public edata_treeitr<testv>::node
{
	public:
		testv( int i) : node( i) { }
		testv() : node( -1) { }

		void	print(void) { ::printf("  v= %d\n", m_key) ; }
} ;

int	main(int n, char **)
{
	int ilist[]= { 10, 11, 8, 4, 20, 40, 31, 32, 33, 30, 2, 1, 0 } ;
	int * istep ;

	class	testtree : public edata_aatree<testv>, public edata_treeitr<testv>
	{
	}
		_tree ;

	for ( istep= ilist; ( * istep ) ; istep ++ ) {
		_tree.add( new testv(* istep)) ;
	}

	{
		edata_treeitr<testv>::iptr	istep( _tree) ;

		::printf("list out:\n") ;
		while ( ++ istep ) {
			istep-> print() ;
		}
	}

	return 0 ;
}

