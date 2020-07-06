#include <cstdint>

	// Evaluate compiler behavour with various large number reductions
	// Hint: its not always happy, even with -O
	// Best result, clang. Worst arm64 gcc.

int mod68(uint64_t num) {
    return num % 68;
}

uint64_t div68( uint64_t num )
{
    return num / 68 ;
}

struct both { uint64_t redux ; int remain ; } ;

both reduce68( uint64_t num ) 
{
    both ret ;

    ret.redux = num / 68 ;
    ret.remain= num % 68  ;
    return ret ;
}

#if INTPTR_MAX == INT64_MAX 

struct bothx { unsigned __int128 redux ; int remain ; } ;

int mod68(unsigned __int128 num)
{
    return num % 68 ;
}

__int128 div( __int128 num )
{
	return num / 68 ;
}

bothx reduce68( unsigned __int128 num )
{
    bothx ret ;

    ret.redux= num / 68 ;
    ret.remain= num % 68  ;
    return ret ;
}

	// pre-optimized
bothx reduce69u( unsigned __int128 num )
{
    bothx ret ;

    ret.redux= num / 69  ;
    ret.remain= num - ret.redux * 69 ;
    return ret ;
}

#endif
