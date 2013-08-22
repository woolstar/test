
all: xrand xevp

CC=gcc
CFLAGS=-g

xrand: testrand.c
	$(CC) $(CFLAGS) $< -lcrypto -o $@

xevp: testevp.c urand.o
	$(CC) $(CFLAGS) $< urand.o -lcrypto -o $@

clean:
	rm -fr xrand xevp

