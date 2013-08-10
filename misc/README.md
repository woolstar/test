misc
====

Simple tools and library tests.

##### Tools

* addl.c, addl.cs

	A simple command line tool which adds all the numbers input from stdin.  Shows the total when fed a blank line, or when the program exits.  Plans to implement in more languages as sort of my hello world.

* countdown.pl

	A timer with some simple progress feedback.  (Used for Ingress portal timers now that they're so variable.)

* pcalc.pl

	My own version of the unix stack based calculator 'dc'.  Added in some trig, e/log, and shortcuts for sqrts.
	Uses a data driven command set for easy expansion automatic help text generation.
	The code is the best documentation right now.  Also led to all kinds of work to get unicode support setup across machines so I could print the pi symbol.

* elist.h

	Experiments on my old list templates, eventually to be moved to tools.  Allows simple list traversal using auto-pointer-iterator sub-class.  CCurrently contains mixins for singlely linked, doubly linked, destoryer method and functional programming primatives.  Test suite uses c++11 standard lambdas to demonstrate the FP methods.

##### Thread tests

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

