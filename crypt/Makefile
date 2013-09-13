
all: xrand xevp

CC=gcc
CFLAGS=-g

xrand: testrand.c
	$(CC) $(CFLAGS) $< -lcrypto -lrt -o $@

xevp: testevp.c urand.o uasc.o
	$(CC) $(CFLAGS) $< urand.o uasc.o -lcrypto -lrt -o $@

clean:
	rm -fr xrand xevp *.o

