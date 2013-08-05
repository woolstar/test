#ifndef	E_LIST_DEF
#	define	E_LIST_DEF	1

#	include <stddef.h>

/***
	ELIST

	templates for creating simple lists (single & double linked)
	and all the associated helper elements to make them
	convenient (like linkable types for the elements, and iterators).

	**/


	// edata list
	//	the linear list base class fragment
	//	and utility functions like, getfirst(), count()
	//
	//	type <T> must have a member: m_next which is of type T* (listable)

template <class T> class	edata_slist ;
template <class T> class	edata_tlist ;

template <class T> class	edata_list
{
	public:
		edata_list() : m_first(NULL), m_last(NULL) { }

			// listable
			//	a helper class type for objects of type T
			//	resolves permission issues so that
			//	edata_list & edata_slist can access m_next

		class	listable {
			public:
				listable() : m_next(NULL) { }

					// provide public accessors for list stepping
				T * 		next(void) const { return m_next ; }
				static void	step(T * & aptr) {
								aptr= aptr-> m_next ;
							}
				static void	step(const T * & aptr) {
								aptr= aptr-> m_next ;
							}

			protected:
					// allows parent lists to manipulate pointers
				friend class	edata_list<T> ;

				T *	m_next ;
		} ;


	public:

			// iterator pointer
			//	used for stepping through the list and operating on it
			//	while ( ++ iptr ) { iptr-> foo() ; }
			//
		class	itrptr {
			public:
				itrptr(const edata_list & alist)
					: m_cur(NULL), m_rec(alist.getfirst()) { }
				itrptr(const edata_list * alist)
					: m_cur(NULL), m_rec(alist-> getfirst()) { }
				itrptr(T * astart)
					: m_cur(NULL), m_rec(astart) { }

				bool	step(void) {
							m_cur= m_rec ;
							if (m_rec) {
								listable::step(m_rec) ;
								return true ;
							}
							return false ;
						}
				bool	operator++() { return step() ; }
				bool	islast() const { return (NULL == m_rec) ; }

				T *		operator*() const { return m_cur ; }
				T *		operator->() const { return m_cur ; }

			protected:
				T *	m_cur, * m_rec ;
		} ;

		bool			isactive(void) const { return (NULL != m_first) ; }
		unsigned int	count(void) const {
							unsigned int ict ;  T * pstep= m_first ;
							for (ict= 0; (pstep); ict ++) { pstep= pstep-> m_next ; }
							return ict ;
						}
		T *				getfirst(void) const { return m_first ; }
		T *				getlast(void) const { return m_last ; }

	protected:
		T * m_first, * m_last ;
} ;

	// elist destroy
	//	mixin helper function for wiping out list
	//
template <class T> class elist_destroy : virtual public edata_list<T>
{
	public:
		void	destroy(void)
		{
			T * p, * q ;
			for (p= edata_list<T>::m_first; (p); p= q)
				{ q= p-> next();  delete p ; }
			edata_list<T>::m_first= edata_list<T>::m_last= NULL ;
		}
} ;

	// edata slist
	//	a singly linked list
	//
template <class T> class edata_slist : virtual public edata_list<T>
{
	public:
		class	listable : public edata_list<T>::listable
		{
			protected:
				friend class	edata_slist<T> ;
		} ;

		T *	add(T * aref)
		{
			if (edata_list<T>::m_last) { edata_list<T>::m_last-> m_next= aref ; }
				else { edata_list<T>::m_first= aref ; }
			edata_list<T>::m_last= aref, edata_list<T>::m_last-> m_next= NULL ;
			return aref ;
		}
} ;

	// edata tlist
	//	a doubly linked list
	//	effecient at removing objects in the middle
	//
