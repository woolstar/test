
		//// pack operators

extern const char *    pack_a85( unsigned long lval) ;
extern const char *    pack_a85e( unsigned long lval) ;  // pack without '.' shortcut

extern unsigned long   unpack_a85( const char * astr) ;
extern unsigned long   unpack_a85x( const char * astr, int * zlen ) ;	// unpack with fragment tracking

		//// array operators

void	encode_asc85(char * zdest, int asz, const unsigned char * asrc, int alen) ;
int		decode_asc85(unsigned char * zdest, int asz, const char * asrc) ;

