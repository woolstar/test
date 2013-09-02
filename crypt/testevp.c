#include <openssl/evp.h>

		// urand.c
	extern int	gen_rand(unsigned char *, int alen) ;
		// uasc.c
	extern const char *	asc_85( unsigned long lval) ;

	static int	keylen= ( 128 / 8 ) ;	// std length

int main(int N, char ** S)
{
	unsigned char key[]= "helloworld" ;
	unsigned char iv[]= "12345678" ;

	EVP_CIPHER_CTX ctx;

	OpenSSL_add_all_ciphers() ;

	EVP_CipherInit_ex(&ctx, EVP_bf_cbc(), NULL, NULL, NULL, 1);
	EVP_CIPHER_CTX_set_key_length(&ctx, 10);
	EVP_CipherInit_ex(&ctx, NULL, NULL, key, iv, -1);

	// ... EVP_CipherFinal_ex(&ctx, outbuf, &outlen)

	EVP_CIPHER_CTX_cleanup(&ctx);
	EVP_cleanup() ;

}