template <class T> class edata_tlist : virtual public edata_list<T>
{
	public:

			// listable
			//	a helper class type for objects of type T
			//	initializes m_prev & m_next, as resolves access permissions
			//  (as with slist)

		class	listable : public edata_list<T>::listable
		{
			public:
				listable() : m_prev(NULL) { }

					// backwards compliments of listable
				T *			prev(void) const { return m_prev ; }

				static void	back(T * & aptr) { aptr= aptr-> m_prev ; }
				static void	back(const T * & aptr) { aptr= aptr-> m_prev ; }

			protected:
				friend class	edata_tlist<T> ;

				T	* m_prev ;
		} ;

			// add: link forward and back

		T * add(T * aref)
		{
			if (edata_list<T>::m_last) { edata_list<T>::m_last-> m_next= aref, aref-> m_prev= edata_list<T>::m_last ; }
				else { edata_list<T>::m_first= aref, aref-> m_prev= NULL ; }
			edata_list<T>::m_last= aref, edata_list<T>::m_last-> m_next= NULL ;
			return aref ;
		}

			// remove: remove from list
			//	added a safety in-case called by an object not in the list

		void remove(T * aref)
		{
			if (aref-> m_prev) { aref-> m_prev-> m_next= aref-> m_next ; }
				else { if (edata_list<T>::m_first == aref) { edata_list<T>::m_first= aref-> m_next ; } }
			if (aref-> m_next) { aref-> m_next-> m_prev= aref-> m_prev ; }
				else { if (edata_list<T>::m_last == aref) { edata_list<T>::m_last= aref-> m_prev ; } }
			aref-> m_prev= aref-> m_next= NULL ;
		}
} ;

#ifdef	TEST_LIST

	// compile with:  gcc -DTEST_LIST -x c++ elist.h -lstdc++

#include <stdio.h>
#include <stdlib.h>

	// sample implementations

class	simplevalue : public edata_slist<simplevalue>::listable
{
	public:
		simplevalue(int aval) : m_val(aval) { }
		const int	m_val ;
} ;

class	samplevalue : public edata_tlist<samplevalue>::listable
{
	public:
		samplevalue(int aval) : m_val(aval) { }
		const int	m_val ;
} ;

class	samplerdestroy : public edata_tlist<samplevalue>, public elist_destroy<samplevalue> { } ;

#define		CHECK(va, vb)	if (va != vb) { \
	fprintf(stderr, "test failed: %d != %d\n", va, vb) ;  exit(0) ; }

int		main(int, char **)
{
	edata_slist<simplevalue>	simplelist ;
	edata_tlist<samplevalue>	samplelist ;
	samplerdestroy	samplelist2 ;
	simplevalue * siptr ;
	samplevalue * svptr ;

	CHECK(samplelist.count(), 0) ;

		// simple
	simplelist.add(new simplevalue(1)) ;
	simplelist.add(new simplevalue(2)) ;
	simplelist.add(new simplevalue(3)) ;
	CHECK(simplelist.count(), 3) ;

	siptr= simplelist.getfirst() ;
	CHECK(siptr-> m_val, 1) ;

		// setup list
	samplelist.add(new samplevalue(1)) ;
	samplelist.add(new samplevalue(2)) ;
	samplelist.add(new samplevalue(3)) ;
	samplelist.add(new samplevalue(4)) ;

		// count test
	CHECK(samplelist.count(), 4) ;

		// element access test
	svptr= samplelist.getfirst() ;
	CHECK(svptr-> m_val, 1) ;
	svptr-> step(svptr) ;
	CHECK(svptr-> m_val, 2) ;
	svptr= samplelist.getlast() ;
	CHECK(svptr-> m_val, 4) ;

		// iterator test
	{
		int isum= 0 ;
		edata_tlist<samplevalue>::itrptr	itsv(samplelist) ;

		while ( ++ itsv) { isum += itsv-> m_val ; }
		CHECK(isum, 10) ;
	}

		// remove test(s)
	svptr= samplelist.getfirst() ;
	edata_list<samplevalue>::listable::step(svptr) ;
	samplelist.remove(svptr) ;
	CHECK(samplelist.count(), 3) ;
	delete svptr ;   // cleanup
	
		// iptr sum check
	{
		int isum= 0 ;
		edata_tlist<samplevalue>::itrptr	itsvp(samplelist) ;

		while (++ itsvp) { isum += itsvp-> m_val ; }
		CHECK(isum, 8) ;
	}

		// clone and destroy
	{
		edata_tlist<samplevalue>::itrptr	itsvp(samplelist) ;
		while ( ++ itsvp) { samplelist2.add(new samplevalue( itsvp-> m_val )) ; }

		CHECK(samplelist2.count(), 3) ;
		samplelist2.destroy() ;
		CHECK(samplelist2.count(), 0) ;
		samplelist2.add(new samplevalue( 10)) ;

		{
			int isum= 0 ;
			edata_tlist<samplevalue>::itrptr	itsvp(samplelist2) ;
			while ( ++ itsvp) { isum += itsvp-> m_val ; }
			CHECK(isum, 10) ;
		}
		samplelist2.destroy() ;
	}

	fprintf(stderr, "tests complete.\n") ;
	return 0 ;
}


#endif

#endif	// E_LIST_DEF

