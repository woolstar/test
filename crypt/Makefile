
all: xrand xevp

xrand: testrand.c
	gcc $< -lcrypto -o $@

xevp: testevp.c
	gcc $< -lcrypto -o $@

clean:
	rm -fr xrand xevp

