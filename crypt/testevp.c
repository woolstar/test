#include <openssl/evp.h>

		// urand.c
	extern int	gen_rand(unsigned char *, int alen) ;
		// uasc.c
	extern const char *	asc_85( unsigned long lval) ;

	static int	keylen= ( 128 / 8 ) ;	// std length

int main(int N, char ** S)
{
	EVP_CIPHER_CTX ctx;
	EVP_CipherInit_ex(&ctx, EVP_idea(), NULL, NULL, NULL, do_encrypt);
	EVP_CIPHER_CTX_set_key_length(&ctx, 10);
	EVP_CipherInit_ex(&ctx, NULL, NULL, key, iv, do_encrypt);

	... EVP_CipherInit_ex(&ctx, NULL, NULL, key, iv, do_encrypt);
	... EVP_CipherFinal_ex(&ctx, outbuf, &outlen)

	EVP_CIPHER_CTX_cleanup(&ctx);



}

