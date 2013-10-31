threads
====

Started working through the c++11 standard on threads.  Turns out the standard committee never intended people to use the primatives directly, but for them to be built into libraries, so took some simple ideas from my old thread library and worked up a couple of examples.

Tests compiled with GCC 4.6 (linux), GCC 4.7 (cygwin) and Visual Studio Express 2012 (windows).

* threadtest.cpp

	Simply make some threads and cleanup properly afterwards.  Had to workout how to initialize seperate random number generators.

* threadatomic.cpp

	Have two threads pull work from an atomic (non-blocking thread safe primative).  Ended up with horrors for sleeping since standard call not yet supported anywhere.

* threadcondwait.cpp

	Copied this example straight from the standards page just to confirm support.

* threadhandoff.cpp

	Build a primative (econduit) for passing work from multiple producers to one or more consumers.  No balancing mechanisms, but figured out how to use lamdas for building predicates that the conditional variable method needed.

* elist.h

	Experiments on my old list templates, eventually to be moved to tools.  Allows simple list traversal using auto-pointer-iterator sub-class.  Currently contains mixins for singlely linked, doubly linked, destoryer method and functional programming primatives.  Test suite uses c++11 standard lambdas to demonstrate the FP methods.

