
all: xrand xevp

CC=gcc
CFLAGS=-g

xrand: testrand.c
	$(CC) $(CFLAGS) $< -lcrypto -lrt -o $@

xevp: testevp.c urand.o
	$(CC) $(CFLAGS) $< urand.o -lcrypto -lrt -o $@

clean:
	rm -fr xrand xevp

