
CC=gcc
CFLAGS= -g

base85: base85.c asc85.o
	$(CC) $(CFLAGS) $< asc85.o -o $@

test: test.c asc85.o
	$(CC) $(CFLAGS) $< asc85.o -o $@

clean:
	rm -fr test base85 *.o

