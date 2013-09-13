#include <stdio.h>
#include <string.h>
#include <openssl/evp.h>

		// urand.c
	extern int	gen_rand(unsigned char *, int alen) ;
		// uasc.c
	extern void	encode_asc85(char * zbuf, int asz, const unsigned char * asrc, int alen) ;

	static int	keylen= ( 128 / 8 ) ;	// std length

	char test[64]= "Greetings from the junkpile\tFoo\t\nTake me to your stove.\rhuh\ngb*" ;
	char buffer[128 + EVP_MAX_BLOCK_LENGTH], buffer2[128 + EVP_MAX_BLOCK_LENGTH] ;
	char printbuf[200] ;

int main(int N, char ** S)
{
	unsigned char key[]= "helloworld" ;
	unsigned char iv[]= "12345678" ;
	char * destp ;
	int iuse, iuse2 ;

	EVP_CIPHER_CTX ctx;

	OpenSSL_add_all_ciphers() ;

	// printf("test: (%s) len %ld.\n", test, strlen(test)) ;

	EVP_CIPHER_CTX_init(&ctx) ;

		// round 1
	EVP_CipherInit_ex(&ctx, EVP_bf_cbc(), NULL, NULL, NULL, 1);
	EVP_CIPHER_CTX_set_key_length(&ctx, 10);
	EVP_CipherInit_ex(&ctx, NULL, NULL, key, iv, -1);

	destp= buffer ;

	EVP_CipherUpdate(&ctx, destp, &iuse, test, strlen(test) +1) ;
	destp += iuse ;
	EVP_CipherFinal_ex(&ctx, destp, &iuse) ;
	destp += iuse ;
	iuse= ( destp - buffer ) ;

	EVP_CIPHER_CTX_cleanup(&ctx);

		// round 2
	EVP_CipherInit_ex(&ctx, EVP_bf_cbc(), NULL, NULL, NULL, 0);
	EVP_CIPHER_CTX_set_key_length(&ctx, 10);
	EVP_CipherInit_ex(&ctx, NULL, NULL, key, iv, -1);

	destp= buffer2 ;

	EVP_CipherUpdate(&ctx, destp, &iuse2, buffer, iuse ) ;
	destp += iuse2 ;
	EVP_CipherFinal_ex(&ctx, destp, &iuse2) ;
	destp += iuse2 ;
	iuse2= ( destp - buffer2 ) ;

	EVP_CIPHER_CTX_cleanup(&ctx);

	EVP_cleanup() ;

	encode_asc85(printbuf, sizeof(printbuf), test, strlen(test) +1) ;
	printf("SRC: %s\n", printbuf) ;
	encode_asc85(printbuf, sizeof(printbuf), buffer, iuse) ;
	printf("ENC: %s\n", printbuf) ;
	encode_asc85(printbuf, sizeof(printbuf), buffer2, iuse2) ;
	printf("DEC: %s\n", printbuf) ;
}

