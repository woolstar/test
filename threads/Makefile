
CC=gcc-4.8
CXX=g++-4.8
CFLAGS=-g -std=c++11
LIBS=-lstdc++ -lpthread

.cpp.o:
	$(CXX) $(CFLAGS) -c $<

.cpp:
	$(CXX) $(CFLAGS) $< $(LIBS) -o $@

TARGETS= threadcondwait threadatomic threadhandoff threadtest

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

