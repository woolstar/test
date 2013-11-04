misc
====

Simple tools and library tests.

##### Tools

* addl.c, addl.cs, addl.js

	A simple command line tool which adds all the numbers input from stdin.  Shows the total when fed a blank line, or when the program exits.  Plans to implement in more languages as sort of my hello world.

* countdown.pl

	A timer with some simple progress feedback.  (Used for Ingress portal timers now that they're so variable.)

* nullhunt.c

	Read through files and look for nulls, summarizing where found and how many.

* nxtbook.pl

	Script generator for pulling PDFs from pages.nxtbook.com, used for reading EEtimes offline.

* pcalc.c

	My own version of the unix stack based calculator 'dc'.  Added in some trig, e/log, and shortcuts for sqrts.
	Uses a data driven command set for easy expansion automatic help text generation.
	The code is the best documentation right now.  Also led to all kinds of work to get unicode support setup across machines so I could print the pi symbol.

* randnum_y.html, randum_test.html

	Simple YUI/PureCSS dom nodes lib and a little progressive refinement layout.  Generates random digits (none repeating) for game email accounts.  Test version generates a couple rows of numbers between 1 and 5/10/50.

* sicp_sqrt.html

	Calculation of sqrt assigment from Structure and Interpretation of Computer Programs ([mitpress.mit.edu/sicp](http://mitpress.mit.edu/sicp/)), version one with fixed error test, and second with scaled error test.

* test_usock.c

	A Unix/domain socket server test program for testing file system interface to sockets.

* testcanvas.html

	Do some simple canvas drawing.

* testchaining.cpp

	A non-trivial example of using constructor chaining, and also hacking at unique_ptr<>

* testsort.cpp
* testsort2.cpp
* testsort3.cpp

	Test out various sorting algorithms using STL containers and raw version.  Coded with a datatype typedef so can be run with int/long/double/etc.  Some surprises on modern architectures.  Short answer though is use stl::sort(), though modern shell sort (Sedgewick) comes within a factor of 2 with no recursion or required memory.

	Gen 1 was very oldschool, with macros (ugh), self organizing units of work into a singleton list and a fair amount of cruft.  Gen 2 was a bit more clever, using gymnastics to assemble all the algorithms into a initializer_list.  Gen 3 moved the work class into more modern style of type erasure and helper polymorphic functions, as well as templating some of the sort routines.

* testspots.cpp

	Type erasure, with a const concept_t so there shouldn't be any variant state stored in the adapter helper object, but we do want to be able to change the concept mid stream, even from the helper (which is const), so throw around some mutable hacking to make it all pretty.

